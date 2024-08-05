podTemplate(containers: [
    containerTemplate(name: 'maven', image: 'maven:3.8.1-jdk-8', command: 'sleep', args: '99d'),
    containerTemplate(
        name: 'docker',
        image: 'docker:dind',
        command: 'sleep',
        args: '99d',
        ttyEnabled: true,
        prviliged: true
    )
    containerTemplate(name: 'openjdk', image: 'openjdk:11', command: 'sleep', args: '99d')],
  volumes: [ hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock')]
  ){

    node(POD_LABEL){
        container('docker'){

        stage("Clona Git"){
            git 'http://192.168.88.20:3000/odilon/simplePythonFlask.git'
        }

        stage("Build"){
             sh "docker build -t simple-python-flask:${BUILD_ID} ."
        }

        stage ("Teste") {

                sh "docker run -tdi --name simple-python-flask-${BUILD_ID} --rm simple-python-flask:${BUILD_ID}"

                sh "docker exec simple-python-flask-${BUILD_ID} nosetests --with-xunit --with-coverage --cover-package=project test_users.py"

                sh "docker stop simple-python-flask-${BUILD_ID}"

                sh "docker tag simple-python-flask:${BUILD_ID} 192.168.88.20:8082/simple-python-flask:${BUILD_ID}"
        }

    container('openjdk'){

      stage('SonarQube Analysis'){
        script {
          def sonarScannerPath = tool 'SonarScanner'

          withSonarQubeEnv('SonarQube'){
            sh "${sonarScannerPath}/bin/sonar-scanner \
            -Dsonar.projectKey=courseCatalog -Dsonar.sources=."
          }

        }

      }

    }

        stage ("Push Image"){

            script {
                docker.withRegistry('http://192.168.88.20:8082', 'jenkins_docker'){
                
                sh 'docker push 192.168.88.20:8082/simple-python-flask:${BUILD_ID}'
                }
            }

        }
    }
}

}
