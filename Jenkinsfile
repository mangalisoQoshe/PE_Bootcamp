pipeline {
    agent {
        label "agentX"
    }


    options {
        timestamps()                  // Add timestamps to logs
        timeout(time: 30, unit: 'MINUTES')  // Abort if pipeline takes too long
       
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh "chmod 755 ./build.sh ./test.sh"
            }
        }

        stage('Build & Tag') {
            steps {
                sh "./build.sh"
            }
        }

        stage('Test') {
            steps {
                sh "./test.sh"
            }
        }

        stage('Push to DockerHub') {
            environment {
                DOCKERHUB_CREDS = credentials("Dockerhub creds")
            }
            steps {
                sh "echo ${DOCKERHUB_CREDS_PSW} | docker login -u ${DOCKERHUB_CREDS_USR} --password-stdin"
                sh "./build.sh push"
                sh "echo '✅ Image pushed to Docker Hub'"
            }
        }
    }

    post {
        always {
            // Always logout from Docker regardless of pipeline result
            sh "docker logout || true"
            // Clean up dangling images
            sh "docker image prune -f || true"
            //cleanWs()
        }
        success {
            echo "Pipeline succeeded!"
            
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}