pipeline {
    agent any
    stages {
        stage('Start Deploy') {
            agent {
                kubernetes {
                    image 'armory/armory-cli:latest'
                        containerTemplates{
                            spec{
                                containers{
                                    env[
                                        {name 'CLIENT_ID'
                                         valueFrom{
                                             secretKeyRef{
                                                 key 'armory-client-id'
                                                 name 'armory-client-id'
                                             }
                                         }},
                                        {name  'SECRET'
                                            valueFrom{
                                                secretKeyRef{
                                                    key 'armory-secret'
                                                    name 'armory-secret'
                                                }
                                            }}
                                     ]
                                    image 'armory/armory-cli:latest'
                                    name armory-cli
                                }
                            }
                        }
            steps {
                sh 'armory deploy start -f deploy.yml -c $(CLIENT_ID) -s $(SECRET)'
            }
        }
    }
}
