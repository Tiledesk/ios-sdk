#!/bin/sh
set -e
set -u
set -o pipefail

function on_error {
  echo "$(realpath -mq "${0}"):$1: error: Unexpected failure"
}
trap 'on_error $LINENO' ERR

if [ -z ${UNLOCALIZED_RESOURCES_FOLDER_PATH+x} ]; then
  # If UNLOCALIZED_RESOURCES_FOLDER_PATH is not set, then there's nowhere for us to copy
  # resources to, so exit 0 (signalling the script phase was successful).
  exit 0
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

# This protects against multiple targets copying the same framework dependency at the same time. The solution
# was originally proposed here: https://lists.samba.org/archive/rsync/2008-February/020158.html
RSYNC_PROTECT_TMP_FILES=(--filter "P .*.??????")

case "${TARGETED_DEVICE_FAMILY:-}" in
  1,2)
    TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
    ;;
  1)
    TARGET_DEVICE_ARGS="--target-device iphone"
    ;;
  2)
    TARGET_DEVICE_ARGS="--target-device ipad"
    ;;
  3)
    TARGET_DEVICE_ARGS="--target-device tv"
    ;;
  4)
    TARGET_DEVICE_ARGS="--target-device watch"
    ;;
  *)
    TARGET_DEVICE_ARGS="--target-device mac"
    ;;
esac

install_resource()
{
  if [[ "$1" = /* ]] ; then
    RESOURCE_PATH="$1"
  else
    RESOURCE_PATH="${PODS_ROOT}/$1"
  fi
  if [[ ! -e "$RESOURCE_PATH" ]] ; then
    cat << EOM
error: Resource "$RESOURCE_PATH" not found. Run 'pod install' to update the copy resources script.
EOM
    exit 1
  fi
  case $RESOURCE_PATH in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.framework)
      echo "mkdir -p ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" $RESOURCE_PATH ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH"`.mom\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm\"" || true
      xcrun mapc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE="$RESOURCE_PATH"
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    *)
      echo "$RESOURCE_PATH" || true
      echo "$RESOURCE_PATH" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "${PODS_ROOT}/Chat21/Resources/Chat-Services.plist"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/general/avatar.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/general/exiticonbutton.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/general/group-conversation-avatar.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/general/no_image_message_placeholder.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/general/sendbutton.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/baseline_create_black_24pt@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/baseline_create_black_24pt@3x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/baseline_history_black_24pt@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/baseline_history_black_24pt@3x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/chat_check.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/chat_double_check.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/chat_failed.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/chat_watch.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/history_button@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/history_button@3x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/ic_linear_support_gray_01.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/ic_linear_support_gray_01@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/ic_linear_support_gray_01@3x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/is_new_icon16.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/is_new_point16@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/plus_icon@3x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_altro.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_altro@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_cerca.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_cerca@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_chat.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_chat@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_foto.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_foto@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_home.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_home@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_profile.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_profile@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_watch.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_watch@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/sounds/inline.caf"
  install_resource "${PODS_ROOT}/Chat21/Resources/sounds/newnotif.caf"
  install_resource "${PODS_ROOT}/Chat21/Resources/storyboards/Chat.storyboard"
  install_resource "${PODS_ROOT}/Chat21/Resources/xib/dm_conversation_cell.xib"
  install_resource "${PODS_ROOT}/Chat21/Resources/xib/group_conversation_cell.xib"
  install_resource "${PODS_ROOT}/Chat21/Resources/xib/notification_view.xib"
  install_resource "${PODS_ROOT}/Chat21/Resources/xib/status_title_ios11.xib"
  install_resource "${PODS_ROOT}/Chat21/Resources/Base.lproj"
  install_resource "${PODS_ROOT}/Chat21/Resources/en.lproj"
  install_resource "${PODS_ROOT}/Chat21/Resources/it.lproj"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "${PODS_ROOT}/Chat21/Resources/Chat-Services.plist"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/general/avatar.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/general/exiticonbutton.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/general/group-conversation-avatar.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/general/no_image_message_placeholder.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/general/sendbutton.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/baseline_create_black_24pt@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/baseline_create_black_24pt@3x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/baseline_history_black_24pt@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/baseline_history_black_24pt@3x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/chat_check.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/chat_double_check.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/chat_failed.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/chat_watch.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/history_button@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/history_button@3x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/ic_linear_support_gray_01.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/ic_linear_support_gray_01@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/ic_linear_support_gray_01@3x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/is_new_icon16.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/is_new_point16@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/icons/plus_icon@3x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_altro.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_altro@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_cerca.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_cerca@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_chat.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_chat@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_foto.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_foto@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_home.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_home@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_profile.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_profile@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_watch.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/images/tabicons/icon_light_watch@2x.png"
  install_resource "${PODS_ROOT}/Chat21/Resources/sounds/inline.caf"
  install_resource "${PODS_ROOT}/Chat21/Resources/sounds/newnotif.caf"
  install_resource "${PODS_ROOT}/Chat21/Resources/storyboards/Chat.storyboard"
  install_resource "${PODS_ROOT}/Chat21/Resources/xib/dm_conversation_cell.xib"
  install_resource "${PODS_ROOT}/Chat21/Resources/xib/group_conversation_cell.xib"
  install_resource "${PODS_ROOT}/Chat21/Resources/xib/notification_view.xib"
  install_resource "${PODS_ROOT}/Chat21/Resources/xib/status_title_ios11.xib"
  install_resource "${PODS_ROOT}/Chat21/Resources/Base.lproj"
  install_resource "${PODS_ROOT}/Chat21/Resources/en.lproj"
  install_resource "${PODS_ROOT}/Chat21/Resources/it.lproj"
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "${XCASSET_FILES:-}" ]
then
  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "${PODS_ROOT}*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  if [ -z ${ASSETCATALOG_COMPILER_APPICON_NAME+x} ]; then
    printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  else
    printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${TARGET_TEMP_DIR}/assetcatalog_generated_info_cocoapods.plist"
  fi
fi
