# -*- coding: utf-8 -*-
"""
Created on Tue Jun 15 17:11:43 2021

@author: mano.hong
"""

import ftplib
import sys
import gzip
import re
import os
import pandas as pd
from tqdm import tqdm

lscl = input('이상처리?(y/n) :   ')
lot_list = input('Lot List(sep = ' ') :   ')
lot_list = lot_list.split(' ')
tPD_location = input('tPD 위치 MSR(?) :   ')
folder = input('폴더명 :   ')

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
    data.to_csv(lot + '_' + str(test_n) + '.csv', index = False, header = False, sep = ',')
    header.to_csv(lot + '_HEADER.csv', index = False, header = False, sep = ',')

pmapftp = ftplib.FTP("12.98.17.50")
pmapftp.login("pkgmap","pmap01")
pmapftp.cwd('/Pkgmap1/PkgBackUp/RawData/PKG_AZ/')
os.chdir('C:/Users/mano.hong/Desktop/AUTOWORK')

# Get LOT ###

if not os.path.exists(folder):
    os.makedirs(folder)

os.chdir('C:/Users/mano.hong/Desktop/AUTOWORK/' + folder)

lot_list = list(lot_list)

for lot in tqdm(lot_list):

        pmapftp.cwd('/Pkgmap1/PkgBackUp/RawData/PKG_AZ/' + lot[0:3])
        file_list = pmapftp.nlst()
        mylot_data = []
        
        for data in file_list:
            	if lot in data:

                    mylot_data.append(data)
                    
                    if len(mylot_data) == 1:
    
                        save_data(mylot_data, 0)
                        
                    else:

                        save_data(mylot_data, 0)
                        save_data(mylot_data, 1)


os.chdir('C:/Users/mano.hong/Desktop/AUTOWORK')
order = 'rscript autowork.R ' + lscl + ' ' + folder + ' ' + tPD_location

os.system(order)
