pipeline {
    agent any
    stages {
        stage('Start Deploy') {
            agent {
                kubernetes {
                    image 'armory/armory-cli:latest'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                }
            }
            steps {
                sh 'armory deploy start -f deploy.yml'
            }
        }
    }
}
