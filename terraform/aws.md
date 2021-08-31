## Login with Theodo SSO

aws configure sso
https://theodo.awsapps.com/start

## Login docker aws

aws ecr get-login-password --region eu-west-1 --profile AdministratorAccess-628239207084 | docker login --username AWS --password-stdin 628239207084.dkr.ecr.eu-west-1.amazonaws.com

## Push image

make api-build

docker tag scrumble-legacy-api:latest 628239207084.dkr.ecr.eu-west-1.amazonaws.com/scrumble-legacy-api:latest

docker push 628239207084.dkr.ecr.eu-west-1.amazonaws.com/scrumble-legacy-api:latest
