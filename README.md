# 🔍 ScannerTools

A collection of **information gathering**, **network scanning**, and **security assessment** tools and automation scripts designed to simplify the reconnaissance phase of security testing and server analysis.

> **Disclaimer:** This project is intended **only for authorized security testing, educational purposes, and system administration.** Do **not** use these tools against systems you do not own or have explicit permission to test.

---

## ✨ Features

* Automated information gathering
* Network discovery
* Port scanning
* Service and version detection
* Host availability checking
* Domain reconnaissance
* Banner grabbing
* DNS enumeration
* WHOIS lookup
* Basic vulnerability assessment
* Easy-to-use Bash scripts
* Organized output for faster analysis

---

## 📁 Project Structure

```
ScannerTools/
│
├── nmap.sh               # Automated Nmap scanning script
├── scripts/              # Additional scanning scripts
├── output/               # Scan results (generated)
├── wordlists/            # Optional wordlists
└── README.md
```

---

## 🛠️ Requirements

Before using the tools, install the following dependencies.

### Linux (Debian/Ubuntu)

```bash
sudo apt update

sudo apt install \
nmap \
dnsutils \
whois \
curl \
wget \
netcat-openbsd \
traceroute \
jq \
git
```

---

## 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/Ro706/ScannerTools.git

cd ScannerTools
```

Give execution permission:

```bash
chmod +x *.sh
```

or

```bash
chmod +x scripts/*.sh
```

---

## 💻 Usage

Example:

```bash
./nmap.sh example.com
```

or

```bash
./nmap.sh 192.168.1.1
```

The script automatically performs multiple scanning tasks and displays useful information about the target.

---

## 🔍 Scan Capabilities

The toolkit can perform tasks such as:

* Host discovery
* TCP port scanning
* Service detection
* Version detection
* OS detection (where supported)
* DNS lookup
* Reverse DNS lookup
* WHOIS information
* HTTP header analysis
* SSL/TLS information
* Traceroute
* Banner grabbing
* Basic enumeration

---

## 📊 Example Output

```
=========================================
        NMAP AUTOMATED SCANNER
=========================================

Target : example.com

Host is up.

Open Ports:
22/tcp   SSH
80/tcp   HTTP
443/tcp  HTTPS

Service Versions:
OpenSSH 9.x
Apache 2.4.x

Operating System:
Linux
```

---

## 🎯 Use Cases

* Penetration Testing
* Vulnerability Assessment
* Server Auditing
* Network Administration
* Security Research
* Capture The Flag (CTF)
* Cybersecurity Learning

---

## ⚠️ Legal Notice

Only scan systems that:

* You own
* You manage
* You have written permission to test

Unauthorized scanning may violate laws or terms of service.

---

## 🤝 Contributing

Contributions are welcome.

If you have improvements or additional scripts:

1. Fork the repository.
2. Create a new branch.
3. Commit your changes.
4. Submit a Pull Request.

---

## 👨‍💻 Author

**Ro706**

* GitHub: https://github.com/Ro706

---

## 📜 License

This project is released under the **MIT License**.

Feel free to use, modify, and distribute it in accordance with the license terms.
