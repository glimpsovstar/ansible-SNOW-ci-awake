#!/bin/bash

# ServiceNow Keep-Alive Script
# This script runs the Ansible playbook to prevent ServiceNow instance hibernation

# Exit on any error
set -e

# Check if required environment variables are set
if [ -z "$SNOW_INSTANCE" ] || [ -z "$SNOW_USER" ] || [ -z "$SNOW_PASSWORD" ] || [ -z "$CI_SYS_ID" ]; then
    echo "Error: Required environment variables are not set"
    echo "Please set: SNOW_INSTANCE, SNOW_USER, SNOW_PASSWORD, and CI_SYS_ID"
    exit 1
fi

# Run the Ansible playbook
ansible-playbook snow_keep_alive.yml \
    -e "snow_instance_url=${SNOW_INSTANCE}" \
    -e "snow_user=${SNOW_USER}" \
    -e "snow_pass=${SNOW_PASSWORD}" \
    -e "ci_number=${CI_SYS_ID}"

echo "Keep-alive update completed successfully"