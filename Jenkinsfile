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
            
            dockerUsername = getUsername("prudhvi-docker-username")
            dockerPassword = getPassword("prudhvi-docker-password")
            sh "echo dockerUsername=${dockerUsername}"
            sh "echo dockerPassword=${dockerPassword}"
          
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
    return Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0]
                           .credentials
                           .findAll { it.id == credentialsId }
                           .collect { it.description }
                           .join(',')
}

def getPassword(credentialsId) {
    return Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0]
                           .credentials
                           .findAll { it.id == credentialsId }
                           .collect { it.secret.toString() }
                           .join(',')
}


