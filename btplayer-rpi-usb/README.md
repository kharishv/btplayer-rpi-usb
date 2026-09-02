# Headless Bluetooth & USB Audio Player for Raspberry Pi

An automated background systemd service designed for a Raspberry Pi 3 Model B (running Raspberry Pi OS Lite 64-bit). It automatically pairs with a Bluetooth speaker upon boot, checks a local directory for audio files first, rolls over to an attached USB thumb drive if needed, and loops playback seamlessly.

## Why ? 

Have a BT speaker that doesn't have a usb slot and needed a plug-n-play option for existing usb drives with songs in it :) 

## Repository Folder Structure

```text
rpi-bt-audio-player/
├── README.md
├── scripts/
│   └── bt-music-player.sh
└── systemd/
    └── bt-player.service
```

## Setup/Run details

1. Update MAC and USB folder name - script file
2. Update user details in systemd file
3. cp script file to '/usr/local/bin' 
4. create systemd service file ( /etc/systemd/system/<bt-player.service>
5. Enable and start service
	- sudo systemctl daemon-reload
	- sudo systemctl enable bt-player.service
	- sudo systemctl start bt-player.service

## Troubleshooting
1. Logs at - sudo journalctl -u bt-player.service -f
2. Interactive BT utility
	- bluetoothctl
		* power on
		* agent on
		* default-agent
		* scan on ## Scans for available bt devices ( MAC addr can be identified here )
		* pair <MAC Addr>
		* connect <MAC Addr>
		* trust <MAC Addr>
		* info <MAC Addr> ## get active connection status 
3. To play the song manually from rpi - ffplay -nodisp -autoexit <song file name>

## TODOs
- Implement in python or c++
- Need to manually edit config details - make it automatic or have a config file instead
- Accomodate more extn types ( .wav etc )
