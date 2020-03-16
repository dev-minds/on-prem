pipeline {
    agent any
 
    options {
		buildDiscarder(logRotator(numToKeepStr: '50', artifactNumToKeepStr: '50'))
		disableConcurrentBuilds()
		timestamps()
		timeout 240 // minutes
		//ansiColor('xterm')
		skipDefaultCheckout()
    }

    stages {
		stage('Test Comand'){
			agent { docker { image 'simonmcc/hashicorp-pipeline:latest'}}
	    	// agent { docker { image 'simonmcc/hashicorp-pipeline:latest'}}
	    	steps {
				checkout scm 
				sh "ls -al"
	    	}
		}

		stage('Test Conn'){
			agent { docker { image 'simonmcc/hashicorp-pipeline:latest'}}
			steps {
				checkout scm
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
						sh "aws ec2 describe-instances --region eu-west-1"
					} 
				}
			}
		}
		
    }	
}
