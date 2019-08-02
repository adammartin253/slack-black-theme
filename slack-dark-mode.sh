#!/usr/bin/env bash

JS="
// First make sure the wrapper app is loaded
document.addEventListener('DOMContentLoaded', function() {
  // Fetch our CSS in parallel ahead of time
  const cssPath = 'https://raw.githubusercontent.com/caiceA/slack-black-theme/master/slack-dark-mode.css';
  let cssPromise = fetch(cssPath).then((response) => response.text());

  // Insert a style tag into the wrapper view
  cssPromise.then((css) => {
    let s = document.createElement('style');
    s.type = 'text/css';
    s.innerHTML = css;
    document.head.appendChild(s);
  });
});"

SLACK_RESOURCES_DIR="/Applications/Slack.app/Contents/Resources"
SLACK_FILE_PATH="${SLACK_RESOURCES_DIR}/app.asar.unpacked/dist/ssb-interop.bundle.js"

echo "Adding Dark Theme Code to Slack... "
echo "This script requires sudo privileges." && echo "You'll need to provide your password."

sudo npx asar extract ${SLACK_RESOURCES_DIR}/app.asar ${SLACK_RESOURCES_DIR}/app.asar.unpacked
sudo tee -a "${SLACK_FILE_PATH}" > /dev/null <<< "$JS"
sudo npx asar pack ${SLACK_RESOURCES_DIR}/app.asar.unpacked ${SLACK_RESOURCES_DIR}/app.asar

pkill Slack

open -a /Applications/Slack.app
