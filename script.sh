#!/bin/bash

# Password Generator - Shell Version
# Generates secure random passwords with customizable character sets

# Character sets for different compatibility levels
declare -A CHAR_SETS=(
    ["RESTRICTED"]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-.@"  # ENV and URL-safe special chars
    ["UNRESTRICTED"]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_-=+[]{}|:;,.<>?"  # All special chars
    ["BASIC"]="!@#$%^&*"
    ["URL_SAFE"]="-_.~!*()"
    ["URL_ULTRA_SAFE"]="-_.~"
    ["NONE"]=""
)

# Default values
DEFAULT_LENGTH=12
DEFAULT_CHARSET="RESTRICTED"

# Function to generate random password
generate_password() {
    local length=$1
    local charset_name=$2
    local charset="${CHAR_SETS[$charset_name]}"
    local ensure_all_types=$3

    # Base character pools
    local lowercase="abcdefghijklmnopqrstuvwxyz"
    local uppercase="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local numbers="0123456789"
    local all_chars="$lowercase$uppercase$numbers$charset"

    local password=""

    if [[ "$ensure_all_types" == "true" ]] && [[ $length -ge 4 ]]; then
        # Ensure at least one of each type
        password+=$(echo "$lowercase" | fold -w1 | shuf -n1)
        password+=$(echo "$uppercase" | fold -w1 | shuf -n1)
        password+=$(echo "$numbers" | fold -w1 | shuf -n1)
        if [[ -n "$charset" ]]; then
            password+=$(echo "$charset" | fold -w1 | shuf -n1)
        fi

        # Fill the rest randomly
        local remaining=$((length - ${#password}))
        password+=$(echo "$all_chars" | fold -w1 | shuf -n$remaining | tr -d '\n')

        # Shuffle the password
        password=$(echo "$password" | fold -w1 | shuf | tr -d '\n')
    else
        # Generate completely random password
        password=$(echo "$all_chars" | fold -w1 | shuf -n$length | tr -d '\n')
    fi

    echo "$password"
}

# Function to display usage
usage() {
    echo "Password Generator - Shell Version"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -l, --length LENGTH     Password length (default: $DEFAULT_LENGTH)"
    echo "  -c, --charset CHARSET   Character set (default: $DEFAULT_CHARSET)"
    echo "  -e, --ensure-types      Ensure at least one of each character type"
    echo "  -h, --help             Show this help message"
    echo ""
    echo "Available character sets:"
    echo "  RESTRICTED       Safe for ENV files and URLs (alphanumeric + _ - . @)"
    echo "  UNRESTRICTED     All special characters (alphanumeric + !@#$%^&*()_-=+[]{}|:;,.<>?)"
    echo "  BASIC            Basic special characters (!@#$%^&*)"
    echo "  URL_SAFE         RFC 3986 compliant URL-safe characters (-_.~!*())"
    echo "  URL_ULTRA_SAFE   Ultra-safe, never percent-encoded (-_.~)"
    echo "  NONE             No special characters"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Generate default password (RESTRICTED)"
    echo "  $0 -l 16                             # 16 character RESTRICTED password"
    echo "  $0 -c UNRESTRICTED -l 20             # UNRESTRICTED 20 char password"
    echo "  $0 -c URL_SAFE -l 16                 # URL-safe 16 char password"
    echo "  $0 -c BASIC -e                       # Basic chars, ensure all types"
    echo ""
}

# Parse command line arguments
length=$DEFAULT_LENGTH
charset=$DEFAULT_CHARSET
ensure_types=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -l|--length)
            length="$2"
            shift 2
            ;;
        -c|--charset)
            charset="$2"
            shift 2
            ;;
        -e|--ensure-types)
            ensure_types=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validate charset
if [[ ! -v CHAR_SETS[$charset] ]]; then
    echo "Error: Unknown charset '$charset'"
    echo ""
    echo "Available charsets:"
    for key in "${!CHAR_SETS[@]}"; do
        echo "  $key"
    done
    exit 1
fi

# Validate length
if ! [[ "$length" =~ ^[0-9]+$ ]] || [[ $length -lt 1 ]]; then
    echo "Error: Length must be a positive integer"
    exit 1
fi

# Generate and display password
password=$(generate_password "$length" "$charset" "$ensure_types")
echo "Generated password (${length} chars, ${charset}): ${password}"