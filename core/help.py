#!/usr/bin/env python
import os
import json
import sys

util_funcs_dir = os.path.join(os.path.expanduser("~"), "SOE/utility_funcs")
core_dir = os.path.join(os.path.expanduser("~"), "SOE/core")

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

#data object used to store the data associated with an annotation.
class annotation(object):
	def __init__(self, fname, line):
		self.type = "Unknown or Invalid"
		self.fname = fname
		self.line = line

	def __str__(self):
		out = ""
		if self.type == "func":
			out = bcolors.OKGREEN + "Function annotation: " + bcolors.WARNING + str(self.funcname) + bcolors.ENDC
		elif self.type == "description":
			out = bcolors.OKGREEN + "Description annotation:" + bcolors.ENDC
		elif self.type == "usage":
			out = bcolors.OKGREEN + "Usage annotation: " + bcolors.WARNING + str(self.arg) + bcolors.ENDC
		out += " (" + self.fname + " : " + str(self.line) + ")"
		return out

#parse the given line, returning an annotation() object representing the annotation on the given line.
def parseAnnotation(line, fname, lineno):
	spaceSPL = line.strip().split(" ")
	ret = annotation(fname, lineno)
	if spaceSPL[0] == "#@function":
		ret.type = "func"
		ret.funcname = spaceSPL[1]
	if spaceSPL[0] == "#@description":
		ret.type = "description"
		ret.description = " ".join(spaceSPL[1:])
	if spaceSPL[0] == "#@usage":
		if spaceSPL[1].startswith("$"):
			ret.type = "usage"
			ret.arg = spaceSPL[1][1:]
			ret.description = " ".join(spaceSPL[2:])
		else:
			print("Parse error - could not read argument section. " + ret)
	return ret

#iterate the lines in the file at absolute path fpath, returning all annotations inside the file.
def processBashFile(fpath):
	print("Parsing: " + bcolors.OKBLUE + fpath + bcolors.ENDC)
	fhd = open(fpath, "r")
	lineno = 0
	annotations = []
	for line in fhd:
		lineno += 1
		if line.startswith("#@"):
			a = parseAnnotation(line, fpath, lineno)
			print "\t" + str(a) if a.type in ["func"] else "\t\t" + str(a)
			annotations.append(a)
	fhd.close()
	return annotations


#iterate the given absolute directory, returning all annotations in files inside that directory.
def parse_dir(dir):
	annotations = []
	for filename in os.listdir(dir):
		fpath = os.path.join(dir, filename)
		annotations.extend(processBashFile(fpath))
	return annotations

def rebuild():
	#parse all the directories we care about and store the annotations linearly.
	annotations = []
	annotations.extend(parse_dir(util_funcs_dir))
	#print [str(x) for x in annotations]
	helpObjs = {}
	current_parse_context = ""
	current_help_obj_structure = None

	#iterate annotations and combine them into help objects
	for annotation in annotations:

		#deal with the contextual annotations
		if current_parse_context == "": #not legal - cannot have contextual annotation without first reading a top-level annotation like function
			if annotation.type in ["description", "usage"]:
				print "Error: Descriptive annotation not prefixed by a more general annotation - " + str(annotation)
		else:
			if annotation.type == "description":
				current_help_obj_structure['description'] = annotation.description
			if annotation.type == "usage":
				current_help_obj_structure['args'][annotation.arg] = annotation.description

		#deal with the top-level annotations
		if annotation.type in  ["func"]: #if we have a first-class annotation (resets state)
			if current_help_obj_structure != None: #reset state
				helpObjs[current_help_obj_structure['name']] = current_help_obj_structure
				current_help_obj_structure = None

			if annotation.type == "func": #if we are a functional annotation - setup state and record
				current_help_obj_structure = dict()
				current_parse_context = "func"
				current_help_obj_structure['name'] = annotation.funcname
				current_help_obj_structure['description'] = ""
				current_help_obj_structure['args'] = {}
				current_help_obj_structure['type'] = 'func'

	if current_help_obj_structure != None: #something in there from the final iteration - add to list
		helpObjs[current_help_obj_structure['name']] = current_help_obj_structure

	with open(os.path.join(core_dir, "helpdata.json"), "wt") as out:
		json.dump(helpObjs, out, sort_keys=True, indent=4, separators=(',', ': '))


def printHelp(ref):
	with open(os.path.join(core_dir, "helpdata.json"), "r") as inf:
		data = json.load(inf)

	if ref not in data:
		print(bcolors.FAIL + "Could not find any information for reference: " + ref + bcolors.ENDC)
		return

	obj = data[ref]
	print(bcolors.BOLD + obj['name'] + bcolors.ENDC + bcolors.OKBLUE + " (" + obj['type'] + ")" + bcolors.ENDC)
	if 'description' in obj and len(obj['description']) > 1:
		print("\t" + obj['description'].replace("\n", "\n\t"))
	else:
		print(bcolors.WARNING + "\t(No description available)" + bcolors.ENDC)
	if len(obj['args']) > 0:
		print("\t" + bcolors.BOLD + "Arguments:" + bcolors.ENDC)
		for arg in obj['args']:
			print("\t\t" + bcolors.WARNING + arg + ": " + bcolors.ENDC + obj['args'][arg])
	else:
		print(bcolors.WARNING + "\t(No usage information available)" + bcolors.ENDC)

if __name__ == '__main__':
	if len(sys.argv) < 2:
		print("Usage: <command>")
		sys.exit(1)
	else:
		if "generate" in sys.argv[1] or sys.argv[1] in ["build"]:
			rebuild()

		if sys.argv[1] in ["clean", "uninstall"]:
			os.remove(os.path.join(core_dir, "helpdata.json"))

		elif sys.argv[1] == "help":
			printHelp(sys.argv[2])
