#!/bin/false
# shellcheck shell=bash
# shebang to indicate if can only be invoked using source . command

if [ -f "${API_DATA_FILE}" ]; then
    # Add a global exclusion to prevent a false positive issue with this sample application like:
    # Unexpected Content-Type was returned
    # A Content-Type of text/html was returned by the server.This is not one of the types expected to be returned by an API.
    # Raised by the 'Alert on Unexpected Content Types' script
    echo "Target application server url is: $TARGET_APPLICATION_SERVER_URL"
    APP_URL_REGEX=$(echo $TARGET_APPLICATION_SERVER_URL | sed 's:/*$::')
    app_url_regex="^${APP_URL_REGEX//\//\\\/}\$"

    TMP_API_DATA_FILE=$(mktemp)

    jq --arg app_url_regex "${app_url_regex}" \
    '.globalExcludeUrls += [$app_url_regex] | .apisToScan += [{"path":"/health", "method":"get"}]' \
    "${API_DATA_FILE}" > "${TMP_API_DATA_FILE}"

    cp -f "${TMP_API_DATA_FILE}" "${API_DATA_FILE}"
fi