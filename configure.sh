#!/bin/bash
set -e

if [[ -z "${AWS_ACCESS_KEY_ID}" ]]; then
 echo "AWS_ACCESS_KEY_ID is undefined"
 exit 1
fi

if [[ -z "${AWS_SECRET_ACCESS_KEY}" ]]; then
 echo "AWS_SECRET_ACCESS_KEY is undefined"
 exit 1
fi

PROFILE_NAME=terraform
CLUSTER_NAME=bi-tp
REGION=us-east-1
LAUNCH_TYPE=EC2
ecs-cli configure profile --profile-name "$PROFILE_NAME" --access-key "$AWS_ACCESS_KEY_ID" --secret-key "$AWS_SECRET_ACCESS_KEY"
ecs-cli configure --cluster "$CLUSTER_NAME" --default-launch-type "$LAUNCH_TYPE" --region "$REGION" --config-name "$PROFILE_NAME"


aws ec2 create-key-pair --key-name tutorial-bi9 \
 --query 'KeyMaterial' --output text > /home/giselle.carvalho/.ssh/tutorial-bi9.pem

if [ $? -ne 0 ]
then
    echo "Erro ao criar a chave"
    exit 1
fi
