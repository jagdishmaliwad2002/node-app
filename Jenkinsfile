pipeline {
    agent any

    environment {
        IMAGE_NAME = "jack9005/node-app"
        CONTAINER_NAME = "test-container"
    }

    stages {

        stage('Clone Code') {
            steps {
                git 'https://github.com/jagdishmaliwad2002/node-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:latest .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                docker push $IMAGE_NAME:latest
                '''
            }
        }

        stage('Run Test Container') {
            steps {
                sh '''
                docker rm -f $CONTAINER_NAME || true

                docker run -d -p 3001:3000 --name $CONTAINER_NAME $IMAGE_NAME:latest

                sleep 5

                echo "Checking container logs..."
                docker logs $CONTAINER_NAME

                echo "Testing app inside container..."
                docker exec $CONTAINER_NAME wget -qO- http://localhost:3000
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml

                kubectl rollout status deployment/node-app-deployment
                '''
            }
        }
    }

    post {
        always {
            sh '''
            docker rm -f $CONTAINER_NAME || true
            '''
        }
    }
}
