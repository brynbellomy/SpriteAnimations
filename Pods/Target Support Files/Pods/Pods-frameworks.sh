#!/bin/sh
set -e

echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

install_framework()
{
  echo "rsync --exclude '*.h' -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
  rsync -av "${BUILT_PRODUCTS_DIR}/Pods/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
}

if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_framework 'BrynSwift.framework'
  install_framework 'LlamaKit.framework'
  install_framework 'SwiftBitmask.framework'
  install_framework 'SwiftConfig.framework'
  install_framework 'SwiftDataStructures.framework'
  install_framework 'SwiftFlatUIColors.framework'
  install_framework 'SwiftLogger.framework'
  install_framework 'SwiftState.framework'
  install_framework 'SwiftyJSON.framework'
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_framework 'BrynSwift.framework'
  install_framework 'LlamaKit.framework'
  install_framework 'SwiftBitmask.framework'
  install_framework 'SwiftConfig.framework'
  install_framework 'SwiftDataStructures.framework'
  install_framework 'SwiftFlatUIColors.framework'
  install_framework 'SwiftLogger.framework'
  install_framework 'SwiftState.framework'
  install_framework 'SwiftyJSON.framework'
fi
