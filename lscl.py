# -*- coding: utf-8 -*-
"""
Created on Mon Apr 19 09:24:04 2021

@author: mano.hong
"""

import ftplib
import gzip
import sys
import pandas as pd
import re
import os

def save_data(file_list, test_n):
    
    # Get Data
    
    file_name = file_list[test_n]
    data = []
    pmapftp.retrbinary("RETR " + file_name, data.append)
    data = b''.join(data)
    
    # Unzip .gz File
    
    data = gzip.decompress(data)
    
    # Convert to ASCII Code
    
    data = data.decode('ascii')
    
    header = re.sub("\nLOADERSIDE[^\n]+\n","\n", data).split("[SUBBIN INFORMATION START")[0]   
    data = re.sub("\nLOADERSIDE[^\n]+\n","\n", data).split("[SAMSUNG PACKAGE MAP CODE START]")[-1]    
    
    data = data.split('\n')
    del data[-1]
    header = header.split('\n')
    
    # to CSV File
    
    data = pd.DataFrame(data)
    header = pd.DataFrame(header)
    data.to_csv(mylot + '\\' + mylot + '_' + str(test_n) + '.csv', index = False, header = False, sep = ',')
    header.to_csv(mylot + '\\' + 'header.csv', index = False, header = False, sep = ',')
    
# Select Lot

mylot = sys.argv[1]
location = str(int(sys.argv[2]) + 8)

os.chdir('C:\\Users\\mano.hong\\Desktop\\lscl')

if not os.path.exists(mylot):
        os.makedirs(mylot)

# Login to FTP Server

pmapftp = ftplib.FTP("12.98.17.50")
pmapftp.login("pkgmap","pmap01")
pmapftp.cwd('/Pkgmap1/PkgBackUp/RawData/PKG_AZ/' + mylot[0:3])

# Get File List

file_list = pmapftp.nlst()

# Find Mylot Data

mylot_data = []

for data in file_list:
    
    if mylot in data:
        mylot_data.append(data)
        

# Save Files        
    
if len(mylot_data) == 1:
    
    save_data(mylot_data, 0)
    
elif len(mylot_data) == 2:
    
    save_data(mylot_data, 0)
    save_data(mylot_data, 1)
    
elif len(mylot_data) == 3:
    
    save_data(mylot_data, 0)
    save_data(mylot_data, 1)
    save_data(mylot_data, 2)
    
elif len(mylot_data) == 4:
    
    save_data(mylot_data, 0)
    save_data(mylot_data, 1)
    save_data(mylot_data, 2)
    save_data(mylot_data, 3)

# Execute Rscript

order = 'rscript lscl.R ' + mylot + ' ' + location
os.system(order)
