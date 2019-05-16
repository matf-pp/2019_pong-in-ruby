#!/bin/bash
# PongOnRuby installer script

echo "#### Installing Pong on Ruby dependencies ####"
echo

echo "Installing required gems:"

echo " 1. SerialPort - emulating serial port through usb"
gem install serialport
echo "Finished installing gem 1/2."
echo
 
echo " 2. OpenGL - bindings for popular graphic api"
gem install opengl
echo "Finished installing gem 2/2."
echo

echo "Adding constant name for connected joystick box"
touch /etc/udev/rules.d/proba
echo "SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", SYMLINK+="ttyArduino"" > /etc/udev/rules.d/proba
echo "Finished adding udev rule."
echo


echo "To run the game: ruby pongOnRuby.rb"
echo "#### Have a nice day ! ####"

echo
