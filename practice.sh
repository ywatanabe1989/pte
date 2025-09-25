#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2025-09-25 23:45:51 (ywatanabe)"
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

NC='\033[0m'

QUESTION_BANK_URL="https://ptemagic.com/pte-academic/question-bank"
CHROME_PATH="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"

usage() {
    echo "Usage: $0 [POOL_NAME] [-c|--continuous] [-h|--help]"
    echo
    echo "Opens a random PTE practice question from the specified pool."
    echo "If no pool name is provided, randomly selects a pool."
    echo
    echo "Options:"
    echo "  -c, --continuous  Continue with next question after closing browser"
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
    echo "  $0 di -c"
    echo "  $0 -c        # Random pool selection with continuous mode"
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

pool_keys=("rs" "di" "sp" "rts" "gd" "rl" "ss")

check_url() {
    local url_to_check="$1"
    if curl --silent --head --location "$url_to_check" | grep -q "HTTP.*200"; then
        return 0
    else
        return 1
    fi
}

open_question() {
    local selected_pool="$1"

    if [[ ! ${question_pools[$selected_pool]} ]]; then
        echo_error "Invalid pool name: $selected_pool"
        return 1
    fi

    IFS=':' read -r max_questions endpoint <<< "${question_pools[$selected_pool]}"
    max_questions=20
    random_id=$(printf "%04d" $((RANDOM % max_questions + 1)))
    full_url="${QUESTION_BANK_URL}/${endpoint}${random_id}"

    echo_info "Pool: $selected_pool"
    echo_info "Question ID: $random_id"

    if check_url "$full_url"; then
        echo_success "URL verified: $full_url"
        "$CHROME_PATH" "$full_url" &
        chrome_pid=$!
        wait $chrome_pid
        echo_info "Browser closed"
    else
        echo_warning "URL check failed: $full_url"
        return 1
    fi
}

main() {
    continuous_mode=false
    pool_name=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                ;;
            -c|--continuous)
                continuous_mode=true
                shift
                ;;
            *)
                pool_name="$1"
                shift
                ;;
        esac
    done

    if [[ -z "$pool_name" ]]; then
        pool_name="${pool_keys[$((RANDOM % ${#pool_keys[@]}))]}"
        echo_info "Randomly selected pool: $pool_name"
    fi

    if $continuous_mode; then
        echo_info "Continuous mode enabled. Press Ctrl+C to exit."
        while true; do
            current_pool="${pool_keys[$((RANDOM % ${#pool_keys[@]}))]}"
            echo_info "Next question from pool: $current_pool"
            open_question "$current_pool"
            sleep 1
        done
    else
        open_question "$pool_name"
    fi
}

main "$@" 2>&1 | tee -a "$LOG_PATH"

# EOF