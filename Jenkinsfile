pipeline  {
  agent any
  triggers  {
    githubPush()
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
            def dockerUsername = credentials("prudhvi-docker-username")
            def dockerPassword = credentials("prudhvi-docker-password")
            sh "echo dockerUsername=${dockerUsername}"
            
            docker.withRegistry("https://registry.hub.docker.com", dockerUsername, dockerPassword) {
                def dockerImage = docker.build("${dockerUsername}/quiz-app:${commitId}")
                dockerImage.push("${commitId}")
            }
        }
    }
}
  }
}
