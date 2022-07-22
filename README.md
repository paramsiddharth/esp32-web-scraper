# Web Scraper (ESP32) 
A simple web scraper that runs on an ESP-32 microcontroller.

# Instructions
Follow the given instructions to deploy this application to your own ESP32 microcontroller.

For the examples, assume the port to be accessible at `/dev/ttyUSB0`.

## Installing Dependencies
Install all Python dependenies locally and download the firmware.
```bash
make deps port=/dev/ttyUSB0
```

## Firmware
Deploy the firmware.
```bash
make flash port=/dev/ttyUSB0
```

## Store Wi-Fi Credentials
Create a new file `data.json` in the source directory and enter
the credentials in the following format:
```json
{
	"name": "<Network Name>",
	"password": "<Hotspot Password>"
}
```

## Copy Scripts
Copy the Python scripts.
```bash
make port=/dev/ttyUSB0
```

You're done! Now you can connect the microcontroller to any power source and get it working.

If you connect to the serial monitor, you'll be able to see the data it fetches.

# Made with ❤ by [Param](https://www.paramsid.com).