pipeline {
    agent any

    environment {
        IMAGE_NAME = "jack9005/node-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        CONTAINER_NAME = "test-container"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:$IMAGE_TAG .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push $IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Run Test Container') {
            steps {
                sh '''
                docker rm -f $CONTAINER_NAME || true

                docker run -d -p 3001:3000 --name $CONTAINER_NAME $IMAGE_NAME:$IMAGE_TAG

                echo "Waiting for app..."
                sleep 5

                docker logs $CONTAINER_NAME

                echo "Testing app..."
                docker exec $CONTAINER_NAME wget -qO- http://localhost:3000
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl set image deployment/node-app-deployment \
                node-app=$IMAGE_NAME:$IMAGE_TAG

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
