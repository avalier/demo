#!/bin/bash
#set -o errexit	# Stop script on first error (non-zero returncode)
#set -o pipefail	# Stop script on first error in a piped command (default only checks last pipe-command)
#set -o verbose	# Verbose debugprinting of executing scripts
#set -o xtrace	# Show commands being executed through debugprint during execution

# Reference: Veracode - Run a Pipeline Scan
# https://help.veracode.com/r/r_pipeline_scan_commands
# https://help.veracode.com/reader/tS9CaFwL4_lbIEWWomsJoA/jm5gzgo~F75rEgPVp_WcoQ

# Change directory to git root folder based on location relative to the currently executing script #
ScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ScriptDirectory && cd ..

# Get src folder name (and default if unavailable) #
SrcFolder=$1
if [ -z $SrcFolder ]
then
    echo "$(tput setaf 1)SAST scan failed (missing SrcFolder argument scan-sast-using-veracode.sh <<SrcFolder>>)$(tput sgr0)" >&2
    return 1
fi

# Get veracode id (and error if unavailable) #
if [ -z $VERACODE_ID ]
then
    echo "$(tput setaf 1)SAST scan failed (missing environment variable VERACODE_ID)$(tput sgr0)" >&2
    exit 1
fi

# Get veracode key (and error if unavailable) #
if [ -z $VERACODE_KEY ]
then
    echo "$(tput setaf 1)SAST scan failed (missing environment variable VERACODE_KEY)$(tput sgr0)" >&2
    exit 1
fi

# Zip binaries #
zip -r ./app.zip $SrcFolder

# Scan Src #
curl -O -L https://downloads.veracode.com/securityscan/pipeline-scan-LATEST.zip
unzip -o pipeline-scan-LATEST.zip pipeline-scan.jar
java -Dpipeline.debug=false -jar pipeline-scan.jar \
    --veracode_api_id "$VERACODE_ID" \
    --veracode_api_key "$VERACODE_KEY" \
    --file=app.zip \
    --fail_on_severity="High, Very High" \
    --issue_details true \
    --json_output true
    #--json_output_file ./.out/scan-sast-veracode.json
EXIT_CODE=$?

# Cleanup #
while ! [ -f results.json ]; do
    echo "Waiting for Veracode pipeline scan to complete..."; sleep 1
done

#echo 'Moving artifacts...'
#mkdir -p .out/
#mv ./results.json ./.out/scan-sast-veracode.json
#rm filtered_results.json
#rm pipeline-scan*
#rm app.zip

# If scan failed, exit with code 1 #
if [ $EXIT_CODE != 0 ]
then
    echo "SAST scan failed with errors (exit code: $EXIT_CODE)" >&2
    exit $EXIT_CODE
fi
    