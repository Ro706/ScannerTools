import requests
def get_ip():
   response = requests.get('https://api64.ipify.org?format=json').json()
   return response["ip"]
def get_location(ip_address):
   response = requests.get(f'https://ipapi.co/{ip_address}/json/').json()
   location_data = {
       "IP": ip_address,
       "City": response.get("city"),
       "Region": response.get("region"),
       "Country": response.get("country_name"),
       "Latitude": response.get("latitude"),
       "Longitude": response.get("longitude")
   }
   return location_data
ip = get_ip()
location = get_location(ip)
print(location)
