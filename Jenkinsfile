@Library('jk_shared_lib@master') _

pipeline {
    agent any

    parameters {
        choice(name: 'AWS_ACCOUNT_NAME', choices: ['dm_acct', 'ph_acct'], description: 'Specify target account name')
		choice(name: 'ALL_INFRA', choices: ['', 'all'], description: 'Specify to bring up all infra')
		choice(name: 'VPC_Environment', choices: ['', 'mgmnt', 'dev01', 'stage', 'prod', 'all'], description: 'Specify target Environment(vpc) name')
		choice(name: 'Destroy_VPC_Environment', choices: ['', 'destroy'], description: 'Destroy specific vpc')
    }
 
    environment {
        AWS_DEFAULT_REGION = 'eu-west-1'
		AWS_REGION = "eu-west-1"
		TG_BUCKET_PREFIX = "dm-acct"
    }

    options {
		buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
		disableConcurrentBuilds()
    }


    stages {
		stage('Create All VPC'){
			when {
				expression {
					params.ALL_INFRA == "all"
				}
			}
			steps {
				deleteDir() 
				checkout scm
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
						dir("./terragrunt/${AWS_ACCOUNT_NAME}/${env.AWS_REGION}/"){
							sh "terragrunt apply-all -auto-approve --terragrunt-non-interactive"
						}
					} 
				}
			}	
		}
		
		stage('Create Target VPC'){
			when {
				expression {
					params.VPC_Environment != ""
				}
			}
			steps {
				deleteDir() 
				checkout scm
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
						dir("./terragrunt/${AWS_ACCOUNT_NAME}/${env.AWS_REGION}/${params.Create_VPC_Environment}"){
							sh "terragrunt apply-all -auto-approve --terragrunt-non-interactive"
						}
					} 
				}
			}	
		}

		stage('Destroy Specific Envs'){
			when {
				expression { 
					params.Destroy_VPC_Environment == 'destroy' 
				}
			}
			steps {
				deleteDir()
				checkout scm
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
						dir("./terragrunt/${AWS_ACCOUNT_NAME}/${env.AWS_REGION}/${params.Create_VPC_Environment}"){
							sh "ls -a"
							sh "terragrunt destroy-all --terragrunt-non-interactive"
						}
					} 
				}
			}	
		}	
		stage('Destroy All Envs'){
			when { 
				{ params.ALL_INFRA == 'all' }
					anyof { 
						params.Destroy_VPC_Environment == 'destroy' 
				}
			}
			steps {
				deleteDir()
				checkout scm
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
						dir("./terragrunt/${AWS_ACCOUNT_NAME}/${env.AWS_REGION}/${params.Create_VPC_Environment}"){
							sh "ls -a"
							sh "terragrunt destroy-all --terragrunt-non-interactive"
						}
					} 
				}
			}	
		}	
	}
	post {
		always {
			// One or more steps need to be included within each condition's block.
			echo 'In any case im done here' 
		}
	}
}
