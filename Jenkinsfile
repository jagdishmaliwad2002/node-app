pipeline {
agent any

```
stages {

    stage('Clone Code') {
        steps {
            git branch: 'main', url: 'https://github.com/jagdishmaliwad2002/node-app.git'
        }
    }

    stage('Build Docker Image') {
        steps {
            sh '''
            docker build -t jack9005/node-app:latest .
            '''
        }
    }

    stage('Push Docker Image') {
        steps {
            sh '''
            docker push jack9005/node-app:latest
            '''
        }
    }

    stage('Run Test Container') {
        steps {
            sh '''
            docker rm -f test-container || true
            docker run -d -p 3001:3000 --name test-container jack9005/node-app:latest
            sleep 5
            curl localhost:3001
            '''
        }
    }

    stage('Deploy to Kubernetes') {
        steps {
            sh '''
            kubectl apply -f deployment.yaml
            kubectl apply -f service.yaml
            '''
        }
    }
}
```

}

