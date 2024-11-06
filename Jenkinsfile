pipeline {
    agent any

    environment {
        IMAGE_NAME = "hadil-app"
        DOCKER_HUB_REPO = "hamamou99/${IMAGE_NAME}"
        SONARQUBE_SERVER = 'sonarqube'  // Name of your SonarQube server configured in Jenkins
        SONARQUBE_PROJECT_KEY = 'hadil-app'  // Your project key in SonarQube
        SONARQUBE_PROJECT_NAME = 'hadil App'  // Your project name in SonarQube
        SONARQUBE_LOGIN = credentials('sonarqube-token')  // Jenkins credential for SonarQube token
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the code from your repository
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Run SonarQube analysis
                    withSonarQubeEnv(SONARQUBE_SERVER) {
                        sh """
                            sonar-scanner \
                            -Dsonar.projectKey=${SONARQUBE_PROJECT_KEY} \
                            -Dsonar.projectName=${SONARQUBE_PROJECT_NAME} \
                            -Dsonar.login=${SONARQUBE_LOGIN}
                        """
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                script {
                    // Tag the Docker image for Docker Hub
                    sh "docker tag ${IMAGE_NAME} ${DOCKER_HUB_REPO}:latest"
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Use Docker Hub credentials to log in and push the image
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        sh '''
                        echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin
                        docker push ${DOCKER_HUB_REPO}:latest
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Docker image pushed successfully to Docker Hub."
        }
        failure {
            echo "Pipeline failed. Please check the logs."
        }
        cleanup {
            // Optional: Clean up unused Docker resources
            sh "docker system prune -f"
        }
    }
}
