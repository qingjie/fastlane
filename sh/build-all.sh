#!/bin/sh

rm -rf build
mkdir -p build/ipa
for f in ../RetrieveApp/RetrieveApp.xcodeproj/xcshareddata/xcschemes/*.xcscheme; do
        sc=$(basename $f)
        sc=${sc%.*}
		xctool -project ../RetrieveApp/RetrieveApp.xcodeproj -scheme ${sc} -configuration "Release Production" archive -archivePath build/archive/${sc}
		xcodebuild -exportArchive -archivePath "${ARCHIVE_PATH}" -exportPath "${EXPORT_PATH}" -exportOptionsPlist exportPlist-prod.plist > "${ARCHIVE_LOG_PATH}"
		#xcodebuild -exportArchive -archivePath build/archive/${sc}.xcarchive -exportPath build/ipa/${sc}.ipa -exportProvisioningProfile "kApp for Store - Jul2015"
done;