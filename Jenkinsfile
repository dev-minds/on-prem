pipeline {
    agent any
 
    options {
		buildDiscarder(logRotator(numToKeepStr: '50', artifactNumToKeepStr: '50'))
		disableConcurrentBuilds()
		timestamps()
		timeout 240 // minutes
		ansiColor('xterm')
		skipDefaultCheckout()
    }

    stages {
		stage('Test Conn'){
	    	agent { docker { image 'simonmcc/hashicorp-pipeline:latest'}}
	    	steps {
				checkout scm 
				sh "ls -al"
	    	}
		}
    }	
}
