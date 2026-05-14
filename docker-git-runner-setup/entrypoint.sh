#!/bin/bash
set -e

cd /home/runner

echo "Fixing permissions for /home/runner/_work..."
mkdir -p /home/runner/_work
chown -R runner:runner /home/runner/_work

# REPO must be in this format: username/repo
TOKEN_URL="https://api.github.com/repos/${REPO}/actions/runners/registration-token"

echo "Requesting registration token for $REPO..."

RUNNER_TOKEN=$(curl -s -X POST \
  -H "Authorization: Bearer ${GITHUB_PAT}" \
  -H "Accept: application/vnd.github+json" \
  "${TOKEN_URL}" | jq -r .token)

if [ -z "$RUNNER_TOKEN" ] || [ "$RUNNER_TOKEN" = "null" ]; then
  echo "Failed to get GitHub runner registration token."
  echo "Check your REPO value and GitHub PAT permissions."
  exit 1
fi

echo "Registering runner: $RUNNER_NAME"

./config.sh --unattended \
  --url "https://github.com/${REPO}" \
  --token "${RUNNER_TOKEN}" \
  --name "${RUNNER_NAME}" \
  --labels self-hosted,docker,terraform \
  --work _work \
  --replace

echo "Starting runner..."
exec ./run.sh