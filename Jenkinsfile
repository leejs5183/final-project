pipeline {
  agent any

  environment {
    AWS_REGION   = 'ap-northeast-2'
    ECR_REGISTRY = '579378699580.dkr.ecr.ap-northeast-2.amazonaws.com'
    ECR_REPO     = 'tomcat-ecr'
    IMAGE_TAG    = "${BUILD_NUMBER}"
    IMAGE_URI    = "${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}"
    CLUSTER_NAME = 'my-eks'
  }

  stages {

    stage('Build WAR') {
      steps {
        sh 'mvn clean package -DskipTests'
      }
    }

    stage('Build Image') {
      steps {
        sh 'docker build -t tomcat-ecr:${BUILD_NUMBER} .'
      }
    }

    stage('ECR Login') {
      steps {
        sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}'
      }
    }

    stage('Push to ECR') {
      steps {
        sh 'docker tag tomcat-ecr:${BUILD_NUMBER} ${IMAGE_URI}'
        sh 'docker push ${IMAGE_URI}'
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh '''
          aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}
          sed "s#REPLACE_IMAGE#${IMAGE_URI}#g" k8s/deployment.yaml | kubectl apply -f -
          kubectl apply -f k8s/service.yaml
          kubectl apply -f k8s/ingress.yaml
          kubectl rollout status deployment/tomcat-app
        '''
      }
    }
  }
}

