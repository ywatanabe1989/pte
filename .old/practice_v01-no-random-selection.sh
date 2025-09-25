#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2025-09-25 23:41:54 (ywatanabe)"
# File: ./practice.sh

THIS_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
LOG_PATH="$THIS_DIR/.$(basename $0).log"
echo > "$LOG_PATH"

BLACK='\033[0;30m'
LIGHT_GRAY='\033[0;37m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo_info() { echo -e "${LIGHT_GRAY}$1${NC}"; }
echo_success() { echo -e "${GREEN}$1${NC}"; }
echo_warning() { echo -e "${YELLOW}$1${NC}"; }
echo_error() { echo -e "${RED}$1${NC}"; }
# ---------------------------------------

QUESTION_BANK_URL="https://ptemagic.com/pte-academic/question-bank"
CHROME_PATH="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"

NC='\033[0m'

usage() {
    echo "Usage: $0 [POOL_NAME] [-h|--help]"
    echo
    echo "Opens a random PTE practice question from the specified pool."
    echo
    echo "Available pools:"
    echo "  rs | repeat-sentence    - Repeat sentence practice (max: 1889)"
    echo "  di | describe-image     - Describe image practice (max: 843)"
    echo "  sp | summarize-passage  - Summarize written text (max: 212)"
    echo "  rts| respond-situation  - Respond to situation (max: 96)"
    echo "  gd | group-discussion   - Group discussion summary (max: 71)"
    echo "  rl | retell-lecture     - Retell lecture practice (max: 333)"
    echo "  ss | summarize-spoken   - Summarize spoken text (max: 346)"
    echo
    echo "Example:"
    echo "  $0 rs"
    echo "  $0 di"
    exit 1
}

declare -A question_pools=(
    ["rs"]="1889:speaking/practice?type=SPEAKING_REPEAT_SENTENCE&id=RS"
    ["repeat-sentence"]="1889:speaking/practice?type=SPEAKING_REPEAT_SENTENCE&id=RS"
    ["di"]="843:speaking/practice?type=SPEAKING_DESCRIBE_IMAGE&id=DI"
    ["describe-image"]="843:speaking/practice?type=SPEAKING_DESCRIBE_IMAGE&id=DI"
    ["sp"]="212:writing/practice?type=WRITING_SUMMARIZE_WRITTEN_TEXT&id=SWT"
    ["summarize-passage"]="212:writing/practice?type=WRITING_SUMMARIZE_WRITTEN_TEXT&id=SWT"
    ["rts"]="96:speaking/practice?type=SPEAKING_RESPOND_TO_SITUATION_ACADEMIC&id=RASA"
    ["respond-situation"]="96:speaking/practice?type=SPEAKING_RESPOND_TO_SITUATION_ACADEMIC&id=RASA"
    ["gd"]="71:speaking/practice?type=SPEAKING_SUMMARISE_GROUP_DISCUSSION&id=SGD"
    ["group-discussion"]="71:speaking/practice?type=SPEAKING_SUMMARISE_GROUP_DISCUSSION&id=SGD"
    ["rl"]="333:speaking/practice?type=SPEAKING_RETELL_LECTURE&id=RL"
    ["retell-lecture"]="333:speaking/practice?type=SPEAKING_RETELL_LECTURE&id=RL"
    ["ss"]="346:listening/practice?type=LISTENING_SUMMARIZE_SPOKEN_TEXT&id=SST"
    ["summarize-spoken"]="346:listening/practice?type=LISTENING_SUMMARIZE_SPOKEN_TEXT&id=SST"
)

# check_url() {
#     local url_to_check="$1"
#     if curl --silent --head "$url_to_check" | head -n 1 | grep -q "200 OK"; then
#         return 0
#     else
#         return 1
#     fi
# }

check_url() {
    local url_to_check="$1"
    if curl --silent --head --location "$url_to_check" | grep -q "HTTP.*200"; then
        return 0
    else
        return 1
    fi
}


main() {
    if [ $# -eq 0 ]; then
        usage
    fi

    case $1 in
        -h|--help)
            usage
            ;;
        *)
            pool_name=$1
            ;;
    esac

    if [[ ! ${question_pools[$pool_name]} ]]; then
        echo_error "Invalid pool name: $pool_name"
        usage
    fi

    IFS=':' read -r max_questions endpoint <<< "${question_pools[$pool_name]}"
    max_questions=20 # For free trial
    random_id=$(printf "%04d" $((RANDOM % max_questions + 1)))
    full_url="${QUESTION_BANK_URL}/${endpoint}${random_id}"

    echo_info "Pool: $pool_name"
    echo_info "Question ID: $random_id"

    if check_url "$full_url"; then
        echo_success "URL verified: $full_url"
        "$CHROME_PATH" "$full_url" 2>&1 | tee -a "$LOG_PATH"
    else
        echo_warning "URL check failed: $full_url"
    fi


}

main "$@" 2>&1 | tee -a "$LOG_PATH"

# URL check failed: https://ptemagic.com/pte-academic/question-bank/speaking/practice?type=SPEAKING_REPEAT_SENTENCE&id=RS0008

# EOF