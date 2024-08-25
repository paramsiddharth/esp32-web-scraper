baud_rate := 115200
# Previously esp32-20210623-v1.16.bin
firmware := ESP32_GENERIC-20240602-v1.23.0.bin

.PHONY: doit deps pip-deps flash serial ls get-source view-source put-source clear-source

doit: put-source

deps: pip-deps ${firmware}

pip-deps:
	pip install esptool adafruit-ampy

pip-deps-dev:
	pip install micropy-cli

${firmware}:
	wget "https://micropython.org/resources/firmware/${firmware}"

flash:
	python -m esptool --port $(port) erase_flash
	python -m esptool --port $(port) --chip esp32 write_flash -z 0x1000 ${firmware}

serial-putty:
	putty -serial $(port) -sercfg "${baud_rate},8,n,1,N"

serial-screen:
	screen $(port) ${baud_rate}

ls:
	ampy --port $(port) --baud ${baud_rate} ls

get-source:
	ampy --port $(port) --baud ${baud_rate} get boot.py original-boot.py
	-ampy --port $(port) --baud ${baud_rate} get main.py original-main.py 2>/dev/null
	-ampy --port $(port) --baud ${baud_rate} get data.json original-data.json 2>/dev/null

view-source:
	ampy --port $(port) --baud ${baud_rate} get boot.py
	-ampy --port $(port) --baud ${baud_rate} get main.py 2>/dev/null

put-source:
	ampy --port $(port) --baud ${baud_rate} put boot.py
	ampy --port $(port) --baud ${baud_rate} put main.py
	ampy --port $(port) --baud ${baud_rate} put data.json

clear-source:
	-ampy --port $(port) --baud ${baud_rate} rm data.json 2>/dev/null
	-ampy --port $(port) --baud ${baud_rate} rm main.py 2>/dev/null