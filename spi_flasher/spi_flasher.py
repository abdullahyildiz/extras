#!/usr/bin/python

# example script to flash SPI memory on Raspberry Pi

WREN = 6
WRDI = 4
RDSR = 5
RDSR2 = 0x35
WRSR = 1
READ = 3
WRITE = 2
SECTOR_ERASE = 0xD8
CHIP_ERASE = 0xC7

import sys, struct, os, collections

from array import array
import random

from time import sleep
import spidev
from datetime import datetime

def sleep_ms(msecs):
    sleep(float(msecs) / 1000.0)

class spiflash(object):

    def __init__(self, bus, cs, mode = 0, max_speed_hz = 1000):
        self.spi = spidev.SpiDev()
        self.spi.open(bus,cs)       
        self.spi.max_speed_hz = max_speed_hz
        self.spi.mode = mode

    def __del__(self):
        try:
            self.spi.close()
        except:
            pass

    #reads ----------------------------------------------------------------------------------
    def read_id(self):
         #device_id = self.spi.xfer2([0x9E,0x9F])[1]
         device_id = self.spi.xfer2([0x9E,0x9F,0])[1:]
         
         return device_id
         
    def read_status(self):
        statreg = self.spi.xfer2([RDSR,RDSR])[1]
        #statreg2 = self.spi.xfer2([RDSR2,RDSR2])[1]
        return statreg

    def read_page(self, byte_3, byte_2, byte_1):
        xfer = [READ, byte_3, byte_2, byte_1] + [255 for _ in range(256)] # command + 256 dummies
        return self.spi.xfer2(xfer)[4:] #skip 4 first bytes (dummies)

    #writes ----------------------------------------------------------------------------------
    def write_enable(self):
        self.spi.xfer2([WREN])
        sleep_ms(5)

    def write_disable(self):
        self.spi.xfer2([WRDI])
        sleep_ms(5)

    def write_status(self,s1,s2):
        self.write_enable()

        spi.xfer2([WRSR,s1,s2])
        sleep_ms(10)

        self.wait_until_not_busy()

    def write_page(self, byte_3, byte_2, byte_1, page):
        self.write_enable()

        #print self.read_status()

        xfer = [WRITE, byte_3, byte_2, byte_1] + page[:256]
        self.spi.xfer2(xfer)
        sleep_ms(10)

        self.wait_until_not_busy()

    def write_and_verify_page(self, byte_3, byte_2, byte_1, page):
        self.write_page(byte_3, byte_2, byte_1, page)
        return self.read_page(byte_3, byte_2, byte_1)[:256] == page[:256]

    #erases ----------------------------------------------------------------------------------
    def erase_sector(self,addr1, addr2):
        self.write_enable()

        xfer = [SECTOR_ERASE, 0, addr2, addr1]
        self.spi.xfer2(xfer)
        sleep_ms(10)

        self.wait_until_not_busy()

    def erase_all(self):
        self.write_enable()

        self.spi.xfer2([CHIP_ERASE])
        sleep_ms(10)

        self.wait_until_not_busy()

    #misc ----------------------------------------------------------------------------------
    def wait_until_not_busy(self):
        statreg = 0x1;
        while (statreg & 0x1) == 0x1:
            #Wait for the chip.
            statreg = self.spi.xfer2([RDSR,RDSR])[1]
            #print "%r \tRead %X" % (datetime.now(), statreg)
            sleep_ms(5)

    #helpers -------------------------------------------------------------------------------
    def print_status(self,status):
        print "status %s %s" % (bin(status[1])[2:].zfill(8), bin(status[0])[2:].zfill(8))   

    def print_page(self, page):
        s = ""
        for row in range(16):
            for col in range(16):
                s += "%02X " % page[row * 16 + col]
            s += "\n"
        print s 


#TESTS -------------------------------------------------------------------
#TESTS -------------------------------------------------------------------

chip = spiflash(bus = 0, cs = 0)

DEBUG = 1

"""
p = chip.read_page(5,0)

print "erasing chip"
chip.erase_all()
print "chip erased"

for i in range(256):
    if i == 0:
        p[i] = 0xaa # random.randint(0,255)
    else:
        p[i] = 0

# print hex(p[0])

chip.write_page(0,0,p)
p = chip.read_page(0,0)
chip.print_page(p)

p[0] += 1
# chip.erase_sector(0,0)
chip.write_page(0,2,p)
p = chip.read_page(0,2)

chip.print_page(p)

p = chip.read_page(0,0)
chip.print_page(p)

sys.exit(0)
"""


#chip.erase_sector(5,0)

#chip.write_and_verify_page(5,0,p)
#print chip.read_id()

#q = chip.read_page(5,0)
#chip.print_page(q)

print "erasing chip"
chip.erase_all()
print "chip erased"

#chip.print_page(p)
#sys.exit(0)

#print chip.write_and_verify_page(0,0,p)

program = []
page_number = 0
byte_number = 0

program_data = array('B')

file_size = os.path.getsize('icebreaker_fw.bin')

#print file_size
with open('icebreaker_fw.bin', 'rb') as f:
    program_data.fromfile(f, file_size)

# pad the last page with zero
if (file_size % 256) != 0:
    for i in range(file_size,(file_size + (256 - (file_size % 256)))):
        program_data.append(0)

temp_file_size = file_size
                              
while temp_file_size >= 0:

    page_data = program_data[page_number*256:page_number*256+256].tolist()
    
    if DEBUG == 1:
        print "Page content:"
        chip.print_page(page_data)

    print "Writing to page ", page_number
    chip.write_and_verify_page(0x10,page_number,0,page_data)

    print "Reading page ", page_number, " back"
    page_readback_data = chip.read_page(0x10,page_number,0)

    if DEBUG == 1:
        print "Actual page content: PAGE[", page_number, "]" 
        chip.print_page(page_readback_data)

    page_data.sort()
    page_readback_data.sort()
    if page_data != page_readback_data:
        print "MISMATCH between actual and expected content for page ", page_number
        sys.exit(0)

    #if page_number == 0:
    #    sys.exit(0)
        
    # CAUTION: second byte of page address is set to zero. i.e., page_number never exceeds 255
    page_number += 1
    temp_file_size -= 256

print "Successfully write the data to Flash memory."
