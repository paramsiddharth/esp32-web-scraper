baud_rate := 115200

.PHONY: doit deps pip-deps flash serial ls get-source view-source put-source clear-source

doit: put-source

deps: pip-deps esp32-20210623-v1.16.bin

pip-deps:
	pip install esptool adafruit-ampy

esp32-20210623-v1.16.bin:
	wget https://micropython.org/resources/firmware/esp32-20210623-v1.16.bin

flash:
	esptool --port $(port) erase_flash
	esptool --port $(port) --chip esp32 write_flash -z 0x1000 esp32-20210623-v1.16.bin

serial:
	putty -serial $(port) -sercfg "${baud_rate},8,n,1,N"

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