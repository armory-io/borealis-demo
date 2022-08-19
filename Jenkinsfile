pipeline {
    agent any
    stages {
        
        stage('Start Deploy image') {
            agent {
                kubernetes {
                    
                    defaultContainer 'maven'
                    yamlFile 'jenkinsPod.yml'
                }
            }
            steps{
            }
        }
    }
}
