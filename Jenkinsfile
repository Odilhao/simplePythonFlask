pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t simplepythonflask .'
            }
        }
        
        stage('Executa Teste'){
            steps {
                sh 'docker run -tdi --rm --name=teste simplepythonflask'
		sh 'sleep 10'
		sh 'docker exec -i teste nosetests --with-xunit --with-coverage --cover-package=project test_users.py'
		sh 'docker cp teste:/courseCatalog/nosetests.xml .'
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
        }
        unstable {
            echo 'I am unstable :/'
        }
        failure {
            echo 'Ocorreu uma falha'
	    sh 'docker stop teste'
        }
        changed {
            echo 'Things were different before...'
        }
    }
}

