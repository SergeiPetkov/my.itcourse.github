pipeline {
    agent {
      label 'slave1'
    }

    environment {
        project_version = "1.0.${BUILD_NUMBER}"
        TIMESTAMP = new Date().format("yyyyMMddHHmm")
        IMAGE_TAG = "${project_version}-${TIMESTAMP}"
        DOCKER_PASS = credentials('my-docker')
        REPO_NAME = "sergeypetkov" //Репозиторий докер хаба
        REMOTE_APP_DIR = "simple-django-project" //Директория с django приложением
        REMOTE_HOST = "usr1@192.168.1.210" // Хост
    }
        

    stages {
        stage('Getting variables for test') {
            steps {
                script {
                    // Groovy-код
                    sh 'env'
                    echo "Project Version: ${project_version}"
                    //def timestamp1 = new Date().format("yyyyMMddHHmm")
                    echo "Time Stamp: ${TIMESTAMP}"
                    //def IMAGE_TAG = "${project_version}-${timestamp1}"
                    echo "Image Tag: ${IMAGE_TAG}"
                    //DOCKER_PASS = credentials('my-docker')
                    //echo "Image Tag: ${DOCKER_PASS}"
                    echo "Repo name: ${REPO_NAME}"
                    echo "App dir: ${REMOTE_APP_DIR}"
                    echo "Repo name: ${REMOTE_HOST}"
                }
            }
        }
        
        stage('Checkout repository') {
            steps {
                script {
                    git branch: 'deploy', url: "https://github.com/SergeiPetkov/${REMOTE_APP_DIR}.git"
                    //WORKSPACE=/home/jenkins/workspace/my-first-item
                    sh 'ls -la'
                    sh 'sed -e "s/my-new-version/${IMAGE_TAG}/g" ~/workspace/${JOB_BASE_NAME}/templates/signup.html.tpl > ~/workspace/${JOB_BASE_NAME}/templates/signup.html'
                }
            }    
        }
        
         stage('Build Docker Image') {
            steps {
                script {
                    sh 'whoami'
                    //sh 'ls -la'
                    sh 'docker build  -t ${REPO_NAME}/django:${IMAGE_TAG} .'
                }
            }    
        }
        
        stage('Push Docker Image to registry') {
            steps {
                script {
                    //sh 'ls -la'
                    sh 'echo ${DOCKER_PASS} | docker login --username ${REPO_NAME} --password-stdin'
                    sh 'docker push ${REPO_NAME}/django:${IMAGE_TAG}'
                }
            }    
        }
        
        stage('Docker compose up') {
            steps {
                sshagent(credentials: ['node-ubuntu']) {
                //sshagent(['node-ubuntu']) {
                    //sh "ip a"
                    //sh 'ssh usr1@192.168.1.210 "whoami"'
                    sh 'scp -o StrictHostKeyChecking=accept-new ~/workspace/${JOB_BASE_NAME}/compose.yaml ${REMOTE_HOST}:~/${REMOTE_APP_DIR}'
                    sh 'ssh ${REMOTE_HOST} "TAG=${IMAGE_TAG} docker compose -f ~/${REMOTE_APP_DIR}/compose.yaml up -d --build"'
                }
            }
        }    
    }
}