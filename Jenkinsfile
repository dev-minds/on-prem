@Library('jk_shared_lib@master') _


pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'eu-west-1'
		AWS_REGION = "eu-west-1"
    }

    parameters {
		string(name: 'CREATE_NEW_VPC', defaultValue: '', description: 'Deploys VPC networking is with given name')
        choice(name: 'VPC_MANAGEMENT', choices: ['view', 'update', 'delete'], description: 'Manage VPCs per environment')
		choice(name: 'VPC_ENV', choices: ['dev', 'qa', 'prod'], description: 'Manage target environment')
		choice(name: 'DEPLOYER_SVR', choices: ['start', 'stop'], description: 'We create AMI from this server')
		booleanParam(name: 'Run_Packer', defaultValue: false, description: 'Run packer image builder')
		choice(name: 'ENV_STATUS', choices: ['dev', 'qa', 'prod', 'all'], description: 'Get report status per environment')
		string(name: 'UPDATE_HOSTEDZONE_IP', defaultValue: '', description: 'Points environment to subdomain')
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
		stage('VPC infra'){
			// agent { docker { image 'simonmcc/hashicorp-pipeline:latest'}}
			steps {
				checkout scm
				// GitCheckout(
				// 	branch: "master", 
				// 	url: "https://github.com/spring-projects/spring-petclinic.git"
				// )
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
						dir('./terraform/vpc_scaffold'){
							sh "terraform init"
							sh "terraform fmt"
							sh "terraform plan"
						}
					} 
				}
			}	
		}

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

		// stage('Bake AMI'){
		// 	agent { docker { image 'simonmcc/hashicorp-pipeline:latest'}}
		// 	steps {
		// 		checkout scm
		// 		withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
		// 			credentialsId: 'dm_aws_keys',
		// 			accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
		// 			secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
		// 		]]) {
		// 			wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
		// 				sh "packer build ./packer/base.json"
		// 				sh "aws ec2 describe-images --owners 023451010066 --filters \"Name=name,Values=base_*\" --query \'sort_by(Images, &CreationDate)[].Name\' --region eu-west-1"
		// 			} 
		// 		}
		// 	}
		// }

        stage ('Proceed To Deployment') {
            steps{
                 input 'Deploy?'
            }
        }		
    }	
}
