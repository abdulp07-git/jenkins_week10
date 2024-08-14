pipeline {
    agent any
    //triggers {
        //githubPush()
    //}
    environment {
        SONAR_ORG = 'abdulp07-git'
        SONAR_PROJECT_KEY = 'abdulp07-git_jenkins_week10'
        SONAR_TOKEN = credentials('SonarCloudToken')  // Retrieves the token stored as Jenkins credential
    	DOCKERHUB_USER = credentials('dockerhub-username')
        DOCKERHUB_PASS = credentials('dockerhub-password')
    }

    stages {
        stage('CheckOut') {
            steps {
                git 'https://github.com/abdulp07-git/jenkins-week9.git'
            }
        }
        stage('Unit Test') {  // New stage for unit testing
            steps {
                sh 'mvn test'  // Runs the unit tests
            }
            //post {
              //  always {
                //    junit '**/target/surefire-reports/*.xml'  // Publishes the test results
                //}
            //}
        }
        stage('SonarCloud analysis') {
            steps {
                withSonarQubeEnv('MySonarCloud') {
                    sh  '''
			#!/bin/bash
			mvn clean verify sonar:sonar \
                        -Dsonar.login=${SONAR_TOKEN} \
                        -Dsonar.host.url=https://sonarcloud.io \
                        -Dsonar.organization=${SONAR_ORG} \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY}
		    '''
                }
            }
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') { 
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage("Build") {
            steps {
                sh 'mvn clean package'
                archiveArtifacts artifacts: '**/target/*.war', allowEmptyArchive: true
            }
        }


	
	stage("Build docker image"){
            steps {
                script {
                    def dockerImage = "abdulp07/tomcat_pro"
                    def tag = "v${BUILD_NUMBER}"
                    def fullImageName = "${dockerImage}:${tag}"
                    sh "docker build -t ${fullImageName} ."
                }
            }
        }
        
        
        stage("Push Docker Image to Docker Hub"){
            steps {
                script {
                     def dockerImage = "abdulp07/tomcat_pro"
                     def tag = "v${BUILD_NUMBER}"
                     def fullImageName = "${dockerImage}:${tag}"
                    
                    
                    sh '''
                    #!/bin/bash
                    
         echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin
                    '''

                    sh "docker push ${fullImageName}"
                }
            }
        }





    
   }
}
