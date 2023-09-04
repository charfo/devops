
pipeline {

    agent any

    // options  del entorno a utilizar
    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    // parametros del entorno a utilizar
    parameters {
        choice(name: 'CALYPSO_ENVIRONMENT', choices: ['', 'development', 'certification','production'], description: 'Entorno Calypso')
        string(name: 'GIT_BRANCH_DESCARGA', defaultValue: '', description: 'Rama Gitlab (ej:feature_TSABloque1_DEV)')
        //Read params from json file
        //string(name: 'VERSION', defaultValue: '', description: 'Version de la aplicacion')

    }
    
    //Lectura de fichero properties
    environment {
        params = readJSON file: "environment_${CALYPSO_ENVIRONMENT}.json"        
    }


    // hacemos checkout del repositorio
    stages {
        stage ('Print variables'){
            steps {
                echo "CALYPSO_ENVIRONMENT: ${params.CALYPSO_ENVIRONMENT}"
                echo "GIT_BRANCH_DESCARGA: ${params.GIT_BRANCH_DESCARGA}"
                echo "CALYPSO_HOST_IP: ${params.CALYPSO_HOST_IP}"
            }

        }

        stage('Checkout') {
            steps {
                script{
                    currentBuild.displayName = "${BUILD_NUMBER}, env ${CALYPSO_ENVIRONMENT}, rama ${GIT_BRANCH_DESCARGA}"
                    checkout([$class: 'GitSCM', branches: [[name: "${GIT_BRANCH_DESCARGA}"]], 
                    doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], 
                    // userRemoteConfigs: [[credentialsId: 'remoteGitTridente',
                    url: 'https://github.com/charfo/marketbook.git'])
                }
            }
        }

        
        stage("Copy to calipso ${CALYPSO_ENVIRONMENT} files") {

            steps {
                withCredentials([usernamePassword(credentialsId: "${params.CREDENTIAL_HOST}", passwordVariable: 'user_pass', usernameVariable: 'user_name')]) {
                    sh '''
                        sshpass -p "$user_pass" scp -r ./denunciantes/target/denunciantes*.war "$user_name"@10.101.195.53:/home/US22111/sql_scripts/denunciantes.war
                    '''
                    echo "Files are on server and try to deploy the application"

                }   
        }

    }

    // finalizar el pipeline con ok 
    post {
        always {
            echo 'Finalizando ejecucion'
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