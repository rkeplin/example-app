#!/bin/bash
openssl aes-256-cbc -K $encrypted_867d5633ae9d_key -iv $encrypted_867d5633ae9d_iv -in $(pwd)/.deploy/id_rsa.enc -out $(pwd)/.deploy/id_rsa -d

chmod 0400 $(pwd)/.deploy/id_rsa

rsync -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $(pwd)/.deploy/id_rsa" -avz --exclude '.deploy' --exclude '.git' $(pwd)/ travis@157.245.123.7:/opt/example-app/$TRAVIS_BUILD_NUMBER
ssh -t -oStrictHostKeyChecking=no -i $(pwd)/.deploy/id_rsa travis@157.245.123.7 "chown -R apache:apache /opt/example-app/$TRAVIS_BUILD_NUMBER"
ssh -t -oStrictHostKeyChecking=no -i $(pwd)/.deploy/id_rsa travis@157.245.123.7 "ln -sfn /opt/example-app/$TRAVIS_BUILD_NUMBER /var/www/html"
ssh -t -oStrictHostKeyChecking=no -i $(pwd)/.deploy/id_rsa travis@157.245.123.7 "chown -h apache:apache /var/www/html"

rm -rf $(pwd)/.deploy/id_rsa