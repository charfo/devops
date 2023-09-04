
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
        stage('SSH copy sources remote host') {
            steps {
                
            }
            steps {
                script{
                    sshPublisher(publishers: [sshPublisherDesc(configName: 'calypso-ssh', transfers: [sshTransfer(execCommand: 'ls -la', execTimeout: 120000, 
                    flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/home/charfo', 
                    remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'pom.xml', 
                    sourceFilesSDF: false, usePty: false)])])
                }
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