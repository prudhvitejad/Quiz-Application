def dockerUsername
def dockerPassword

pipeline  {
  agent any
  
  environment {
        DOCKER_USERNAME = credentials('prudhvi-docker-username')
        DOCKER_PASSWORD = credentials('prudhvi-docker-password')
  }
  
  stages  {
    stage('Initialize'){
      steps  {
        script  {
          def dockerHome = tool "myDocker"
          env.PATH = "${dockerHome}/bin:${env.PATH}"
        }
      }  
    }
    stage('Checkout') {
            steps {
                script {
                    git branch: env.BRANCH_NAME, url: 'https://github.com/prudhvitejad/Quiz-Application.git'
                }
            }
        }
    stage('Build and Push Docker Image') {
    steps {
        script {
            def commitId = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
            
            dockerUsername = getSecretText("prudhvi-docker-username")
            dockerPassword = getSecretText("prudhvi-docker-password")
            sh "echo dockerUsername=${dockerUsername}"
            sh "echo dockerPassword=${dockerPassword}"

            sh "docker build -t ${dockerUsername}/quiz-app:${commitId} ."
            sh "docker login -u ${dockerUsername} -p ${dockerPassword}"
            sh "docker push ${dockerUsername}/quiz-app:${commitId}"
        }
    }
}
  }
}

def getSecretText(credentialsId) {
    return Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0]
                           .credentials
                           .findAll { it.id == credentialsId }
                           .collect { it.secret.toString() }
                           .join(',')
}
