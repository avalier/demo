#!/bin/bash

################################################################################
# LICENSE
# =======
#
# THIS SCRIPT IS PROVIDED TO YOU "AS IS." TO THE EXTENT PERMITTED BY LAW, 
# QUALYS HEREBY DISCLAIMS ALL WARRANTIES AND LIABILITY FOR THE PROVISION OR 
# USE OF THIS SCRIPT. IN NO EVENT SHALL THESE SCRIPTS BE DEEMED TO BE SUPPORTED 
# PRODUCTS/SERVICES AS PROVIDED BY QUALYS.
#
################################################################################

cat << EOLICENSE
################################################################################
# LICENSE
# =======
#
# THIS SCRIPT IS PROVIDED TO YOU "AS IS." TO THE EXTENT PERMITTED BY LAW,
# QUALYS HEREBY DISCLAIMS ALL WARRANTIES AND LIABILITY FOR THE PROVISION OR
# USE OF THIS SCRIPT. IN NO EVENT SHALL THESE SCRIPTS BE DEEMED TO BE SUPPORTED
# PRODUCTS/SERVICES AS PROVIDED BY QUALYS.
################################################################################

EOLICENSE

set -e

# Image #
if [ $# -lt 1 ]; then
	echo "All required arguments not provided."
	echo "Syntax:"
	echo "scan-image-using-qualys.sh <Image Id|Name>"
	exit 1
fi
IMAGE=$1

# Make sure env exists for QUALYS_API_SERVER #
if [ -z $QUALYS_API_SERVER ]
then
    echo "$(tput setaf 1)SCA scan failed (missing environment variable QUALYS_API_SERVER)$(tput sgr0)" >&2
    exit 1
fi

# Make sure env exists for QUALYS_USERNAME #
if [ -z $QUALYS_USERNAME ]
then
    echo "$(tput setaf 1)SCA scan failed (missing environment variable QUALYS_USERNAME)$(tput sgr0)" >&2
    exit 1
fi
USERNAME=$QUALYS_USERNAME

# Make sure env exists for QUALYS_PASSWORD #
if [ -z $QUALYS_PASSWORD ]
then
    echo "$(tput setaf 1)SCA scan failed (missing environment variable QUALYS_PASSWORD)$(tput sgr0)" >&2
    exit 1
fi
PASSWORD=$QUALYS_PASSWORD

check_command_exists () {
	hash $1 2>/dev/null || { echo >&2 "This script requires $1 but it's not installed. Aborting."; exit 1; }
}

get_result () {
	echo "Getting result for ${IMAGE_ID}"
	CURL_COMMAND="$CURL -s -X GET ${GET_IMAGE_VULNS_URL} -u ${USERNAME}:${PASSWORD} -L -w\\n%{http_code} -o ${IMAGE_ID}.json"
	HTTP_CODE=$($CURL_COMMAND | tail -n 1)
	echo "HTTP Code: ${HTTP_CODE}"
	if [ "$HTTP_CODE" == "200" ]; then
		check_vulns
	fi
}

check_vulns () {
	echo "Checking if vulns reported on ${IMAGE_ID}"
	VULNS_ABSENT=$($JQ '.vulnerabilities==null' ${IMAGE_ID}.json)
	if [[ "$VULNS_ABSENT" == "true" ]]; then
		VULNS_AVAILABLE=false
	else
		VULNS_AVAILABLE=true
	fi
	echo "Vulns Available: ${VULNS_AVAILABLE}"
}

check_image_input_type () {
	IMAGE_REGEX='^([A-Fa-f0-9]{12}|[A-Fa-f0-9]{64})$'
	IMAGE_INPUT_TYPE=''
	if [[ $1 =~ $IMAGE_REGEX ]]; then
		IMAGE_INPUT_TYPE='ID'
	else
		IMAGE_INPUT_TYPE='NAME'
	fi
	echo ${IMAGE_INPUT_TYPE}
}

get_image_id_from_name () {
	docker_command="$DOCKER images $1"
	echo ${docker_command}
	IMAGE_ID=$($docker_command | head -2 | tail -1 | awk '{print $3}')
	echo ${IMAGE_ID}

	if [[ "${IMAGE_ID}" == "IMAGE" ]]; then
		echo "Error! No image found by name $1"
		exit 2
	fi
}

###############################################################################
# Main execution starts here
###############################################################################

check_command_exists curl
check_command_exists jq
check_command_exists docker

CURL=$(which curl)
JQ=$(which jq)
DOCKER=$(which docker)

check_image_input_type ${IMAGE}

if [ "${IMAGE_INPUT_TYPE}" == "NAME" ]; then
	echo "Input (${IMAGE}) is image name. Script will now try to get the image id."
	get_image_id_from_name ${IMAGE}
	echo "Image id belonging to ${IMAGE} is: ${IMAGE_ID}"
else
	IMAGE_ID=${IMAGE}
fi

echo "Image id belonging to ${IMAGE} is: ${IMAGE_ID}"
GET_IMAGE_VULNS_URL="${QUALYS_API_SERVER}/csapi/v1.1/images/${IMAGE_ID}"
echo ${GET_IMAGE_VULNS_URL}

echo "Temporarily tagging image ${IMAGE} with qualys_scan_target:${IMAGE_ID}"
echo "Qualys Sensor will untag it after scanning. In case this is the only tag present, Sensor will not remove it."
`docker tag ${IMAGE_ID} qualys_scan_target:${IMAGE_ID}`

get_result

while [ "${HTTP_CODE}" -ne "200" -o "${VULNS_AVAILABLE}" != true ]
do
	echo "Retrying after 10 seconds..."
	sleep 10
	get_result
done

EVAL_RESULT=$(jq -f jq_filter.txt ${IMAGE_ID}.json)
echo ${EVAL_RESULT}


## If scan failed, exit with code 1 #
#EXIT_CODE=$?
