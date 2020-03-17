pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'eu-west-1'
		AWS_REGION = "eu-west-1"
    }
 
    options {
		buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
		disableConcurrentBuilds()
		// timestamps()
		// timeout 240 // minutes
		//ansiColor('xterm')
		// skipDefaultCheckout()
    }

    stages {
		stage('Validate Packer'){
			agent { docker { image 'simonmcc/hashicorp-pipeline:latest'}}
			steps {
				checkout scm
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
						sh "packer validate ./packer/base.json"
					} 
				}
			}
		}

		stage('Bake AMI'){
			agent { docker { image 'simonmcc/hashicorp-pipeline:latest'}}
			steps {
				checkout scm
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
						sh "packer build ./packer/base.json"
						sh "aws ec2 describe-images --owners 023451010066 --filters \"Name=name,Values=base_*\" --query \'sort_by(Images, &CreationDate)[].Name\' --region eu-west-1"
					} 
				}
			}
		}

        stage ('Proceed To Deployment') {
            steps{
                 input 'Deploy?'
            }
        }		
    }	
}
