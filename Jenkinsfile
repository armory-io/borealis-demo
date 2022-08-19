pipeline {
    agent any
    stages {
        stage('Start Deploy') {
            agent {
                kubernetes {
                        containerTemplate{
                            image 'armory/armory-cli:latest'
                            name 'armory-cli'
                            command 'ls'
                        }
                }
            }
            steps {
                sh 'armory deploy start -f deploy.yml -c $(CLIENT_ID) -s $(SECRET)'
            }
        }
    }
}
