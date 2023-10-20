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
                docker run -tdi --rm --name=teste simplepythonflask
		sleep 10
		docker exec -ti teste nosetests --with-xunit --with-coverage --cover-package=project test_users.py
		docker cp teste:/courseCatalog/nosetests.xml .
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
	    docker stop teste
        }
        unstable {
            echo 'I am unstable :/'
        }
        failure {
            echo 'Ocorreu uma falha'
	    docker stop teste
        }
        changed {
            echo 'Things were different before...'
        }
    }
}

