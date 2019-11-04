#!/bin/bash
openssl aes-256-cbc -K $encrypted_867d5633ae9d_key -iv $encrypted_867d5633ae9d_iv -in $(pwd)/.deploy/id_rsa.enc -out $(pwd)/.deploy/id_rsa -d

chmod 0400 $(pwd)/.deploy/id_rsa

SERVER_IP="157.245.123.7"

rsync -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $(pwd)/.deploy/id_rsa" -avz --exclude '.deploy' --exclude '.git' $(pwd)/ travis@$SERVER_IP:/opt/example-app/$TRAVIS_BUILD_NUMBER
ssh -t -oStrictHostKeyChecking=no -i $(pwd)/.deploy/id_rsa travis@$SERVER_IP "chown -R travis:apache /opt/example-app/$TRAVIS_BUILD_NUMBER"
ssh -t -oStrictHostKeyChecking=no -i $(pwd)/.deploy/id_rsa travis@$SERVER_IP "ln -sfn /opt/example-app/$TRAVIS_BUILD_NUMBER /var/www/html/app"
ssh -t -oStrictHostKeyChecking=no -i $(pwd)/.deploy/id_rsa travis@$SERVER_IP "chown -h travis:apache /var/www/html/app"

rm -rf $(pwd)/.deploy/id_rsa
