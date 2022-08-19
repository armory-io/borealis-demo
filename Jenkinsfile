pipeline {
    agent any
    stages {
        
        stage('Start Deploy image') {
            agent {
                kubernetes {
                        containerTemplate{
                            image 'armory/armory-cli:latest'
                            name 'armory-cli'
                            command '/bin/sh -c "git clone https://github.com/stephenatwell/borealis-demo-1.git; pwd; ls; armory deploy start -f deploy.yml -c CLIENT_ID -s SECRET"'
                        }
                }
            }
            steps {
                git branch: 'main',
                    url: 'https://github.com/stephenatwell/borealis-demo-1.git'
                sh 'ls -lat /usr/local/bin'
                sh 'pwd'
                sh 'armory deploy start -f deploy.yml -c CLIENT_ID -s SECRET'
            }
        }
    }
}
