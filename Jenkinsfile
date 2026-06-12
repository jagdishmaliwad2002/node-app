pipeline {
agent any

```
environment {
    IMAGE_NAME = "node-app"
    IMAGE_TAG = "latest"
}

stages {

    stage('Clone Code') {
        steps {
            git 'https://github.com/jagdishmaliwad2002/node-app.git'
        }
    }

    stage('Build Docker Image') {
        steps {
            sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
        }
    }

    stage('Run Container Test') {
        steps {
            sh '''
            docker rm -f test-container || true
            docker run -d -p 3001:3000 --name test-container $IMAGE_NAME:$IMAGE_TAG
            sleep 5
            curl localhost:3001
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
```

}
