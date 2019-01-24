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
                    dockerImage = docker.build("awkspace/jenkdind:latest", "--pull .")
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
