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
  }
}
