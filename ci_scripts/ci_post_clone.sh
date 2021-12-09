#!/bin/sh

#  ci_post_clone.sh
#  PMS-iOS-V2
#
#  Created by GoEun Jeong on 2021/12/08.
#  

# Install all Dependencies
bundle install
export HOMEBREW_NO_INSTALL_CLEANUP=0
brew install tmspzz/homebrew-tap/rome
brew tap artemnovichkov/projects
brew install carting
brew install xcodegen
brew tap summerlabs/homebrew-punic
brew install punic
brew install fastlane

# Setting Rome
echo "[default]" >> .aws/credentials
echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> .aws/credentials
echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> .aws/credentials

echo "[default]" >> .aws/config
echo "region = $AWS_REGION" >> .aws/config

# Execute Xcodegen
cd ../
chmod +x scripts/run scripts/upload-symbols
xcodegen
