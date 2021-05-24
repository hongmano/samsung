# -*- coding: utf-8 -*-
"""
Created on Thu May 13 15:50:25 2021

@author: mano.hong
"""

import ftplib
import sys
import gzip
import re
import os
import pandas as pd
from tqdm import tqdm

pmapftp = ftplib.FTP("12.98.17.50")
pmapftp.login("pkgmap","pmap01")
pmapftp.cwd('/Pkgmap1/PkgBackUp/RawData/PKG_AZ/')
os.chdir('C:/Users/mano.hong/Desktop/trend')

# Get LOT ###

folder_list = pmapftp.nlst()
ver = sys.argv[1]
step_name = sys.argv[2]

      
if ver == 'NU':
    
    PART = ['K4F8E3D4HF', 'K4F4E3S4HF', 'K4F4E6S4HF']
    LOT = ['EU', 'ML', 'QQ', 'UL', 'RT']
    
elif ver == 'LC':
    
    PART = ['K4EBE304ED', 'K4E8E324ED']
    LOT = ['HC', 'JI', 'ML', 'QQ', 'UL', 'RT']
    
elif ver == 'KR':
    
    PART = 'K4UBE3S4AM'
    LOT = ['PQ', 'ML', 'QQ', 'UL', 'RT']
    
elif ver == 'KL':
    
    PART = ['K3LK2K20BM', 'K3LK4K40BM']
    LOT = ['GG', 'ML', 'QQ', 'UL', 'RT']
    
else:
    print('########## MOB4 TL1 제품이 아닙니다. ###########')
 
    
if not os.path.exists(ver + '_' + step_name):
    os.makedirs(ver + '_' + step_name)
        
os.chdir('C:/Users/mano.hong/Desktop/trend/' + ver + '_' + step_name)

# Get File List

mydata = []
myfolder = []
file_list = []
folder_list = pmapftp.nlst()

# Get ### Ver & HFT Folders
    
for folder in folder_list:
     
    for lot in LOT:
        
        if lot in folder[:2] and len(folder) == 3:
            
            myfolder.append(folder)
                
# Get ### Ver & HFT Files

print('######### LOT LIST 불러오는 중 #########')

for folder in tqdm(myfolder):
    
    try:
        file_list = pmapftp.nlst('/Pkgmap1/PkgBackUp/RawData/PKG_AZ/' + folder)
    except:
        pass
    
    for data in file_list:
        for PART_ID in PART:
                
            if PART_ID in data and step_name in data:
                mydata.append(data)

print('######### File 다운로드 받는 중 #########')

for file_name in tqdm(mydata):
    
    # to ASCII file
    
    real_data = []
    
    pmapftp.retrbinary("RETR " + file_name, real_data.append)
    real_data = b''.join(real_data)
    
    real_data = gzip.decompress(real_data)
    real_data = real_data.decode('ascii')
    header = re.sub("\nLOADERSIDE[^\n]+\n","\n", real_data).split("[SUBBIN INFORMATION START")[0]   
    real_data = re.sub("\nLOADERSIDE[^\n]+\n","\n", real_data).split("[SAMSUNG PACKAGE MAP CODE START]")[-1]    
    
    real_data = real_data.split('\n')
    del real_data[-1]
    header = header.split('\n')

    # Informations

    lot_name = file_name.split('/')[-1].split('_')[2]
    step = file_name.split('/')[-1].split('_')[1]
    eqp = file_name.split('/')[-1].split('_')[3]

    # Wrangling
    
    real_data = pd.DataFrame(real_data)
    header = pd.DataFrame(header)
    
    real_data[0] = real_data[0].str.strip()
    real_data[0] = real_data[0].str.replace(pat = 'DO=|FU=|HB=|CB=|NB=|DU=|SG=|HTEMP=|MV=|DCT',
                                            repl = r'',
                                            regex = True)
    real_data[0] = real_data[0].str.replace(pat = '\\s+:', repl = ':', regex = True)
    real_data[0] = real_data[0].str.replace(pat = ':\\s+', repl = ':', regex = True)
    real_data[0] = real_data[0].str.replace(pat = '\\s+', repl = ' ', regex = True)

    # to CSV File
        
    if not os.path.exists(lot_name):
        os.makedirs(lot_name)
        
    real_data.to_csv(lot_name + '\\' + lot_name + '_' + str(file_name.split('/')[-1].split('_')[4][:2]) + '.csv', index = False, header = False, sep = ',')
    header.to_csv(lot_name + '\\' + lot_name + '_header.csv', index = False, header = False, sep = ',')
    

