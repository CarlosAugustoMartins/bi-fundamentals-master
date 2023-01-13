#!/bin/bash
KEY_PAIR=tutorial-bi9
    sudo ecs-cli up \
      --keypair $KEY_PAIR  \
      --capability-iam \
      --size 1 \
      --instance-type t3.medium \
      --tags project=bi-tp,owner=giselle \
      --cluster-config bi-tp \
      --ecs-profile terraform

      sudo ecs-cli configure  --cluster bi-tp --default-launch-type EC2 --region us-east-1 --config-name bi-tp
