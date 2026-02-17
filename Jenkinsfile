pipeline {
    agent {
        label "agentX"
    }
    stages {
        stage('Build') {
            steps {
                sh "pwd"
                sh "ls"
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