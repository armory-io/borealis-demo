pipeline {
    agent any
    stages {
        stage('Checkout external proj') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/stephenatwell/borealis-demo-1.git'
                sh "ls -lat"
            }
        }
        stage('Start Deploy') {
            agent {
                kubernetes {
                        containerTemplate{
                            image 'armory/armory-cli:latest'
                            name 'armory-cli'
                            command 'armory deploy start -f deploy.yml -c $(CLIENT_ID) -s $(SECRET) && ls -lat $$ echo "done"'
                        }
                }
            }
            steps {
                sh "ls -lat"
            }
        }
    }
}
