#!/bin/bash

echo "Terraform Apply"

target_directory="$1"
if [[ -z "${target_directory}" ]]; then
    echo "Please specify the target directory in argument 1 for this script"
    exit 1
fi

if [[ ! -d "${target_directory}" ]]; then
    echo "Could not locate the target directory: ${target_directory}"
    exit 1
fi

cd "${target_directory}"
terraform apply -parallelism=10 plan.out
