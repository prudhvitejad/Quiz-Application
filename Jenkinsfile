def dockerUsername
def dockerPassword

pipeline  {
  agent any
  
  environment {
        DOCKER_USERNAME = credentials('prudhvi-docker-username')
        DOCKER_PASSWORD = credentials('prudhvi-docker-password')
  }
  
  stages  {
    stage("testing")  {
      steps  {
        script  {
          sh "echo ${env.BRANCH_NAME}"
        }
      }
    }
    stage('Build and Push Docker Image') {
    steps {
        script {
            def commitId = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
            dockerUsername = DOCKER_USERNAME
            dockerPassword = DOCKER_PASSWORD
            sh "echo dockerUsername=${dockerUsername}"
            
            withCredentials([string(credentialsId: dockerUsername, variable: 'DOCKER_USERNAME'), string(credentialsId: dockerPassword, variable: 'DOCKER_PASSWORD')]) {
              // Use dockerUsername and dockerPassword variables securely within this block
              sh 'echo $DOCKER_USERNAME'
              sh 'echo $DOCKER_PASSWORD'
            }
          
            docker.withRegistry("https://registry.hub.docker.com", dockerUsername, dockerPassword) {
                def dockerImage = docker.build("${dockerUsername}/quiz-app:${commitId}")
                dockerImage.push("${commitId}")
            }
        }
    }
}
  }
}
