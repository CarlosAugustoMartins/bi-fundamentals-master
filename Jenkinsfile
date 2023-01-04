pipeline {

    agent any


stages {

    stage ('List files') {
        steps {
            script {
                sh 'ls'
            }
        }
    }

stage ('Execute Docker Compose') {
        steps {
            script {
                sh 'docker compose up'
            }
        }
    }




}


}