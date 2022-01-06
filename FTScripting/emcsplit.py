#!/usr/bin/python3
# Created by David Tio
# FOSSTECH SOLUTIONS PTE LTD
# This script is searching for files in INDIR for those with certain timestamp (%Y%m%d%H%M" - 202112071644)
# If timestamp not specified - it will use the timestamp of 1 minute ago
# If the file is larger than CHUNK_SIZE, it will be split up to CHUNK_SIZE and the filename will be appended with 3 digit index. 
# filename.txt will be filename.part001.txt filename.part002.txt etc
# version 0.1
# 07/12/2021
# - Initial Version

import sys
import glob
import datetime
import os

INDIR="/root/data/"
CHUNK_SIZE = 149*1024*1024
OUTDIR = "/root/data/done/"

if len(sys.argv) > 1:
  tstr = sys.argv[1]
else:
  now = datetime.datetime.now()
  minago = now + datetime.timedelta(minutes=-1)
  tstr = minago.strftime("%Y%m%d%H%M")

filelist = glob.glob("%s*%s.txt" % (INDIR, tstr))

for filepath in filelist:
  large = False
  print("Processing: \033[1;32m%s\033[1;0m" % filepath)
  if os.stat(filepath).st_size > CHUNK_SIZE:
      large = True
      
  sfilename = os.path.basename(filepath)
  os.rename(filepath, "%s%s" % (OUTDIR, sfilename))
  filename=sfilename.split('.txt')[0]
  if large:
    part = 1
    with open("%s%s" % (OUTDIR, sfilename), 'rb') as largefile:
      while True:
        chunk = largefile.readlines(CHUNK_SIZE)
        if not chunk:
          break
        outfile = open("%s%s.%s.txt" % (OUTDIR, filename, str(part).zfill(3)), 'wb')
        outfile.writelines(chunk)
        outfile.close()
        part += 1
    largefile.close()
    os.remove("%s%s" % (OUTDIR, sfilename))
