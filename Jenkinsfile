properties(
 [
  parameters (
    [
    booleanParam(name: 'wait', defaultValue: false, description: 'Wait for plan to finish'),
    string(name: 'kcli_config_yml', defaultValue: "kcli-config-yml", description: 'Secret File Credential storing your ~/.kcli/config.yml'),
    string(name: 'kcli_id_rsa', defaultValue: "kcli-id-rsa", description: 'Secret File Credential storing your private key'),
    string(name: 'kcli_id_rsa_pub', defaultValue: "kcli-id-rsa-pub", description: 'Secret File Credential container your public key'),
    string(name: 'image', defaultValue: "centos8", description: ''),
    string(name: 'openshift_image', defaultValue: "registry.svc.ci.openshift.org/ocp/release:4.4", description: ''),
    string(name: 'cluster', defaultValue: "openshift", description: ''),
    string(name: 'domain', defaultValue: "karmalabs.com", description: ''),
    string(name: 'keys', defaultValue: "[]", description: ''),
    string(name: 'api_ip', defaultValue: "", description: ''),
    string(name: 'dns_ip', defaultValue: "", description: ''),
    string(name: 'ingress_ip', defaultValue: "", description: ''),
    string(name: 'image_url', defaultValue: "", description: ''),
    string(name: 'network', defaultValue: "default", description: ''),
    string(name: 'pool', defaultValue: "default", description: ''),
    string(name: 'numcpus', defaultValue: "16", description: ''),
    string(name: 'masters', defaultValue: "[]", description: ''),
    string(name: 'workers', defaultValue: "[]", description: ''),
    string(name: 'memory', defaultValue: "32768", description: ''),
    string(name: 'disk_size', defaultValue: "30", description: ''),
    string(name: 'extra_disks', defaultValue: "[]", description: ''),
    string(name: 'rhnregister', defaultValue: "True", description: ''),
    string(name: 'rhnwait', defaultValue: "30", description: ''),
    string(name: 'provisioning_interface', defaultValue: "eno1", description: ''),
    string(name: 'provisioning_net', defaultValue: "provisioning", description: ''),
    string(name: 'provisioning_ip', defaultValue: "172.22.0.3", description: ''),
    string(name: 'provisioning_cidr', defaultValue: "172.22.0.0/24", description: ''),
    string(name: 'provisioning_range', defaultValue: "172.22.0.10,172.22.0.100", description: ''),
    string(name: 'provisioning_installer_ip', defaultValue: "172.22.0.253", description: ''),
    string(name: 'provisioning_macs', defaultValue: "[]", description: ''),
    string(name: 'provisioning_mac_prefix', defaultValue: "aa:aa:aa:aa:aa", description: ''),
    string(name: 'ipmi_user', defaultValue: "root", description: ''),
    string(name: 'ipmi_password', defaultValue: "calvin", description: ''),
    string(name: 'baremetal_net', defaultValue: "baremetal", description: ''),
    string(name: 'baremetal_cidr', defaultValue: "", description: ''),
    string(name: 'baremetal_macs', defaultValue: "[]", description: ''),
    string(name: 'baremetal_ips', defaultValue: "[]", description: ''),
    string(name: 'pullsecret', defaultValue: "openshift_pull.json", description: ''),
    string(name: 'notifyscript', defaultValue: "check.sh", description: ''),
    string(name: 'virtual', defaultValue: "False", description: ''),
    string(name: 'virtual_numcpus', defaultValue: "8", description: ''),
    string(name: 'virtual_memory', defaultValue: "32768", description: ''),
    string(name: 'cache', defaultValue: "True", description: ''),
    string(name: 'notify', defaultValue: "True", description: ''),
    string(name: 'deploy', defaultValue: "False", description: ''),
    string(name: 'wait_workers', defaultValue: "False", description: ''),
    string(name: 'disconnected', defaultValue: "False", description: ''),
    string(name: 'registry_user', defaultValue: "dummy", description: ''),
    string(name: 'registry_password', defaultValue: "dummy", description: ''),
    string(name: 'imageregistry', defaultValue: "False", description: ''),
    string(name: 'build', defaultValue: "False", description: ''),
    string(name: 'go_version', defaultValue: "1.13.8", description: ''),
    string(name: 'prs', defaultValue: "[]", description: ''),
    string(name: 'imagecontentsources', defaultValue: "[]", description: ''),
    ]
  )
 ]
)

