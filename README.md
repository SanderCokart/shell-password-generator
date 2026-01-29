# Password Generator - Shell Script

A secure, cross-platform password generator written in Bash that creates random passwords with customizable character sets and various security options.

## Quick Install

### Linux/macOS
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.sh | bash
```

### Windows (PowerShell)
```powershell
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.bat -o install.bat && .\install.bat
```

Or using PowerShell directly:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.bat" -OutFile "install.bat"; .\install.bat
```

## Features

- **Multiple Character Sets**: Choose from predefined character sets optimized for different use cases
- **Customizable Length**: Generate passwords from 1 to unlimited characters
- **Security Options**: Ensure all character types are present for maximum security
- **Cross-Platform**: Works on Linux, macOS, and Windows (with bash)
- **No Dependencies**: Pure bash script with no external dependencies
- **Fast**: Generates passwords instantly

## Character Sets

| Set | Characters | Use Case |
|-----|------------|----------|
| `RESTRICTED` | `A-Z a-z 0-9 _ - . @` | Environment variables, URLs, general use |
| `UNRESTRICTED` | `A-Z a-z 0-9 !@#$%^&*()_-=+[]{}|:;,.<>?` | Maximum security, all special chars |
| `BASIC` | `!@#$%^&*` | Basic special characters |
| `URL_SAFE` | `-_.~!*()` | RFC 3986 compliant URL-safe |
| `URL_ULTRA_SAFE` | `-_.~` | Ultra-safe, never percent-encoded |
| `NONE` | (alphanumeric only) | No special characters |

## Usage

After installation, use the `password-generator` command:

```bash
# Generate default password (12 chars, RESTRICTED set)
password-generator

# Generate 16-character password
password-generator -l 16

# Generate password with all character types ensured
password-generator -e

# Generate URL-safe password
password-generator -c URL_SAFE -l 20

# Generate with unrestricted character set
password-generator -c UNRESTRICTED -l 24 -e
```

### Command Options

```
Usage: password-generator [OPTIONS]

Options:
  -l, --length LENGTH     Password length (default: 12)
  -c, --charset CHARSET   Character set (default: RESTRICTED)
  -e, --ensure-types      Ensure at least one of each character type
  -h, --help             Show help message

Available character sets:
  RESTRICTED       Safe for ENV files and URLs (alphanumeric + _ - . @)
  UNRESTRICTED     All special characters (alphanumeric + !@#$%^&*()_-=+[]{}|:;,.<>?)
  BASIC            Basic special characters (!@#$%^&*)
  URL_SAFE         RFC 3986 compliant URL-safe characters (-_.~!*())
  URL_ULTRA_SAFE   Ultra-safe, never percent-encoded (-_.~)
  NONE             No special characters
```

## Examples

```bash
# Basic usage
$ password-generator
Generated password (12 chars, RESTRICTED): Ab3XyZ9mNp2K

# Long password with all types
$ password-generator -l 20 -e
Generated password (20 chars, RESTRICTED): A1b!C2d@E3f.G4h_I5jK

# URL-safe password
$ password-generator -c URL_SAFE -l 16
Generated password (16 chars, URL_SAFE): aB3~cD4.eF5_gH6!

# Maximum security
$ password-generator -c UNRESTRICTED -l 32 -e
Generated password (32 chars, UNRESTRICTED): P@ssW0rd!S3cur3#H@sh.G3n3r@t0r
```

## Uninstall

### Linux/macOS
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/uninstall.sh | bash
```

### Windows (PowerShell)
```powershell
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/uninstall.bat -o uninstall.bat && .\uninstall.bat
```

Or using PowerShell directly:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/uninstall.bat" -OutFile "uninstall.bat"; .\uninstall.bat
```

## Requirements

### Linux/macOS
- Bash shell
- Standard Unix tools: `fold`, `shuf`, `tr`
- `curl` or `wget` for installation

### Windows
- Windows 10 or later
- One of the following for bash execution:
  - Git for Windows (includes bash)
  - Windows Subsystem for Linux (WSL)
  - MSYS2
- PowerShell or curl for installation

## Security Notes

- Passwords are generated using `/dev/urandom` (Linux/macOS) or system randomness
- No passwords are stored or logged
- Script runs locally with no network communication during password generation
- Character sets are carefully chosen for compatibility and security

## Development

To contribute or modify the script:

1. Clone the repository
2. Make changes to `script.sh`
3. Test on multiple platforms
4. Submit a pull request

## License

MIT License - see LICENSE file for details.

## Author

Created for secure password generation across platforms.