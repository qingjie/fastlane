#!/bin/bash

APPLLICATION_NAME=$1

CODE_SIGN_IDENTITY='iPhone Distribution: Jeffrey Lynch (22LVAXR7TN)'
 
xcrun -sdk iphoneos PackageApplication -v /Volumes/DevBoot/Users/jwl/Library/Developer/Xcode/Archives/2014-07-05/2463\ 7-5-14\,\ 9.02\ PM.xcarchive/Products/Applications/2463.app -o "/Volumes/DevBoot/Users/jwl/Projects/thirdParty/Retrieve/RetrieveApp/2463.ipa" --embed "JeffreyLynchAdHoc"
