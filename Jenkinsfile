pipeline {
    agent any
    stages {
        stage('Start Deploy') {
            agent {
                kubernetes {
                        containerTemplate{
                            image 'armory/armory-cli:latest'
                            name 'armory-cli'
                            command '/bin/sh -c "ls && armory deploy start -f deploy.yml -c $(CLIENT_ID) -s $(SECRET) && echo done"'
                        }
                }
            }
            steps {
                git branch: 'main',
                    url: 'https://github.com/stephenatwell/borealis-demo-1.git'
                sh "ls -lat"
            }
        }
    }
}
