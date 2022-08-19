pipeline {
    agent any
    stages {
        
        stage('Start Deploy image') {
            agent {
                kubernetes {
                
            containerTemplate{
                image 'mrnonz/alpine-git-curl:latest'
                name 'armory-cli'
                command '/bin/sh -c "git clone https://github.com/stephenatwell/borealis-demo-1.git; cd borealis-demo-1; curl -sL go.armory.io/get-cli | sh; /root/avm/bin/armory deploy start -f deploy.yml -c CLIENT_ID -s SECRET"'
            }
            //        defaultContainer 'maven'
            //        yamlFile 'jenkinsPod.yml'
                }
            }
            //tools {
            //    armory
            //}
            steps{
                sh 'armory deploy start -f deploy.yml -c CLIENT_ID -s SECRET'
            }
        }
    }
}
