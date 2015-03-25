#!/bin/sh

#  FatLibraryBuildScript.sh
#
#  Created by Sebastian Owodziń on 25/02/2015.
#  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.

set -e
set +u

# Avoid recursively calling this script
if [[ $FLB_MASTER_SCRIPT_RUNNING ]]
then
exit 0
fi
set -u
export FLB_MASTER_SCRIPT_RUNNING=1

if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]
then
FLB_SDK_PLATFORM=${BASH_REMATCH[1]}
else
echo "Could not find platform name from SDK_NAME: $SDK_NAME"
exit 1
fi

if [[ "$SDK_NAME" =~ ([0-9]+.*$) ]]
then
FLB_SDK_VERSION=${BASH_REMATCH[1]}
else
echo "Could not find sdk version from SDK_NAME: $SDK_NAME"
exit 1
fi

if [[ "$FLB_SDK_PLATFORM" = "iphoneos" ]]
then
FLB_OTHER_PLATFORM=iphonesimulator
else
FLB_OTHER_PLATFORM=iphoneos
fi

if [[ "$BUILT_PRODUCTS_DIR" =~ (.*)$FLB_SDK_PLATFORM$ ]]
then
FLB_OTHER_BUILT_PRODUCTS_DIR="${BASH_REMATCH[1]}${FLB_OTHER_PLATFORM}"
else
echo "Could not find platform name from build products directory: $BUILT_PRODUCTS_DIR"
exit 1
fi

# Build the other platform.
xcrun xcodebuild -project "${PROJECT_FILE_PATH}" -target "${TARGET_NAME}" -configuration "${CONFIGURATION}" -sdk ${FLB_OTHER_PLATFORM}${FLB_SDK_VERSION} BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}" SYMROOT="${SYMROOT}" $ACTION

FLB_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}
if [ ! -d "${FLB_BUILD_DIR}" ]; then
mkdir "${FLB_BUILD_DIR}"
fi

cp -a "${BUILT_PRODUCTS_DIR}/${PROJECT_NAME}.framework" "${FLB_BUILD_DIR}"

# Smash the two binary libraries into one fat binary
xcrun lipo -create "${FLB_BUILD_DIR}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${FLB_OTHER_BUILT_PRODUCTS_DIR}/${PROJECT_NAME}.framework/${PROJECT_NAME}" -output "${FLB_BUILD_DIR}/${PROJECT_NAME}.framework/${PROJECT_NAME}"

# Open Finder window with files
open "${FLB_BUILD_DIR}"

