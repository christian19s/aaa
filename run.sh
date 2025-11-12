#!/usr/bin/env

echo "Analyzing vhd files..."
ghdl -a $@

read -p "Test bench> " bench

ghdl -e $bench
echo "Generating waveform..."
ghdl -r  $bench --wave=$bench.ghw


read -p "Display waveform?" yn
	case $yn in
	[yY] )	
		gtkwave ${bench}.ghw
		exit 0
		;;
	[nN] )
		exit 0
		;;
	*)	
		gtkwave ${bench}.ghw
		exit 0
		;;
esac
	
