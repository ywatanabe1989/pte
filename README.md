<!-- ---
!-- Timestamp: 2025-09-25 23:59:53
!-- Author: ywatanabe
!-- File: /home/ywatanabe/proj/pte/README.md
!-- --- -->

# PTE Exam Preparation (for myself)


## Usage

``` bash
alias pte="/path/to/pte/practice.sh"
./practice.sh --help

# Usage: /home/ywatanabe/proj/pte/practice.sh [POOL_NAME] [-c|--continuous] [-h|--help]
#  
# Opens a random PTE practice question from the specified pool.
# If no pool name is provided, randomly selects a pool.
#  
# Options:
#   -c, --continuous  Continue with next question after closing browser
#  
# Available pools:
#   rs | repeat-sentence    - Repeat sentence practice (max: 1889)
#   di | describe-image     - Describe image practice (max: 843)
#   sp | summarize-passage  - Summarize written text (max: 212)
#   rts| respond-situation  - Respond to situation (max: 96)
#   gd | group-discussion   - Group discussion summary (max: 71)
#   rl | retell-lecture     - Retell lecture practice (max: 333)
#   ss | summarize-spoken   - Summarize spoken text (max: 346)
#  
# Example:
#   /home/ywatanabe/proj/pte/practice.sh rs
#   /home/ywatanabe/proj/pte/practice.sh di -c
#   /home/ywatanabe/proj/pte/practice.sh -c        # Random pool selection with continuous mode
```

## Contact
ywatanabe@scitex.ai

<!-- EOF -->