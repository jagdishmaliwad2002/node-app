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

                echo "Waiting for container to start..."
                sleep 10

                echo "Container logs:"
                docker logs test-container

                echo "Testing application inside container..."
                for i in {1..10}; do
                  docker exec test-container curl -f http://localhost:3000 && exit 0
                  echo "Retrying..."
                  sleep 2
                done

                echo "App test failed!"
                exit 1
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
