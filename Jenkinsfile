
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
        booleanParam(name: 'CHECK_SCRIPT', defaultValue: false, description: '¿Chequea script?')
        string(name: 'GIT_BRANCH_DESCARGA', defaultValue: '', description: 'Rama Gitlab (ej:feature_TSABloque1_DEV)')
    }

    // hacemos checkout del repositorio
    stages {
        stage('Checkout') {
            steps {
                script{
                    currentBuild.displayName = "${BUILD_NUMBER}, env ${CALYPSO_ENVIRONMENT}, rama ${GIT_BRANCH_DESCARGA}"
                    checkout([$class: 'GitSCM', branches: [[name: "${GIT_BRANCH_DESCARGA}"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'remoteGitTridente', url: '
                    https://github.com/charfo/marketbook.git']]])                    
                }
            }
        }
    }

}