pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
      		telegramSend "Job $env.JOB_NAME foi iniciado com a execução de numero $env.BUILD_NUMBER, \
		o commit foi realizado por $env.GIT_COMMITTER_NAME <$env.GIT_COMMITTER_EMAIL> no branch $env.GIT_BRANCH \
		acesse $env.BUILD_URL para conferir os detalhes."
                sh 'docker build -t simplepythonflask .'
            }
        }
        
        stage('Executa Teste'){
            steps {
                sh 'docker run -tdi --rm --name=teste simplepythonflask'
		sh 'sleep 10'
		sh 'docker exec -i teste nosetests --with-xunit --with-coverage --cover-package=project test_users.py'
		sh 'docker cp teste:/courseCatalog/nosetests.xml .'
		junit 'nosetests.xml'
		

            }
        }
	stage('SonarQube'){
	steps{
	script{
	def sonarScannerPath = tool 'SonarScanner'
	sh "${sonarScannerPath}/bin/sonar-scanner \
  		   -Dsonar.projectKey=courseCatalog \
  		   -Dsonar.sources=. \
  		   -Dsonar.host.url=http://sonarqube:9000 \
  		   -Dsonar.login=sqp_fbede7496fb283351ec20b80d09f195e435e0854"	
		}
		}	
	}
    }
    post {
      always {
            echo 'One way or another, I have finished'
            deleteDir() /* clean up our workspace */
        }
        success {
            echo "Finalizei com sucesso"
	    sh 'docker stop teste'

	telegramSend(message: 'Hello World', chatId: -4092859996)
	telegramSend "Job $env.JOB_NAME finalizado com sucesso na execução de numero $env.BUILD_NUMBER"
	}
        unstable {
            echo 'I am unstable :/'
        }
        failure {
            echo 'Ocorreu uma falha'
	    sh 'docker stop teste'
        
	telegramSend "Job $env.JOB_NAME finalizado com falha na execução de numero $env.BUILD_NUMBER, acesse $env.BUILD_URL para conferir os detalhes"
	}
        changed {
            echo 'Things were different before...'
        }
    }
}

