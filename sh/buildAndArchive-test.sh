ARCHIVE_PATH="Builds/test/${1}/${1}.xcarchive"
EXPORT_PATH="Builds/test/${1}/${1}.ipa"
BUILD_LOG_PATH="Builds/test/${1}/${1}-build.log"
ARCHIVE_LOG_PATH="Builds/test/${1}/${1}-archive.log"

#PROFILE="dev-provisioning-profile-2016"

mkdir -p "Builds/test/${1}/" &> /dev/null
rm -Rf "${ARCHIVE_PATH}" &> /dev/null
rm -Rf "${EXPORT_PATH}" &> /dev/null


echo "----------------${ARCHIVE_PATH}------------=${EXPORT_PATH}=-----------------"
echo "------------------------------------------------"
echo "${1} - Building  - `date`"
xctool -project ../RetrieveApp/RetrieveApp.xcodeproj -scheme ${1} -configuration Release archive -archivePath "${ARCHIVE_PATH}" > ${BUILD_LOG_PATH}

echo "${1} - Archiving - `date`"
xcodebuild -exportArchive -archivePath "${ARCHIVE_PATH}" -exportPath "${EXPORT_PATH}" -exportOptionsPlist exportPlist-test.plist > "${ARCHIVE_LOG_PATH}"
#xcodebuild -exportArchive -exportFormat IPA -archivePath "${ARCHIVE_PATH}" -exportPath "${EXPORT_PATH}" -exportProvisioningProfile "${PROFILE}" > "${ARCHIVE_LOG_PATH}"

echo "${1} - COMPLETE  - `date`"
echo "------------------------------------------------"