pipeline {
    agent any
    environment {
     KCLI_CONFIG = credentials("${params.kcli_config_yml}")
     KCLI_SSH_ID_RSA = credentials("${params.kcli_id_rsa}")
     KCLI_SSH_ID_RSA_PUB = credentials("${params.kcli_id_rsa_pub}")
     KCLI_PARAMETERS = "-P image=${params.image} -P openshift_image=${params.openshift_image} -P cluster=${params.cluster} -P domain=${params.domain} -P keys=${params.keys} -P api_ip=${params.api_ip} -P dns_ip=${params.dns_ip} -P ingress_ip=${params.ingress_ip} -P image_url=${params.image_url} -P network=${params.network} -P pool=${params.pool} -P numcpus=${params.numcpus} -P masters=${params.masters} -P workers=${params.workers} -P memory=${params.memory} -P disk_size=${params.disk_size} -P extra_disks=${params.extra_disks} -P rhnregister=${params.rhnregister} -P rhnwait=${params.rhnwait} -P provisioning_interface=${params.provisioning_interface} -P provisioning_net=${params.provisioning_net} -P provisioning_ip=${params.provisioning_ip} -P provisioning_cidr=${params.provisioning_cidr} -P provisioning_range=${params.provisioning_range} -P provisioning_installer_ip=${params.provisioning_installer_ip} -P provisioning_macs=${params.provisioning_macs} -P provisioning_mac_prefix=${params.provisioning_mac_prefix} -P ipmi_user=${params.ipmi_user} -P ipmi_password=${params.ipmi_password} -P baremetal_net=${params.baremetal_net} -P baremetal_cidr=${params.baremetal_cidr} -P baremetal_macs=${params.baremetal_macs} -P baremetal_ips=${params.baremetal_ips} -P pullsecret=${params.pullsecret} -P notifyscript=${params.notifyscript} -P virtual=${params.virtual} -P virtual_numcpus=${params.virtual_numcpus} -P virtual_memory=${params.virtual_memory} -P cache=${params.cache} -P notify=${params.notify} -P deploy=${params.deploy} -P wait_workers=${params.wait_workers} -P disconnected=${params.disconnected} -P registry_user=${params.registry_user} -P registry_password=${params.registry_password} -P imageregistry=${params.imageregistry} -P build=${params.build} -P go_version=${params.go_version} -P prs=${params.prs} -P imagecontentsources=${params.imagecontentsources}"
     CONTAINER_OPTIONS = "--net host --rm --security-opt label=disable -v $HOME/.kcli:/root/.kcli -v $HOME/.ssh:/root/.ssh -v $PWD:/workdir -v /var/tmp:/ignitiondir"
     KCLI = "docker run ${CONTAINER_OPTIONS} karmab/kcli"
    }
    stages {
        stage('Prepare kcli environment') {
            steps {
                sh '''
                [ -d $HOME/.kcli ] && rm -rf $HOME/.kcli
                mkdir $HOME/.kcli
                cp "$KCLI_CONFIG" $HOME/.kcli/config.yml
                cp "$KCLI_SSH_ID_RSA" $HOME/.kcli/id_rsa
                chmod 600 $HOME/.kcli/id_rsa
                cp "$KCLI_SSH_ID_RSA_PUB" $HOME/.kcli/id_rsa.pub
                
                '''
            }
        }
        stage('Check kcli client') {
            steps {
                sh '${KCLI} list client'
            }
        }
        stage('Deploy kcli plan') {
            steps {
                script {
                  if ( "${params.wait}" == "true" ) {
                     WAIT = "--wait"
                  } else {
                     WAIT = ""
                  }
                }
                sh """
                  ${KCLI} create plan -f ${WORKSPACE}/kcli_plan.yml ${KCLI_PARAMETERS} ${WAIT} ${env.JOB_NAME}_${env.BUILD_NUMBER}
                """
            }
        }
    }
}