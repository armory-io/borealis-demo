pipeline {
    agent any
    stages {
        
        stage('Start Deploy image') {
            //agent {
            //    kubernetes {
                
            //containerTemplate{
            //    image 'mrnonz/alpine-git-curl:latest'
            //    name 'armory-cli'
            //    command '/bin/sh -c "git clone https://github.com/stephenatwell/borealis-demo-1.git && cd borealis-demo-1 && pwd && curl -sL https://github.com/armory/armory-cli/releases/latest/download/armory-linux-amd64 > ./armory && chmod +x ./armory && ls -la && /bin/sh -c \'/borealis-demo-1/armory deploy start -f deploy.yml -c CLIENT_ID -s SECRET\'"'
            //}
            //        defaultContainer 'armory-cli'
            //        yamlFile 'jenkinsPod.yml'
            //        idleMinutes 1
            //    }
            //}
            tools{
                CustomTool 'armory'
            }
            steps{
                //container('armory-cli'){
                    sh 'echo $PATH'
                    sh 'ls -la /bin'
                    sh 'armory deploy start -f deploy.yml -c CLIENT_ID -s SECRET'
                //}
            }
        }
    }
}
