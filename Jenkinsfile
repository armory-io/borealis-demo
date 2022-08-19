pipeline {
    agent any
    stages {
        stage('Start Deploy') {
            agent {
                kubernetes {
                    containerTemplates [
                        containerTemplate{
                            image 'armory/armory-cli:latest'
                        }
                    ]
                }
            }
            steps {
                sh 'armory deploy start -f deploy.yml -c $(CLIENT_ID) -s $(SECRET)'
            }
        }
    }
}
