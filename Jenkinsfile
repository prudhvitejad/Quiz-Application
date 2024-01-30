def dockerUsername
def dockerPassword

pipeline  {
  agent { label 'slave-agent' }
  
  triggers {
    githubPush()
  }
  
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
                    git branch: 'development', url: 'https://github.com/prudhvitejad/Quiz-Application.git'
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
    stage("Update Docker image in the ECS Task Definition") {
    steps {
        script {
            def commitId = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
            def imageName = "${dockerUsername}/quiz-app:${commitId}"
            def taskDefinition = "Prudhvi-task-definition-family"
            def cluster = "Prudhvi-task1"
            def service = "Prudhvi-task1-service"
            
            // Pull the latest Docker image
            sh "docker login -u ${dockerUsername} -p ${dockerPassword}"
            sh "docker pull ${imageName}"
            
            // Register a new revision of the task definition
            def registerTaskDefCmd = "aws ecs register-task-definition --family ${taskDefinition} --container-definitions '[{\"name\":\"quiz-app\",\"image\":\"${imageName}\",\"cpu\":0,\"memoryReservation\":512}]'"
            def registerTaskDefOutput = sh(script: registerTaskDefCmd, returnStdout: true).trim()
            
            // Extract the revision number from the output
            def revision = sh(script: "echo ${registerTaskDefOutput} | jq -r '.taskDefinition.revision'", returnStdout: true).trim()
            
            // Update the ECS service to use the new task definition revision
            sh "aws ecs update-service --cluster ${cluster} --service ${service} --task-definition ${taskDefinition}:${revision}"
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
