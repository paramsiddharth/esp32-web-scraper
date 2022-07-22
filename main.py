import sys
import gc
from machine import Pin
from time import sleep
import network as net
import urequests as req
import ujson as json

app = {}

def atexit():
	try:
		if 'server' in app:
			app['server'].disconnect()
			print('Disconnected successfully!')
			app['server'].active(False)
		
		if 'led' in app:
			led = app['led']

			led.value(True)
			sleep(1)
			led.value(False)
			sleep(0.1)
			led.value(True)
			sleep(0.2)
			led.value(False)
	except:
		...

def setup():
	with open('data.json', 'r', encoding='utf-8') as f:
		creds = json.load(f)

	s = net.WLAN(net.STA_IF)
	app['server'] = s

	s.active(True)
	s.config(dhcp_hostname='esp32mcu')
	s.connect(creds.get('name'), creds.get('password'))

	if not s.isconnected():
		sleep(5)

	if not s.isconnected():
		print('Failed to connect!', file=sys.stderr)
		sys.exit(1)

	print('Connected to {0} successfully!'.format(creds.get('name')))

	app['i'] = 0
	app['url'] = 'http://worldtimeapi.org/api/timezone/Asia/Kolkata'
	gc.collect()

	led = Pin(2, Pin.OUT)
	app['led'] = led

	led.value(True)
	sleep(0.2)
	led.value(False)
	sleep(0.1)
	led.value(True)
	sleep(0.2)
	led.value(False)

def loop():
	app['i'] = app.get('i') + 1
	
	resp = req.get(app['url'])
	obj = json.loads(resp.text)
	resp.close()

	print('Current date and time (Zone: {0}): {1}'.format(obj['timezone'], obj['datetime']))

	led = app['led']

	led.value(True)
	sleep(0.1)
	led.value(False)
	sleep(0.2)
	led.value(True)
	sleep(0.1)
	led.value(False)

	del obj
	del resp
	gc.collect()
	return app['i'] < 100

try:
	setup()
	while loop():
		sleep(5)
except Exception as e:
	print('Error:', e, file=sys.stderr)
except KeyboardInterrupt:
	pass
atexit()