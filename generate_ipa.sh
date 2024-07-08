#!/bin/sh
set -e

cd "$(dirname $0)"
rm -rf Build
xcodebuild build -project Vulka.xcodeproj -scheme Vulka -sdk iphoneos -configuration Release CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO SYMROOT=${PWD}/Build build
cd Build/Release-iphoneos
mkdir -p Payload
mv Vulka.app Payload
zip -r Vulka.ipa Payload
mv Vulka.ipa ../..
cd ../..
rm -rf Build
echo "Build completed. Vulka.ipa at ${PWD}/Vulka.ipa"
