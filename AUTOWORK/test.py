# -*- coding: utf-8 -*-
"""
Created on Tue Jun 15 17:11:43 2021

@author: mano.hong
"""

import ftplib
import gzip
import os
import pandas as pd
from tqdm import tqdm

lscl = input('이상처리?(y/n) :   ')

lot_list = input('Lot List(sep = ' ') :   ')
lot_list = lot_list.split(' ')
auto = input('AUTO향?(y/n) : ')

folder = input('폴더명 :   ')


def save_data(file_list):
    
    # Get Data
    
    for file_name in file_list:
        
        data = []
        pmapftp.retrbinary("RETR " + file_name, data.append)
        data = b''.join(data)
        
        # Unzip .gz File
        
        data = gzip.decompress(data)
        
        # Convert to ASCII Code
        
        data = data.decode('unicode_escape') 
        data = data.split('\n')
        
        # to CSV File
        
        data = pd.DataFrame(data)
        data.to_csv(file_name + '.csv', index = False, header = False, sep = ',')


pmapftp = ftplib.FTP("12.98.17.50")
pmapftp.login("pkgmap","pmap01")

if auto == 'y':
	pmapftp.cwd('/Solution/Automotive/PKG_Raw/2021')
else:
	pmapftp.cwd('/Pkgmap1/PkgBackUp/RawData/PKG_AZ/')

os.chdir('your path')

# Get LOT ###

if not os.path.exists(folder):
    os.makedirs(folder)

os.chdir('your path' + folder)

for lot in tqdm(lot_list):

        if auto == 'y':
            pmapftp.cwd('/Solution/Automotive/PKG_Raw/2021/' + lot[0:3])
        else:
            pmapftp.cwd('/Pkgmap1/PkgBackUp/RawData/PKG_AZ/' + lot[0:3])

        file_list = pmapftp.nlst()
        mylot_data = []
        
        for data in file_list:
        
            	if lot + '_' in data:

                    mylot_data.append(data)
                    
                    for i in range(1, len(mylot_data)):
                        
                        if int(mylot_data[i][-8]) > int(mylot_data[i-1][-8]):
                            pass
                        
                        else:
                            del(mylot_data[0:i])
                            break
                    
        if lscl == 'n':
            
            save_data(mylot_data)

        else:
            
            os.chdir('your path' + folder)
            
            if not os.path.exists(lot):
                os.makedirs(lot)
                
            os.chdir('your path' + folder + '/' + lot)
            save_data(mylot_data)
                        

os.chdir('your path')
order = 'rscript autowork.R ' + lscl + ' ' + folder

os.system(order)
