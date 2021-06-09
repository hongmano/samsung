# -*- coding: utf-8 -*-
"""
Created on Thu May 13 15:50:25 2021

@author: mano.hong
"""

import ftplib
import tqdm
import sys
import gzip
import re
import os
import pandas as pd
from tqdm import tqdm

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
    data.to_csv(lot + '\\' + lot + '_' + str(test_n) + '.csv', index = False, header = False, sep = ',')
    header.to_csv(lot + '\\' + 'HEADER.csv', index = False, header = False, sep = ',')

pmapftp = ftplib.FTP("12.98.17.50")
pmapftp.login("pkgmap","pmap01")
pmapftp.cwd('/Pkgmap1/PkgBackUp/RawData/PKG_AZ/')
os.chdir('C:/Users/mano.hong/Desktop/AUTO/trend')

# Get LOT ###

folder_list = pmapftp.nlst()
lot_list = sys.argv
del(lot_list[0])


step = lot_list[-1]
del(lot_list[-1])

if not os.path.exists(step):
    os.makedirs(step)

os.chdir('C:/Users/mano.hong/Desktop/AUTO/trend/' + step)

for lot in tqdm(lot_list):
    if not os.path.exists(lot):
        
        os.makedirs(lot)
        pmapftp.cwd('/Pkgmap1/PkgBackUp/RawData/PKG_AZ/' + lot[0:3])
        file_list = pmapftp.nlst()
        mylot_data = []
        
        for data in file_list:
            	if lot in data:
                    mylot_data.append(data)
                    
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


os.chdir('C:/Users/mano.hong/Desktop/AUTO/trend/')
order = 'rscript trend.R ' + step

os.system(order)
