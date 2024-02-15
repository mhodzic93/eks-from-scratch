#!/bin/bash

echo "Terraform Plan"

# Validate inputs are valid
variables_file="$1"
if [[ -z "${variables_file}" ]]; then
    echo "Please specify a variables file in argument 1 for this script"
    exit 1
fi

if [[ ! -e "${variables_file}" ]]; then
    echo "Could not locate variables file: ${variables_file}"
    exit 1
fi

target_directory="$2"
if [[ -z "${target_directory}" ]]; then
    echo "Please specify the target directory in argument 2 for this script"
    exit 1
fi

if [[ ! -d "${target_directory}" ]]; then
    echo "Could not locate the target directory: ${target_directory}"
    exit 1
fi

# Set variables
while read line;
do
    export "$(echo "${line}" | tr -d "\"")"
done < "${variables_file}"

if [[ -z "${aws_region}" ]] || [[ -z "${environment}" ]] || [[ -z "${project}" ]] || [[ -z "${states_bucket}" ]]; then
    echo "Please specify the required vars in $1" && exit 1
fi

# Remove the existing .terraform directory if it exists
cd "${target_directory}"
rm -rf .terraform .terraform.lock.hcl plan.out

# Configure backend
state_path=$(echo "${target_directory}" | awk -F '/' '{print $1}')
stack_name="${project}-${environment}"
state_key="${stack_name}/${state_path}.state"
echo "Setting up Remote Configuration to s3://${states_bucket}/${state_key}"

echo bucket=\""${states_bucket}"\" > backend.conf
echo key=\""${state_key}"\" >> backend.conf
echo region=\""${aws_region}"\" >> backend.conf
terraform init -backend-config=backend.conf

echo "Running Terraform Plan"
echo "terraform plan -parallelism=10 -out=plan.out -var-file=${variables_file}"
terraform plan -parallelism=10 -out=plan.out -var-file="${variables_file}"
