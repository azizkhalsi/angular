pipeline {
    agent any

    environment {
        IMAGE_NAME = "hadil-app"
        DOCKER_HUB_REPO = "hamamou99/${IMAGE_NAME}"
        SONARQUBE_SERVER = 'sonarqube'  // Name of your SonarQube server configured in Jenkins
        SONARQUBE_PROJECT_KEY = 'hadil-app'  // Your SonarQube project key
        SONARQUBE_PROJECT_NAME = 'Hadil App'  // Your SonarQube project name
        SONARQUBE_LOGIN = credentials('sonar-token')  // Jenkins credential for SonarQube token
    }

    stages {
        // Stage to checkout code from GitHub
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        // Stage 5: Analyze Code with SonarQube using Maven
        stage('MVN SonarQube') {
            steps {
                script {
                    withSonarQubeEnv('sonarqube') {  // Use the SonarQube server configured in Jenkins
                        withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                            sh '''
                                mvn sonar:sonar \
                                    -Dsonar.projectKey=${SONARQUBE_PROJECT_KEY} \
                                    -Dsonar.projectName=${SONARQUBE_PROJECT_NAME} \
                                    -Dsonar.host.url=http://192.168.154.130:9000 \
                                    -Dsonar.login=${SONAR_TOKEN} \
                                    -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml
                            '''
                        }
                    }
                }
            }
        }

        // Stage: Quality Gate Check
        stage('Quality Gate') {
            steps {
                script {
                    // Wait for the Quality Gate result
                    def qg = waitForQualityGate()
                    if (qg.status != 'OK') {
                        error "Quality Gate failed: ${qg.status}"
                    } else {
                        echo "Quality Gate passed: ${qg.status}"
                    }
                }
            }
        }

        // Stage: Build Docker Image
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        // Stage: Tag Docker Image
        stage('Tag Docker Image') {
            steps {
                script {
                    // Tag the Docker image for Docker Hub
                    sh "docker tag ${IMAGE_NAME} ${DOCKER_HUB_REPO}:latest"
                }
            }
        }

        // Stage: Push Docker Image to Docker Hub
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
