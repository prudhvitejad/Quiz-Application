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
            
            dockerUsername = getUsername("prudhvi-docker-username")
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
def getUsername(credentialsId) {
    return getCredentials(credentialsId)?.username
}

def getPassword(credentialsId) {
    return getCredentials(credentialsId)?.password
}

def getCredentials(credentialsId) {
    def credentialsProvider = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0]
    def credentials = credentialsProvider.credentials.findAll { it.id == credentialsId }
    return credentials ? credentials[0] : null
}

