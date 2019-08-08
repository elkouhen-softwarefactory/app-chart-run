#!groovy

// pod utilisé pour la compilation du projet
podTemplate(label: 'chart-run-pod', containers: [

        // le slave jenkins
        containerTemplate(name: 'jnlp', image: 'jenkinsci/jnlp-slave:alpine'),

        containerTemplate(name: 'helm', image: 'elkouhen/k8s-helm:2.9.1h', ttyEnabled: true, command: 'cat')],

        // montage nécessaire pour que le conteneur docker fonction (Docker In Docker)
        volumes: [hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock')]
) {

    node('chart-run-pod') {

        def charts = ['books-api', 'books-gui', 'h2']

        def envs = ['dev', 'prod']

        properties([
                parameters([
                        string(defaultValue: 'latest', description: 'Docker Image Tag', name: 'image'),
                        choice(choices: charts, description: 'Helm Chart', name: 'chart'),
                        string(defaultValue: '', description: 'Helm Chart Version', name: 'version')
                ])
        ])

        stage('CHECKOUT') {
            checkout scm;
        }

        container('helm') {

            stage('DEPLOY') {

                /* withCredentials([string(credentialsId: 'pgp_helm_pwd', variable: 'pgp_helm_pwd')]) {

                    configFileProvider([configFile(fileId: 'pgp-helm', targetLocation: "secret.asc")

                    ]) { */

                        String command = "./deploy.sh -c ${params.chart} "


                        if (params.image != '') {
                            command += "-i ${params.image} "
                        }

                        if (params.version != '') {
                            command += "-v ${params.version} "
                        }

                        sh "${command}"
                   /* }
                } */
            }
        }
    }
}
