#!/bin/sh

# Password Generator - Shell Version
# Generates secure random passwords with customizable character sets

# Character sets for different compatibility levels (sh-compatible)
CHAR_SET_RESTRICTED="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-.@"  # ENV and URL-safe special chars
CHAR_SET_UNRESTRICTED="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()_-=+[]{}|:;,.<>?"  # All special chars
CHAR_SET_BASIC="!@#\$%^&*"
CHAR_SET_URL_SAFE="-_.~!*()"
CHAR_SET_URL_ULTRA_SAFE="-_.~"
CHAR_SET_NONE=""

# Default values
DEFAULT_LENGTH=12
DEFAULT_CHARSET="RESTRICTED"

# Function to get charset by name (sh-compatible)
get_charset() {
    charset_name=$1
    case $charset_name in
        RESTRICTED) echo "$CHAR_SET_RESTRICTED" ;;
        UNRESTRICTED) echo "$CHAR_SET_UNRESTRICTED" ;;
        BASIC) echo "$CHAR_SET_BASIC" ;;
        URL_SAFE) echo "$CHAR_SET_URL_SAFE" ;;
        URL_ULTRA_SAFE) echo "$CHAR_SET_URL_ULTRA_SAFE" ;;
        NONE) echo "$CHAR_SET_NONE" ;;
        *) echo "" ;;
    esac
}

# Function to check if charset is valid (sh-compatible)
is_valid_charset() {
    charset_name=$1
    case $charset_name in
        RESTRICTED|UNRESTRICTED|BASIC|URL_SAFE|URL_ULTRA_SAFE|NONE) return 0 ;;
        *) return 1 ;;
    esac
}

# Function to generate random password
generate_password() {
    length=$1
    charset_name=$2
    ensure_all_types=$3

    charset=$(get_charset "$charset_name")

    # Base character pools
    lowercase="abcdefghijklmnopqrstuvwxyz"
    uppercase="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    numbers="0123456789"
    all_chars="$lowercase$uppercase$numbers$charset"

    password=""

    if [ "$ensure_all_types" = "true" ] && [ "$length" -ge 4 ] 2>/dev/null; then
        # Ensure at least one of each type
        password="$password$(echo "$lowercase" | fold -w1 | shuf -n1)"
        password="$password$(echo "$uppercase" | fold -w1 | shuf -n1)"
        password="$password$(echo "$numbers" | fold -w1 | shuf -n1)"
        if [ -n "$charset" ]; then
            password="$password$(echo "$charset" | fold -w1 | shuf -n1)"
        fi

        # Fill the rest randomly
        remaining=$(expr $length - $(echo "$password" | wc -c | awk '{print $1}'))
        password="$password$(echo "$all_chars" | fold -w1 | shuf -n$remaining | tr -d '\n')"

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

while [ $# -gt 0 ]; do
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
if ! is_valid_charset "$charset"; then
    echo "Error: Unknown charset '$charset'"
    echo ""
    echo "Available charsets:"
    echo "  RESTRICTED"
    echo "  UNRESTRICTED"
    echo "  BASIC"
    echo "  URL_SAFE"
    echo "  URL_ULTRA_SAFE"
    echo "  NONE"
    exit 1
fi

# Validate length (sh-compatible numeric check)
if ! echo "$length" | grep -q '^[0-9]\+$' || [ "$length" -lt 1 ] 2>/dev/null; then
    echo "Error: Length must be a positive integer"
    exit 1
fi

# Generate and display password
password=$(generate_password "$length" "$charset" "$ensure_types")
echo "Generated password (${length} chars, ${charset}): ${password}"