pipeline {
    agent any

    environment {
        GIT_REPO_URL = "https://github.com/azizkhalsi/angular-project.git"
        GIT_BRANCH = "hadil-amamou"
        DOCKER_IMAGE_NAME = "hadilapp"  // Docker image name
        DOCKER_TAG = "latest"
        DOCKER_HUB_USERNAME = "hamamou99"  // Docker Hub username
        DOCKER_HUB_PASSWORD = credentials('dockerhub-creds')  // Docker Hub credentials from Jenkins
        GITHUB_CREDENTIALS = credentials('github-creds')  // GitHub credentials from Jenkins
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the code from the GitHub repository using GitHub credentials
                git credentialsId: 'github-creds', url: GIT_REPO_URL, branch: GIT_BRANCH
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using the Dockerfile in the repo
                    sh """
                        docker build -t ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_TAG} .
                    """
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub using the credentials
                    sh """
                        echo ${DOCKER_HUB_PASSWORD} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin
                    """
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    sh """
                        docker push ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}
                    """
                }
            }
        }

        stage('Run Docker Compose') {
            steps {
                script {
                    // Ensure that Docker Compose is available on the Jenkins agent
                    // Run the docker-compose file using the built image
                    sh """
                        docker-compose down  # Stop any existing containers
                        docker-compose up -d  # Start containers using the Docker Compose file
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully! The Docker image has been built and pushed to Docker Hub."
        }

        failure {
            echo "Pipeline failed. Please check the logs."
        }

        always {
            // Clean up Docker resources (optional)
            sh "docker system prune -f"  // Cleans unused Docker resources
        }
    }
}
