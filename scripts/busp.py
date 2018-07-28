#!/bin/python

import serial
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("mode", help="power/UART")
parser.add_argument("--pwr", help="enable power output", action="store_true")
args = parser.parse_args()

class BP:
    def __init__ (self, f = "/dev/bus_pirate"):
        self.port = serial.Serial(port = f, baudrate = 115200, timeout = 0.01)
        self.resetBP()

    def resetBP (self):
        self.port.write(bytearray([0x0F]))
        while self.port.read(5) != "BBIO1":
            self.port.write(bytearray([0x00]))
        self.mode = "BB"
        #self.port.write(bytearray([0x05]))
        #if self.port.read(4) != "RAW1":
        #    raise Exception("error initializing bus pirate")
        #self.port.write(bytearray([0x63,0x88])) # set speed to 400 kHz, enable output pins

    def regulatorMode(self, on):
        if self.mode == "BB":
            if on:
                self.port.write(bytearray([0b11000000]))
            else:
                self.port.write(bytearray([0b10000000]))
        elif self.mode == "RAW":
            if on:
                self.port.write(bytearray([0x48]))
            else:
                self.port.write(bytearray([0x40]))
        else:
            raise Exception("Dont know how to enable regulators for mode: " + self.mode)

bp = BP("/dev/buspirate")
if args.mode == "power" or args.pwr:
    bp.regulatorMode(True)
