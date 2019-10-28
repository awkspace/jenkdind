pipeline {

    environment {
        dockerImage = ''
        registryCredentials = 'dockerhub'
    }

    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    dockerImage = docker.build("awkspace/jenkdind:latest", "--pull --no-cache .")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', registryCredentials) {
                        dockerImage.push()
                    }
                }
            }
        }
    }

}
