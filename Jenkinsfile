pipeline {
    agent any

    tools {
        maven 'mvn-system-install'
        jdk 'jdk-system-install'
    }

    environment {
        AWS_REGION = "us-east-1"
        ECR_REGISTRY = "805187822135.dkr.ecr.us-east-1.amazonaws.com"
        ECR_REPO = "devops_workshop/boardgame"
        REPO_NAME = "${ECR_REGISTRY}/${ECR_REPO}"
        AWS_PROXY = "/usr/local/bin/aws-proxy.sh"
        EKS_CLUSTER_NAME = "eks-cluster-workshop-1"
        IMAGE_TAG = "${BUILD_NUMBER}"
        SONARQUBE = 'SonarQube-Jenkins'
    }
    
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ayantikanandi/Boardgame.git'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE}") {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        
        stage("Quality Gate") {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage('Compile') {
            steps { 
                sh 'mvn clean compile' 
            }
        }

        stage('Test') {
            steps { 
                sh 'mvn test' 
            }
        }

        stage('Package') {
            steps { 
                sh 'mvn package' 
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

    
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${REPO_NAME}:${IMAGE_TAG} ."
            }
        }
        
        stage('Trivy Scan') {
            steps {
                sh "trivy image ${REPO_NAME}:${IMAGE_TAG} --severity HIGH,CRITICAL --exit-code 1"
            }
        }

        stage('Verify AWS Identity') {
            steps {
                sh "${AWS_PROXY} aws sts get-caller-identity"
            }
        }

        stage('Login to ECR') {
            steps {
                sh """
                    ${AWS_PROXY} aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_REGISTRY}
                """
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                sh "docker push ${REPO_NAME}:${IMAGE_TAG}"
            }
        }
        

        stage('Deploy to EKS') {
            steps {
                sh """
                    ${AWS_PROXY} aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER_NAME}
                    sed -i 's|__IMAGE_TAG__|${REPO_NAME}:${IMAGE_TAG}|' boardgame-deployment.yaml
                    ${AWS_PROXY} kubectl apply -f boardgame-deployment.yaml
                """
            }
        }
        
        stage('Restart Deployment') {
            steps {
                sh """
                    ${AWS_PROXY} kubectl rollout restart deployment boardgame-app
                """
            }
        }
    }
}
