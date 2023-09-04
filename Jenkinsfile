
pipeline {

    agent any

    // options  del entorno a utilizar
    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    // parametros del entorno a utilizar
    parameters {
        choice(name: 'CALYPSO_ENVIRONMENT',  choices: ['', 'development', 'certification','production'], description: 'Entorno Calypso')
        string(name: 'GIT_BRANCH_DESCARGA',  description: 'Rama Gitlab (ej:feature_TSABloque1_DEV)', trim: true, defaultValue: 'feature1')
        //Read properteis and assign al to variable

    }
 


    // hacemos checkout del repositorio
    stages {
        stage ('Print variables parameter'){
            steps {
                echo "CALYPSO_ENVIRONMENT: ${CALYPSO_ENVIRONMENT}"
                echo "GIT_BRANCH_DESCARGA: ${GIT_BRANCH_DESCARGA}"
                script {
                    def props = readProperties file: "resources/environment_${CALYPSO_ENVIRONMENT}.properties"
                    env.CALYPSO_HOST_IP = props.CALYPSO_HOST_IP
                    env.CALYPSO_HOME_SOURCES_DIR = props.CALYPSO_HOME_SOURCES_DIR
                    env.CREDENTIAL_HOST_ID = props.CREDENTIAL_HOST_ID
                    env.CALYPSO_HOME_SOURCES_DIR = props.CALYPSO_HOME_SOURCES_DIR
                }
            }
        }
    
        stage('Checkout sources') {
            steps {
                script {
                    checkout([$class: 'GitSCM',
                              branches: [[name: "${GIT_BRANCH_DESCARGA}"]],
                              userRemoteConfigs: [[url: 'https://github.com/charfo/marketbook.git']]
                              ])
                }
                script{
                     sh '''
                        tar -zcvf sources.tar.gz --exclude='./.git'  **
                    '''
                }

            }
        }
       
        stage("Copy to calipso environment the files") {

            steps {
                script {
                    // Assign properties to variables
                    host = env.CALYPSO_HOST_IP
                    directory = env.CALYPSO_HOME_SOURCES_DIR
                    credentialsIdProp = env.CREDENTIAL_HOST_ID
                    echo "host: ${host}"
                    echo "directory: ${directory}"
                    echo "credentialsIdProp: ${credentialsIdProp}"
                    withCredentials([usernamePassword(credentialsId: "${credentialsIdProp}", passwordVariable: 'user_pass', usernameVariable: 'user_name')]) {
                            //sh '''sshpass -p "$user_pass" scp -r ./sources.tar.gz "$user_name"@"$host":"$directory"/sources.tar.gz'''
                            echo "Commando a ejecutar"
                            echo '''
                                sshpass -p "$user_pass" scp -r ./sources.tar.gz "$user_name"@"$host":"$directory"/sources.tar.gz
                            '''
                            echo "Files are on server and try to deploy the application"                   
                            
                    }   
                }                
            }
        }
    }

    // finalizar el pipeline con ok 
    post {
        always {
            echo 'Finalizando ejecucion del job'
        }
        success {
            echo 'Ejecucion exitosa'
        }
        failure {
            echo 'Ejecucion fallida'
        }
        unstable {
            echo 'Ejecucion inestable'
        }
        changed {
            echo 'Ejecucion cambiada'
        }
    }

}