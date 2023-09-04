
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
 

    //Lectura de fichero .properties de las propiedades
    environment {

        def envProps = readProperties file: "resources/environment_${CALYPSO_ENVIRONMENT}.properties"

    }


    // hacemos checkout del repositorio
    stages {
        stage ('Print variables'){
            steps {
                echo "CALYPSO_ENVIRONMENT: ${CALYPSO_ENVIRONMENT}"
                echo "GIT_BRANCH_DESCARGA: ${GIT_BRANCH_DESCARGA}"
                echo "envProps: ${envProps}"
                echo "env: ${env}"
                echo "env: ${envProps.CALYPSO_HOME_SOURCES_DIR}"

            }

        }
    
        stage('Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM',
                              branches: [[name: 'feature1']],
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
                    host = envProps.CALYPSO_HOST_IP
                    directory = envProps.CALYPSO_HOME_SOURCES_DIR
                    credentialsIdProp = envProps.CREDENTIAL_HOST_ID
                    echo "host: ${host}"
                    echo "directory: ${directory}"
                    echo "credentialsIdProp: ${credentialsIdProp}"
                    withCredentials([usernamePassword(credentialsId: "${credentialsIdProp}", passwordVariable: 'user_pass', usernameVariable: 'user_name')]) {
                            //sh '''sshpass -p "$user_pass" scp -r ./sources.tar.gz "$user_name"@"$host":"$directory"/sources.tar.gz'''
                            echo "Commando a ejecutar"
                            echo '''sshpass -p "$user_pass" scp -r ./sources.tar.gz "$user_name"@"$host":"$directory"/sources.tar.gz'''
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