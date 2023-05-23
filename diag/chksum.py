#!/usr/bin/env python3

import sys

if len(sys.argv) != 2:
    print("Bad usage.")
    sys.exit(0)
with open(sys.argv[1], "rb+") as f:
    data = list(f.read())
    l = len(data)
    #print("File lentgh = {}".format(l))
    data = data[-(0x10000 - 0xFA00):]
    old_corr = data[-7]
    for corr in range(0x100):
        data[-7] = corr
        chk = 0
        carry = 0
        for r in range(0x100):
            for a in range(6):
                a = a * 0x100 + r
                chk += int(data[a]) + carry
                if chk > 0xFF:
                    chk &= 0xFF
                    carry = 1
                else:
                    carry = 0
        if chk == 0:
            print("Correction byte should be: {}".format(corr))
            if corr == old_corr:
                print("Already OK!")
            else:
                f.seek(l - 7)
                f.write(bytearray([corr]))
            break



