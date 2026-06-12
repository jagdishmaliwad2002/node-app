pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "jack9005/node-app:latest"
    }

    stages {

        stage('Clone Code') {
            steps {
                git branch: 'main', url: 'https://github.com/jagdishmaliwad2002/node-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Run Test Container') {
            steps {
                sh '''
                docker rm -f test-container || true
                docker run -d --name test-container $DOCKER_IMAGE
                sleep 5
                docker exec test-container curl localhost:3000
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
    }

    post {
        always {
            sh 'docker rm -f test-container || true'
        }
    }
}
