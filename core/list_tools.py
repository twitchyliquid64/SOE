#!/usr/bin/env python
import os, stat
import urllib2
import sys, platform
import json
import datetime, time

core_dir = os.path.join(os.path.expanduser("~"), "SOE/core")
with open(os.path.join(core_dir, 'tooldata.json'), 'r') as f:
    tools = json.load(f)

for tool in tools:
    print tool['name']
