pipeline {
    agent any

    tools {
        maven 'Maven_3.8.7'
    }

    environment {
        SONARQUBE = 'SonarQube_Server'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/ayantikanandi/Boardgame.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE}") {
                    sh 'mvn sonar:sonar'
                }
            }
        }
    }
}
