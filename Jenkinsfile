pipeline {
    agent any
    stages {
        stage('Checkout external proj') {
            steps {
                git branch: 'my_specific_branch',
                    credentialsId: 'my_cred_id',
                    url: 'ssh://git@test.com/proj/test_proj.git'
                sh "ls -lat"
            }
        },
        stage('Start Deploy') {
            agent {
                kubernetes {
                        containerTemplate{
                            image 'armory/armory-cli:latest'
                            name 'armory-cli'
                            command 'armory deploy start -f deploy.yml -c $(CLIENT_ID) -s $(SECRET)'
                        }
                }
            }
            steps {
                sh 'armory deploy start -f deploy.yml -c $(CLIENT_ID) -s $(SECRET)'
            }
        }
    }
}
