#!/bin/bash

echo "============================="
echo "|       BASIC SCANNING      |"
echo "============================="

TARGET="$1"

# Check if target is provided
if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <IP|Hostname|Subnet>"
    echo
    echo "Examples:"
    echo "  $0 192.168.1.10"
    echo "  $0 scanme.nmap.org"
    echo "  $0 192.168.1.0/24"
    exit 1
fi

# Check if nmap is installed
if ! command -v nmap &>/dev/null; then
    echo "[ERROR] Nmap is not installed."
    exit 1
fi

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

REPORT_DIR="nmap_reports"
REPORT_FILE="$REPORT_DIR/report_$DATE.txt"
OPEN_PORTS_FILE="$REPORT_DIR/open_ports_$DATE.txt"
WEB_FILE="$REPORT_DIR/web_services_$DATE.txt"
VULN_FILE="$REPORT_DIR/vulnerability_$DATE.txt"

mkdir -p "$REPORT_DIR"

echo
echo "========================================="
echo "        NMAP AUTOMATED SCANNER"
echo "========================================="
echo "[+] Target : $TARGET"
echo "[+] Time   : $(date)"
echo

echo "[+] Running Nmap scan..."
# Using decoying (-D) to mask the scanning origin source
nmap -D RND:10 -sV -sC -T4 "$TARGET" -oN "$REPORT_FILE"

# Check whether the scan completed successfully
if [[ $? -ne 0 ]]; then
    echo
    echo "[ERROR] Nmap scan failed."
    exit 1
fi

echo
echo "[+] Extracting open ports..."
grep "/tcp" "$REPORT_FILE" | grep "open" > "$OPEN_PORTS_FILE"

echo
echo "[+] Extracting web services..."
grep -Ei "http|https|apache|nginx|tomcat|iis|lighttpd|caddy" "$OPEN_PORTS_FILE" > "$WEB_FILE"

echo
echo "========================================="
echo "OPEN PORTS"
echo "========================================="

if [[ -s "$OPEN_PORTS_FILE" ]]; then
    cat "$OPEN_PORTS_FILE"
else
    echo "No open TCP ports found."
fi

echo
echo "========================================="
echo "WEB SERVICES"
echo "========================================="

if [[ -s "$WEB_FILE" ]]; then
    cat "$WEB_FILE"
else
    echo "No web services detected."
fi

echo
echo "========================================="
echo "REPORT SUMMARY"
echo "========================================="
echo "Full Report  : $REPORT_FILE"
echo "Open Ports   : $OPEN_PORTS_FILE"
echo "Web Services : $WEB_FILE"
echo "========================================="
echo
echo "[✓] Scan completed successfully."

#############################################
# Vulnerability Scan
#############################################

echo
echo "========================================="
echo "VULNERABILITY SCAN"
echo "========================================="

echo "[+] Running NSE vulnerability scripts..."
nmap --script vuln "$TARGET" -oN "$VULN_FILE"

echo
echo "========================================="
echo "VULNERABILITY ANALYSIS"
echo "========================================="

if grep -qi "VULNERABLE" "$VULN_FILE"; then
    echo "[!] One or more potential vulnerabilities were reported."
    echo
fi

#################################################
# HTTP SQL Injection
#################################################

if grep -qi "http-sql-injection" "$VULN_FILE"; then

    if grep -qi "Script execution failed" "$VULN_FILE" || \
       grep -qi "threw an error" "$VULN_FILE" || \
       grep -qi "bad argument" "$VULN_FILE"; then

        echo "[HTTP SQL Injection]"
        echo "Result : NSE script failed."
        echo "Explanation:"
        echo "  - The SQL Injection script crashed while running."
        echo "  - This DOES NOT confirm SQL Injection."
        echo "  - It also DOES NOT prove the application is secure."
        echo "  - The result should be verified manually."
        echo

    elif grep -qi "VULNERABLE" "$VULN_FILE"; then

        echo "[HTTP SQL Injection]"
        echo "Result : Possible SQL Injection reported."
        echo "Explanation:"
        echo "  - The NSE script detected behavior consistent with SQL Injection."
        echo "  - Review the output and manually verify before drawing conclusions."
        echo

    else

        echo "[HTTP SQL Injection]"
        echo "Result : No SQL Injection detected."
        echo

    fi
fi

#################################################
# DOM XSS
#################################################

if grep -qi "http-dombased-xss" "$VULN_FILE"; then
    echo "[DOM XSS]"
    if grep -qi "Couldn't find any DOM based XSS" "$VULN_FILE"; then
        echo "Result : No DOM-based XSS found."
    else
        echo "Result : Possible DOM-based XSS detected."
    fi
    echo
fi

#################################################
# Stored XSS
#################################################

if grep -qi "http-stored-xss" "$VULN_FILE"; then
    echo "[Stored XSS]"
    if grep -qi "Couldn't find any stored XSS" "$VULN_FILE"; then
        echo "Result : No Stored XSS found."
    else
        echo "Result : Possible Stored XSS detected."
    fi
    echo
fi

#################################################
# CSRF
#################################################

if grep -qi "http-csrf" "$VULN_FILE"; then
    echo "[CSRF]"
    if grep -qi "possible CSRF vulnerabilities" "$VULN_FILE"; then
        echo "Result : Forms requiring manual verification were found."
        echo "Explanation:"
        echo "  - This is NOT proof of a CSRF vulnerability."
        echo "  - The script only found forms that may lack CSRF protection."
        echo
    fi
fi

#################################################
# HTTP Enumeration
#################################################

if grep -qi "http-enum" "$VULN_FILE"; then
    echo "[HTTP Enumeration]"
    echo "Interesting directories discovered:"
    grep -i "Potentially interesting" "$VULN_FILE"
    echo
fi

#################################################
# General Vulnerability Summary
#################################################

echo "========================================="
echo "SUMMARY"
echo "========================================="

OPEN=$(grep -c "/tcp.*open" "$REPORT_FILE")

echo "Open Ports            : $OPEN"

if grep -qi "VULNERABLE" "$VULN_FILE"; then
    echo "Potential Vulnerabilities : YES"
else
    echo "Potential Vulnerabilities : NONE REPORTED"
fi

echo "Vulnerability Report : $VULN_FILE"
echo "========================================="
