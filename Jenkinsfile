pipeline {
    agent any

    environment {
        FRONTEND_DIR = 'frontend'  // Directory for React frontend
        BACKEND_DIR = '.'    // Directory for Python backend
        DOCKER_IMAGE_FRONTEND = 'my-react-app'
        DOCKER_IMAGE_BACKEND_APP = 'my-python-api-app'
        DOCKER_IMAGE_BACKEND_SERVER = 'my-python-api-server'
        DOCKER_IMAGE_MYSQL = 'my-mysql-db'
        MYSQL_CONTAINER = 'mysql_db'
        PATH = "/usr/local/bin:${env.PATH}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout code from Git repository
                checkout scm
            }
        }

        stage('Test Docker') {
            steps {
                script {
                    // Check if Docker is installed and running
                    echo 'Checking Docker version and running containers...'
                    sh 'docker --version'  // Get Docker version
                    sh 'docker ps'         // List running containers
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    // Build Docker image for the frontend (React app)
                    echo 'Building Docker image for the frontend...'
                    sh 'docker build -t ${DOCKER_IMAGE_FRONTEND} -f Dockerfile .'

                    // Build Docker image for the backend app (app.py)
                    echo 'Building Docker image for the backend app...'
                    sh 'docker build -t ${DOCKER_IMAGE_BACKEND_APP} -f Dockerfile.app .'

                    // Build Docker image for the backend server (server.py)
                    echo 'Building Docker image for the backend server...'
                    sh 'docker build -t ${DOCKER_IMAGE_BACKEND_SERVER} -f Dockerfile.server .'

                    // Build Docker image for MySQL
                    echo 'Building Docker image for MySQL...'
                    sh 'docker build -t ${DOCKER_IMAGE_MYSQL} -f Dockerfile.mysql .'
                }
            }
        }

         stage('Run Containers with Docker Compose') {
    steps {
        script {
            echo 'Starting containers using Docker Compose...'
            // Run the multi-container setup using Docker Compose
            sh 'docker-compose up -d --build'
            
            // Ensure MySQL is ready before running tests
            echo 'Waiting for MySQL to be ready...'
            retry(5) {  // Retries up to 5 times in case MySQL is still starting
                sleep 5  // Wait for 5 seconds before checking again
                sh 'docker exec mysql_db mysqladmin ping -h mysql_db --silent || exit 1'
            }
        }
    }
}

        stage('Test Services') {
            parallel {
                stage('Test Frontend') {
                    steps {
                        script {
                            echo 'Running frontend tests...'
                            // Test if the React app is running on port 3000
                            sh 'curl --fail http://localhost:3000 || exit 1'
                        }
                    }
                }

                stage('Test Backend') {
                    steps {
                        script {
                            echo 'Running backend tests...'
                            // Test backend APIs on port 5000 and 5001
                            sh 'curl --fail http://localhost:5000 || exit 1'
                            sh 'curl --fail http://localhost:5001 || exit 1'
                            sh 'curl --fail http://localhost:5001/signup || exit 1'
                            sh 'curl --fail http://localhost:5001/login || exit 1'
                            sh 'curl --fail http://localhost:5001/protected || exit 1'
                        }
                    }
                }

                stage('Test MySQL') {
                    steps {
                        script {
                            echo 'Testing MySQL connection...'
                            // Test MySQL connection
                            sh 'docker exec ${MYSQL_CONTAINER} mysql -uroot -pnandhu01 -e "SHOW DATABASES;" || exit 1'
                        }
                    }
                }
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    // Optionally, clean up the containers after the tests
                    echo 'Cleaning up the containers...'
                    sh 'docker-compose down'
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker containers and images after the pipeline run
            echo 'Pruning Docker system...'
            sh 'docker system prune -af'
        }
    }
}
