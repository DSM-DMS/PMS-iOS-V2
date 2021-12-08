#!/bin/sh

#  ci_post_clone.sh
#  PMS-iOS-V2
#
#  Created by GoEun Jeong on 2021/12/08.
#  

bundle install
brew install tmspzz/homebrew-tap/rome
brew tap artemnovichkov/projects
brew install carting
brew install xcodegen
brew tap summerlabs/homebrew-punic
brew install punic
brew install fastlane
echo "export PATH="$HOME/.fastlane/bin:$PATH"" >> ~/.bash_profile
export PATH=”$HOME/.fastlane/bin:$PATH”
cd ../
chmod +x scripts/run scripts/upload-symbols
xcodegen
