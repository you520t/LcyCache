#!/bin/bash

workspace="ReactiveCocoaTest.xcworkspace"
scheme="ReactiveCocoaTest"
sdk="iphoneos"
configuration="Release"
buildPath=$PWD/build/${configuration}-iphoneos
ipaPath=$PWD/${scheme}.ipa
mobileprovision="${HOME}/Library/MobileDevice/Provisioning Profiles/23a630ca-e35b-4c10-9c28-5647cd626818.mobileprovision"
sign="iPhone Developer: liao chenyu (HC8DM3BY28)"

xctool -workspace ${workspace} -scheme ${scheme} clean
xctool -workspace ${workspace} -scheme ${scheme} -sdk ${sdk} -configuration ${configuration} OBJROOT=$PWD/build SYMROOT=$PWD/build DSTROOT=$PWD/build 'CODE_SIGN_RESOURCE_RULES_PATH=$(SDKROOT)/ResourceRules.plist' build

xcrun -sdk iphoneos PackageApplication -v "${buildPath}/${scheme}.app" -o "${ipaPath}" --sign "${sign}" --embed "${mobileprovision}"

