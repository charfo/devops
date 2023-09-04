
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
    }
    
    //Lectura de fichero properties


    // hacemos checkout del repositorio
    stages {
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

        
        stage("Copy to calipso des files") {

            when {
                expression { params.CALYPSO_ENVIRONMENT == 'development' }
            }            
            steps {
                withCredentials([usernamePassword(credentialsId: 'US22111_DES', passwordVariable: 'pwdUS22111', usernameVariable: 'userUS22111')]) {
                    sh '''
                        sshpass -p "$pwdUS22111" scp -r ./denunciantes/target/denunciantes*.war "$userUS22111"@10.101.195.53:/home/US22111/sql_scripts/denunciantes.war
                    '''
                    echo "Files are on server and try to deploy the application"
                    sh """
                        sshpass -p "$pwdUS22111" ssh -o StrictHostKeyChecking=no "$userUS22111"@10.101.195.53 << EOF
                        ./script_despliegue/deploy.sh "DES" "${VERSION}"
					"""
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