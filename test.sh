pipeline {
    agent agentX
    stages {
        stage('Build') {
            steps {
                echo "pwd"
            }
        }
        stage('Test') {
            steps {
                echo "testing"
            }
        }
        stage('Deploy') {
            steps {
                echo "deploy"
            }
        }
    }
}