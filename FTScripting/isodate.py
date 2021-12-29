#!/usr/bin/python3
# Created by David Tio
# FOSSTECH SOLUTIONS PTE LTD
# version 1.0
# 01 December 2021
# Requires python3 and python3-dateutil
#
# Usage: ./extract.py filename 
# Update the start and end date accordingly

import sys
import re
from datetime import datetime
from dateutil import parser
from time import time

# Format Year-Month-Date Hour:Min:Sec +Timezone Offset
start="2021-12-20 09:00:00 +08:00"
end="2021-12-20 11:00:00 +08:00"
output = "extract.txt"

progstart = time()
starttime = parser.parse(start)
endtime = parser.parse(end)
outline = []
lc = 1
wc = 1

if len(sys.argv) < 2:
  print("Please specify the filename")
else:
  filename = sys.argv[1]
  data = open(filename, "rb")
  p = re.compile(b'isodate="([^"]*)')
  for line in data:
    lc += 1
    
    isodate = p.search(line).group(1)
    
    if isodate:
      try: 
        timestamp = parser.parse(isodate)
      except Exception as err:
        print("Exception: {0}".format(err))
        print("Line: %s" % (line))
        print("Time field: %s" % (isodate))

      if timestamp > starttime and timestamp < endtime:
        outline.append(line)
        wc += 1

      if wc % 20000 == 0:
        outfile = open(output, "ab")
        for writeline in outline: 
          outfile.write(writeline)
        outfile.close()
        outline.clear()
        print('\033[1;32mWriting %s lines\033[1;0m' % (wc))
    
    if lc % 100000 == 0:
      print("Processing %s lines" % (lc) )

outfile = open(output, "ab")
for writeline in outline:
  outfile.write(writeline)
outfile.close()
outline.clear()

lc -= 1        
wc -= 1
print("Total lines processed: \033[1;32m%s\033[1;0m lines" % (lc))
print('Total lines written: \033[1;32m%s\033[1;0m lines' % (wc))
print("Time taken: \033[1;32m%s\033[1;0m seconds" % (time()-progstart))
