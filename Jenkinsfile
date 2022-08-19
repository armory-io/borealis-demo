pipeline {
    agent any
    stages {
        stage('Start Deploy') {
            agent {
                kubernetes {
                    containerTemplates{
                        containerTemplate{
                            image 'armory/armory-cli:latest'
                            name 'armory-cli'
                        }
                    }
                }
            }
            steps {
                git branch: 'main',
                    url: 'https://github.com/stephenatwell/borealis-demo-1.git'
                sh 'ls -lat'
                sh 'pwd'
                sh 'armory deploy start -f deploy.yml -c CLIENT_ID -s SECRET'
            }
        }
    }
}
