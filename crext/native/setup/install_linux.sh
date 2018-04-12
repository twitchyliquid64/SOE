#!/bin/bash

if [ ! -d "~/.config/google-chrome/NativeMessagingHosts/" ]; then
  mkdir -p ~/.config/google-chrome/NativeMessagingHosts/
fi

cp com.soe.native.json ~/.config/google-chrome/NativeMessagingHosts/
