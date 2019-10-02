#!/bin/python
# Don't forget to pip install pyserial
import serial
import time
import sys
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("mode", help="power/uart/uart-bridge")
parser.add_argument("--pwr", help="enable power output", action="store_true")
parser.add_argument("--debug", help="print activity under the hood", action="store_true")
parser.add_argument("--baud", help="set baud rate for UART mode", nargs=1, default=[115200])
args = parser.parse_args()

class BP:
    def __init__ (self, f = "/dev/bus_pirate", debug = False):
        self.debug = debug
        self.port = serial.Serial(port = f, baudrate = 115200, timeout = 0.1)
        self.resetBP()

    def _trace(self, msg):
        if self.debug:
            print("TRACE: %s" % msg)

    def resetBP(self):
        self.mode = "BB"
        self._trace('reset: start')
        for x in xrange(12): # Send >10 enter's to clear through any prompts
            self.port.write(bytearray(['\n']))
        self.port.read(256)
        self.port.write(bytearray([0x0F])) # Full reset
        self._trace('reset: clearing buffer')
        while self.port.read(32) != '':
            pass

        self.enterMode('BB')
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

    def enterMode(self, mode='BB'):
        self._trace("entering mode %s: start" % mode)
        if mode == 'BB':
            self.mode = 'BB'
            saw_bbio1 = False
            self._trace("entering mode %s: send mode reset" % mode)
            for x in xrange(20): # Send mode reset 20 times
                self.port.write(bytearray([0x00]))
                if self.port.read(5) == "BBIO1":
                    saw_bbio1 = True
                    break

            self._trace("entering mode %s: wait for mode ack" % mode)
            while not saw_bbio1 and self.port.read(5) != "BBIO1":
                self.port.write(bytearray([0x00]))
            time.sleep(0.2)
            while self.port.read(256) != '':
                pass

        elif mode == 'uart':
            if self.mode == "BB":
                self.port.read(64)
                self._trace("entering mode %s: send UART command" % mode)
                self.port.write(bytearray([0b00000011]))
                self._trace("entering mode %s: wait for mode ack" % mode)
                while self.port.read(5) != 'ART1':
                    pass
                self.mode = 'uart'
            else:
                raise Exception("Dont know how to switch to UART for mode: " + self.mode)

        else:
            raise Exception("Dont know how to switch to mode: " + mode)

    def set_uart_baud(self, baud=115200):
        if self.mode != "uart":
            raise Exception("Can't set UART baud in mode: " + self.mode)

        # PIC24F Family Ref. Manual, Sect. 21 UART specifies this formula:
        #   ((OSC_FREQ/2) / BAUD_RATE / 16) - 1
        baud_divider_val = 16000000 // (4 * baud) - 1
        self._trace("set UART baud: computed divider = %d" % baud_divider_val)
        self._trace("set UART baud: sending baud config command")
        self.port.write(bytearray([0b00000111]))
        self.port.write(bytearray([((baud_divider_val >> 8) & 0xFF)]))
        self.port.write(bytearray([(baud_divider_val & 0xFF)]))

        for x in xrange(3):
            self._trace("set UART baud: waiting for %d'th ack" % x)
            while True:
                d = self.port.read(1)
                if d and ord(d[0]) == 0x01:
                    break

    def uart_bridge(self):
        if self.mode != "uart":
            raise Exception("Can't set UART baud in mode: " + self.mode)
        self._trace("UART bridge: sending start command")
        self.port.write(bytearray([0b00001111]))
        self._trace("UART bridge: entering UART -> USB copy loop")
        while True:
            d = self.port.read(2)
            if d:
                sys.stdout.write(d)

bp = BP("/dev/buspirate", args.debug)
if args.mode == "power" or args.pwr:
    bp.regulatorMode(True)

if args.mode == "uart" or args.mode == "uart-bridge":
    bp.enterMode('uart')
    bp.set_uart_baud(int(args.baud[0]))
if args.mode == 'uart-bridge':
    bp.uart_bridge()
