@Library('jk_shared_lib@master') _

pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'eu-west-1'
		AWS_REGION = "eu-west-1"
		TG_BUCKET_PREFIX = "dm-acct"
    }

    parameters {
		// string(name: 'CREATE_NEW_VPC', defaultValue: '', description: 'Deploys VPC networking is with given name')
        // choice(name: 'VPC_MANAGEMENT', choices: ['view', 'update', 'delete'], description: 'Manage VPCs per environment')
		// choice(name: 'VPC_ENV', choices: ['dev', 'qa', 'prod'], description: 'Manage target environment')
		// choice(name: 'DEPLOYER_SVR', choices: ['start', 'stop'], description: 'We create AMI from this server')
		// booleanParam(name: 'Run_Packer', defaultValue: false, description: 'Run packer image builder')
		// choice(name: 'ENV_STATUS', choices: ['dev', 'qa', 'prod', 'all'], description: 'Get report status per environment')
		// choice(name: 'UPDATE_DNS', choices: ['true', 'false'], description: 'Points environment to subdomain')

        choice(name: 'AWS_ACCOUNT_NAME', choices: ['dm_acct', 'ph_acct'], description: 'Specify target account name')
		choice(name: 'Create_VPC_Environment', choices: ['', 'mgmnt', 'dev01', 'stage', 'prod', 'ALL'], description: 'Specify target Environment(vpc) name')
		choice(name: 'Destroy_VPC_Environment', choices: ['', 'destroy'], description: 'Destroy specific vpc')
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
		stage('Initial Infra Deploy'){
			steps {
				deleteDir() 
				when {
					expression { 
						params.Create_VPC_Environment == 'ALL' 
					}
				}
				checkout scm
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
						dir("./terragrunt/${AWS_ACCOUNT_NAME}/${env.AWS_REGION}"){
							sh "terragrunt apply-all -auto-approve --terragrunt-non-interactive"
						}
					} 
				}
			}	
		}

		// stage('Deploy Envs'){
		// 	steps {
		// 		deleteDir() 
		// 		when {
		// 			expression { 
		// 				params.Create_VPC_Environment != 'ALL' 

		// 			}
		// 		}
		// 		checkout scm
		// 		GitCheckout(
		// 			branch: "master", 
		// 			url: "https://github.com/spring-projects/spring-petclinic.git"
		// 		)
		// 		withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
		// 			credentialsId: 'dm_aws_keys',
		// 			accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
		// 			secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
		// 		]]) {
		// 			wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
		// 				dir("./terragrunt/${AWS_ACCOUNT_NAME}/${env.AWS_REGION}/${Create_VPC_Environment}"){
		// 					sh "terragrunt init"
		// 					sh "terragrunt destroy-all --terragrunt-non-interactive"
		// 				}
		// 			} 
		// 		}
		// 	}	
		// }

		stage('Destroy Envs'){
			steps {
				deleteDir() 
				when {
					expression { 
						params.Create_VPC_Environment == 'ALL' 
					}
				}
				checkout scm
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
						dir("./terragrunt/${AWS_ACCOUNT_NAME}/${env.AWS_REGION}"){
							sh "erragrunt destroy-all --terragrunt-non-interactive"
						}
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

        // stage ('Proceed To Deployment') {
        //     steps{
        //          input 'Deploy?'
        //     }
        // }

		// post {
		// 	always {
		// 		echo 'One way or another, I have finished'
		// 		deleteDir() /* clean up our workspace */
		// 	}
		// 	// success {
		// 	// 	slackSend baseUrl: 'https://xxxxxxxxxxxxhhhhjjk/services/hooks/jenkins-ci/', channel: '#ci', tokenCredentialId: 'slack', color: 'good', message: ":terraform: Terraform pipeline *finished successfully* :white_check_mark:\n>*Service:* `${env.UPSTREAM}` \n>*Account:* `${env.ACCOUNT}` \n>*Version*: `${env.VERSION}` \n>*ami-id*: `${env.AMIID}`\n>*Duration*: ${currentBuild.durationString.replaceAll('and counting','')}"
		// 	// }
		// 	// failure {
		// 	// 	slackSend baseUrl: 'https://xxxxxxxxxxnjhdjjjjj/services/hooks/jenkins-ci/', channel: '#ci', tokenCredentialId: 'slack', color: 'danger', message: ":terraform: Terraform pipeline *failed* :x:\n>*Service:* `${env.UPSTREAM}` \n>*Account:* `${env.ACCOUNT}` \n>*Version*: `${env.VERSION}` \n>*ami-id*: `${env.AMIID}`  \n>*Duration*: ${currentBuild.durationString.replaceAll('and counting','')}"
		// 	// }
		// }

    }	
}
