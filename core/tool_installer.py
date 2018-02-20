#!/usr/bin/env python
import os, stat
import urllib2
import sys, platform
import json
import datetime, time

core_dir = os.path.join(os.path.expanduser("~"), "SOE/core")
with open(os.path.join(core_dir, 'tooldata.json'), 'r') as f:
    tools = json.load(f)
tooldb = {}
try:
	with open(os.path.join(core_dir, "installeddb.json"), "r") as inf:
		tooldb = json.load(inf)
except IOError:
    pass

def arch_string():
    un = os.uname()
    if un[0] in ["Linux", "linux", "linux2"] and un[4] == "x86_64":
        return "amd64"
    elif un[0] == "Linux" and un[4] == "armv6l":
        return "arm"
    else:
        raise Exception("Could not determine platform.")

def timezone_offset_hours():
    return round((round((datetime.datetime.now()-datetime.datetime.utcnow()).total_seconds())/1800)/2)

def convert_enddate(ts):
    """Takes ISO 8601 format(string) and converts into epoch time."""
    return datetime.datetime.strptime(ts,'%Y-%m-%dT%H:%M:%SZ') + datetime.timedelta(hours=timezone_offset_hours())

def sizeof_fmt(num, suffix='B'):
    for unit in ['','Ki','Mi','Gi','Ti','Pi','Ei','Zi']:
        if abs(num) < 1024.0:
            return "%3.1f%s%s" % (num, unit, suffix)
        num /= 1024.0
    return "%.1f%s%s" % (num, 'Yi', suffix)

#copy pasta for python colors
class bcolors(object):
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def log_install(name, version, release):
    global tooldb
    tooldb[name] = {
        "version": version,
        "installed_at": int(time.time()),
        "release": release,
    }
    with open(os.path.join(core_dir, "installeddb.json"), "wt") as out:
        json.dump(tooldb, out, sort_keys=True, indent=4, separators=(',', ': '))

def rfc3339_to_epoch(i):
    dt = datetime.datetime.strptime(i, '%Y-%m-%dT%H:%M:%SZ')
    return (dt - datetime.datetime(1970,1,1)).total_seconds()

def pick_latest_release(releases):
    earliest = 0
    release = None
    for x in releases:
        if rfc3339_to_epoch(x['published_at']) > earliest:
            earliest = rfc3339_to_epoch(x['published_at'])
            release = x
    return release

def install_from_github(tool):
    repo_response = urllib2.urlopen("https://api.github.com/repos/%s/%s/releases" % (tool['github-data']['user'], tool['github-data']['repo']))
    if repo_response.getcode() != 200:
        print(bcolors.FAIL + "Unexpected error code: %d" % repo_response.getcode() + bcolors.ENDC)
        sys.exit(3)

    repo_list = json.load(repo_response)
    print("There are " + str(len(repo_list)) + bcolors.ENDC + " releases of " + bcolors.OKBLUE + tool['name'] + bcolors.ENDC + ".")
    release = pick_latest_release(repo_list)
    published_at_delta = (datetime.datetime.now()-convert_enddate(release['published_at']))
    print("Latest version " + bcolors.OKGREEN + release['name'] + bcolors.ENDC + " has been selected (" + "published " + bcolors.OKGREEN + str(published_at_delta.days) + bcolors.ENDC + " days ago).")

    for piece in tool['artifacts']:
        asset_name = piece['name']
        if piece['check-arch']:
            print("Fetching " + bcolors.OKBLUE + piece['name'] + bcolors.ENDC + " for " + bcolors.OKBLUE + arch_string() + bcolors.ENDC + " into " + bcolors.OKGREEN + piece['path'] + bcolors.ENDC)
            asset_name += '-' + arch_string()
        else:
            print("Fetching " + bcolors.OKBLUE + piece['name'] + bcolors.ENDC + " into " + bcolors.OKGREEN + piece['path'] + bcolors.ENDC)
        artifact = [x for x in release['assets'] if x['name'] == asset_name][0]
        print("Downloading " + bcolors.OKGREEN + sizeof_fmt(artifact['size']) + bcolors.ENDC + " ...")
        bin_resp = urllib2.urlopen(artifact['browser_download_url'])
        if bin_resp.getcode() != 200:
            print(bcolors.FAIL + "Unexpected error code: %d" % bin_resp.getcode() + bcolors.ENDC)
            sys.exit(3)
        with open(piece['path'], 'w') as output:
            while True:
                data = bin_resp.read(100000)
                if data == '':  # end of file reached
                    break
                output.write(data)
        print ("Done saving to " + bcolors.OKGREEN + piece['path'] + bcolors.ENDC + ".")
        if piece['set-exec']:
            st = os.stat(piece['path'])
            os.chmod(piece['path'], st.st_mode | stat.S_IEXEC | stat.S_IXGRP | stat.S_IXOTH)
            print ("Set " + bcolors.OKGREEN + piece['path'] + bcolors.ENDC + " as globally executable.")
        log_install(tool['name'], release['name'], release)

def install(tool):
    print("Installing: " + bcolors.OKBLUE + tool['name'] + bcolors.ENDC)
    if tool['type'] == 'github-binary':
        install_from_github(tool)
    else:
        print(bcolors.FAIL + "Tool found in database but unknown tool type: '%s'" % tool['type'] + bcolors.ENDC)
        sys.exit(2)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: soe-install <tool>|all")
        sys.exit(1)
    else:
        try:
            for tool in tools:
                if sys.argv[1] == "all" or sys.argv[1] == tool['name']:
                    install(tool)

        except IOError, e:
            print(bcolors.FAIL + "IOError!: Do you have adequate permissions?" + bcolors.ENDC)
            print(bcolors.FAIL + "\t%s" % str(e) + bcolors.ENDC)
            sys.exit(4)
