#!/usr/bin/env bash

cd /root
export PATH=/root/bin:$PATH
export OCP_RELEASE="$(/root/bin/openshift-baremetal-install version | head -1 | cut -d' ' -f2 | cut -d'.' -f 1,2)"
{% if disconnected_operators_version != None %}
export OCP_RELEASE="{{ disconnected_operators_version }}"
{% endif %}
export OCP_PULLSECRET_AUTHFILE='/root/openshift_pull.json'
{% if disconnected_url != None %}
{% set registry_port = disconnected_url.split(':')[-1] %}
{% set registry_name = disconnected_url|replace(":" + registry_port, '') %}
REGISTRY_NAME={{ registry_name }}
REGISTRY_PORT={{ registry_port }}
{% else %}
PRIMARY_NIC=$(ls -1 /sys/class/net | grep 'eth\|en' | head -1)
IP=$(ip -o addr show $PRIMARY_NIC | head -1 | awk '{print $4}' | cut -d'/' -f1)
REGISTRY_NAME=$(echo $IP | sed 's/\./-/g' | sed 's/:/-/g').sslip.io
REGISTRY_PORT={{ 8443 if disconnected_quay else 5000 }}
{% endif %}
export LOCAL_REGISTRY=$REGISTRY_NAME:$REGISTRY_PORT
export IMAGE_TAG=olm

# Add extra registry keys
curl -o /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-isv https://www.redhat.com/security/data/55A34A82.txt
jq ".transports.docker += {\"registry.redhat.io/redhat/certified-operator-index\": [{\"type\": \"signedBy\",\"keyType\": \"GPGKeys\",\"keyPath\": \"/etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-isv\"}], \"registry.redhat.io/redhat/community-operator-index\": [{\"type\": \"signedBy\",\"keyType\": \"GPGKeys\",\"keyPath\": \"/etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-isv\"}], \"registry.redhat.io/redhat/redhat-marketplace-operator-index\": [{\"type\": \"signedBy\",\"keyType\": \"GPGKeys\",\"keyPath\": \"/etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-isv\"}]}" < /etc/containers/policy.json > /etc/containers/policy.json.new
mv /etc/containers/policy.json.new /etc/containers/policy.json

# Login registries
REGISTRY_USER={{ "init" if disconnected_quay else disconnected_user }}
REGISTRY_PASSWORD={{ "super" + disconnected_password if disconnected_quay and disconnected_password|length < 8 else disconnected_password }}
podman login -u $REGISTRY_USER -p $REGISTRY_PASSWORD $LOCAL_REGISTRY
#podman login registry.redhat.io --authfile /root/openshift_pull.json
REDHAT_CREDS=$(cat /root/openshift_pull.json | jq .auths.\"registry.redhat.io\".auth -r | base64 -d)
RHN_USER=$(echo $REDHAT_CREDS | cut -d: -f1)
RHN_PASSWORD=$(echo $REDHAT_CREDS | cut -d: -f2)
podman login -u "$RHN_USER" -p "$RHN_PASSWORD" registry.redhat.io

which oc-mirror >/dev/null 2>&1
if [ "$?" != "0" ] ; then
  curl -sL https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/oc-mirror.tar.gz | tar xvz -C /usr/bin
  chmod +x /usr/bin/oc-mirror
fi

mkdir -p /root/.docker
cp -f /root/openshift_pull.json /root/.docker/config.json

export DISCONNECTED_PREFIX=openshift/release
envsubst < /root/scripts/mirror-config.yaml.sample > /root/mirror-config.yaml

rm -rf /root/oc-mirror-workspace || true
oc-mirror --config /root/mirror-config.yaml --max-per-registry 20 --ignore-history docker://$LOCAL_REGISTRY || oc-mirror --config /root/mirror-config.yaml --max-per-registry 20 --ignore-history docker://$LOCAL_REGISTRY || oc-mirror --config /root/mirror-config.yaml --max-per-registry 20 --ignore-history docker://$LOCAL_REGISTRY | tee /tmp/mirror-registry-output 

# When there are no new images to be mirrored, oc-mirror will not generate the icsp and catalogsource files, so we need to get them generated by ourselves
if [ $(grep -c "No new images detected" /tmp/mirror-registry-output) -eq 1 ] ; then
  # If no new images, we will generate the icsp and catalogsource from the mapping file generated by the command below
  oc-mirror --config /root/mirror-config.yaml --max-per-registry 20 --ignore-history --dry-run docker://$LOCAL_REGISTRY
  # Above command generates this file /root/oc-mirror-workspace/mapping.txt, we create a folder for our results
  mkdir -p /root/oc-mirror-workspace/results-mapping/
  # We run the python script that reads the mapping.txt and the mirror-config file to output the icsp and the catalogsource
  python3 /root/bin/mapping_to_icsp.py -m /root/oc-mirror-workspace/mapping.txt -o /root/oc-mirror-workspace/results-mapping/ -c /root/mirror-config.yaml
fi

oc apply -f /root/oc-mirror-workspace/results-*/*imageContentSourcePolicy.yaml 2>/dev/null || cp /root/oc-mirror-workspace/results-*/*imageContentSourcePolicy.yaml /root/manifests
oc apply -f /root/oc-mirror-workspace/results-*/*catalogSource* 2>/dev/null || cp /root/oc-mirror-workspace/results-*/*catalogSource* /root/manifests
