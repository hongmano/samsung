import os
import sys
import pandas as pd
#import numpy as np
import datetime
import io
import openpyxl
import matplotlib.pyplot as plt
import binascii
import math

rev=1.1
# lp5_patt = pd.read_csv('ACM_dutviewer_log.txt',sep="\s+")
# lp5_patt = pd.read_csv('ADC_dutviewer_log.txt',sep="\s+")
# lp5_patt = pd.read_csv('GPT_dutviewer_log.txt',sep="\s+")

# file_name='PDCS4FADC7N5ANN_epic.txt'
# file_name='PDCS4FACM7N5ANN_epic.txt'
# file_name='PDCS4FIPM7N5ANN_epic.txt'
# file_name='PDCS4FIPM7N5ANN_t5511.txt'
# patnlist=['PDCS4FADC7N5ANN_epic','PDCS4FADC7N5ANN_t5511']

patt_name='PDCS4FADC7N5A'

# patnlist=['PDCS4FNIF7N5A']
# patnlist=['PDCS4FAWR7N5A','PDCS4FIYF7N5A']
patnlist=[#"PDCS4FAPO7N5A",
# "PDCS4FPBR6N4M",
# "PDCS4FI4R7N5A","PDCS4FI4R7N5B","PDCS4FI8R7N5A","PDCS4FI8R7N5B",
# "PDCS4FIYF7N5A","PDCS4FIYF7N5B",
# "PDCS4FROB7N5A",
# "PDCS4FCOB7N5A",
# "PDCS4FCOB7N5N","PDCS4FWFS7N5A",
# "PDCS4FWFS7N5B",
# "PDCS4FWST7N5A",
# "PDCS4FRST7N5A","PDCS4FRMW7N5A","PDCS4FRMW7N5B","PDCS4FRMW7D5N", "PDCS4FRMW7N5N",
# "PDCS4FSEL7N5A","PDCS4FSEL7N5B","PDCS4FSEL7N5C",
# "PDCS4FDSM7N5A","PDCS4FDSM7N5B",
# "PDCS4FRRD7N5A","PDCS4FRRD7N5B",
# "PDCS4FIOM7N5A",
# "PDCS4FNIF7N5A","PDCS4FI2F7N5A",
# "PDCS4FWRX7N5A","PDCS4FWRX7N5B",
# "PDCS4FWRX7N5C",
# "PDCS4FWDI7N5A","PDCS4FWDI7N5B",
# "PDCS4FWDI7N5C","PDCS4FWDI7N5N","PDCS4FWDI7N5M","PDCS4FLDM7N5A",
# "PDCS4FWDM7N5A","PDCS4FDWN7N5N","PDCS4FDM67N5A","PDCS4FNV27N5A",
# "PDCS4FNV37N5A","PDCS4FNV37N5B",
# "PDCS4FNV47N5A",
# "PDCS4FNV57N5A",
# "PDCS4FWFR7N5A",
# "PDCS4FWFR7N5B",
# "PDCS4FFCW7N5A",
# "PDCS4FFCR7N5A",
# "PDCS4FOTF7N5A",
# "PDCS4FOTF7N5B",
# "PDCS4FBLR7N5A",
# "PDCS4FAAD7N5A",
# "PDCS4FOCG7N5O","PDCS4FOCG7N5A","PDCS4FOCG7N5N",
# "PDCS4FPDN7N5A",
# "PDCS4FPDN7N5B",
# "PDCS4FPDN7D5A",
# "PDCS4FACM7N5A",
# "PDCS4FACM7N5B",
# "PDCS4FADC7N5A","PDCS4FADC7N5N","PDCS4FADC7D5A","PDCS4FADC7D5B",
# "PDCS4FADC7D5C",
# "PDCS4FDBI7N5A",
# "PDCS4FD2I7N5A",
# "PDCS4FDB27N5A",
# "PDCS4FDBG7N5A",
# "PDCS4FDBG7N5B",
# "PDCS4FGPB7N5A","PDCS4FPP47N5A",
# "PDCS4FPR27N5A",
# "PDCS4FPR37N5A",
# "PDCS4FPR37N5N",
# "PDCS4FAPO7N5A",
# "PDCS4FAWR7N5A",
# "PDCS4FIAP7N5A","PDCS4FAPI7N5A","PDCS4FCCD7N5A",
# "PDCS4FGPT7N5A","PDCS4FCIP7N5A",
# "PDCS4FYMA7N5A",
# "PDCS4FYCG7N5A",

# "PDCS4FCYF7N5A","PDCS4FGLY7N5A",
# "PDCS4FDYG7N5A",
# "PDCS4FCJP7N5A","PDCS4FCJP7N5N",
# "PDCS4FIPM7N5A","PDCS4FIPM7N5N","PDCS4FIPM7N5C","PDCS4FIPM7N5M",
# "PDCS4FPBR7N5A", 
# "PDCS4FPBR7N5N",
#  "PDCS4FPBR7N5C","PDCS4FPBR7N5O",
#  "PDCS4FPBR7N5B","PDCS4FPBR7N5M",
# "PDCS4FPGK7N5A",
 "PDCS4FPGK7D5A",
# "PDCS4FPGK7N5N",
# "PDCS4FPGK7N5M"
# "PDCS4FPBR7D5A","PDCS4FPBR7D5B","PDCS4FPBR7D5C",
# "PDCS4FPBR7D5N","PDCS4FPBR7D5M","PDCS4FPBR7D5O",
# "PDCS4FIPM7D5A","PDCS4FIPM7D5B","PDCS4FIPM7D5C",
# "PDCS4FIPM7D5D","PDCS4FIPM7D5E","PDCS4FIPM7D5F","PDCS4FIPM7D5N",
# "PDCS4FIPM7D5M","PDCS4FIPM7D5O","PDCS4FIPM7D5P","PDCS4FIPM7D5Q",
# "PDCS4FIPM7D5R",
# "PDCS4F4YF7N5A",
# "PDCS4FIRN7N5A",
# "PDCS4FRCD7N5A",
# "PDCS4FGIO7N5A",
# "PDCS4FMAT7N5A",
# "PDCS4FPCP7N5A",
# "PDCS4FRPD7N5A",


# "PDCS4FECM7N5A",
# "PDCS4FPRF7N5A",
# "PDCS4FLEC7N5X","PDCS4FLEC7N5Y",
# "PDCS4FNWR7N5A","PDCS4FLFF7N5A",
# "PDCS4FHRG7N5A","PDCS4FPDS7D5A",
# "PDCS4FFFR7N5A","PDCS4FFFR7N5B",
# "PDCS4FCOB7D5A",
# "PDCS4FAGP7N5A",
# "PDCS4FAPD7N5A","PDCS4FAPD7N5B",
# "PDCS4FAPD7N5C","PDCS4FAPD7N5D",
# "PDCS4FAPD7N5E","PDCS4FAPD7N5F",
# "PDCS4FAPD7N5P","PDCS4FAPD7N5Q",
# "PDCS4FAPD7N5R","PDCS4FAPD7N5S",
# "PDCS4FAPD7N5T",
# "PDCS4FDCF7N5E",
# "PDCS4FDCF7N5F",
# "PDCS4FLEC7N5A","PDCS4FLEC7N5B",
# "PDCS4FD3P7N5A",
# "PDCS4FWKO7N5E",
# "PDCS4FWKO7N5F",
# "PDCS4FART7N5A","PDCS4FART7N5B",
# "PDCS4FCWS7N5A","PDCS4FCWS7N5B",
# "PDCS4FPBR7N5X",
# "PDCS6ROTF3N2A",
# "PDCS6FOCG1N6A",
# "PDCS6FOCG1N6N",
# "PDCS4FDQA6N4Z",
#  "PDCS4FPGK7N5X",
#  "PDCS4FGLY6N4A",
#  "PDCS4FPGK7D5B",
#  "PDCS4FPGK7D5C",
#  "PDCS4FPGK7D5D",
#  "PDCS4FPGK7N5O",
#  "PDCS4FPGK7N5P",
#  "PDCS4FPGK7D5O",
#  "PDCS4FPGK7D5P",
#  "PDCS4FADC8N5AEE",
#  "PDCS4FADC8N5AEO",
#  "PDCS4FGPB8N5AEE",
#  "PDCS4FGPB8N5AEO",
#  "PDCS4FPR38N5AEE",
#  "PDCS4FPR38N5AEO",

#  "PDCS4FIYF8N5AEE",
#  "PDCS4FIYF8N5AEO",
#  "PDCS4FPP48N5AEE",
#  "PDCS4FPP48N5AEO",

#  "PDCS4FOCG8N5AEE",
#  "PDCS4FOCG8N5AEO",
#  "PDCS4FOTF8N5AEE",
#  "PDCS4FOTF8N5AEO",

#  "PDCS4FPBR8N5AEE",
#  "PDCS4FPBR8N5AEO",

#  "PDCS4FBLR8N5AEE",
#  "PDCS4FIPM8N5AEE",
#  "PDCS4FIPM8N5NEE",
#  "PDCS4FIPM8N5CEE",
#  "PDCS4FIPM8N5MEE",

#  "PDCS4FACM8N5AEE",
#  "PDCS4FACM8N5AEO",
#  "PDCS4FACM8N5BEE",
#  "PDCS4FACM8N5BEO",

#  "PDCS4FPBR8N5NEE",
#  "PDCS4FPBR8N5CEE",
#  "PDCS4FPBR8N5OEE",
#  "PDCS4FPBR8N5BEE",
#  "PDCS4FPBR8N5MEE",

#  "PDCS4FPBR8N5NEO",
#  "PDCS4FPBR8N5BEO",
#  "PDCS4FPBR8N5MEO",


#   "PDCS4FPGK8N5AEE",
#   "PDCS4FPGK8N5MEE",
#   "PDCS4FPGK8N5NEE",
#   "PDCS4FD2I8N5AEE",

#    "PDCS4FDBI8N5AEE",
#    "PDCS4FDBI8N5AEO",

#    "PDCS4FD2I8N5AEO",
#    "PDCS4FD2I8N5AEE",
#    "PDCS4FDBG8N5AEE",
#    "PDCS4FDBG8N5BEE",
#    "PDCS4FPR28N5AEE",

#    "PDCS4FPR38N5NEE",
#    "PDCS4FAPO8N5AEE",
#    "PDCS4FAWR8N5AEE",
#    "PDCS4FAPI8N5AEE",
#    "PDCS4FCCD8N5AEE",

    # "PDCS4FGPT8N5AEE",
    # "PDCS4FCIP8N5AEE",
    # "PDCS4FYMA8N5AEE",
    # "PDCS4FYCG8N5AEE",
    # "PDCS4FGLY8N5AEE",
    # "PDCS4FCJP8N5AEE",
    # "PDCS4FCJP8N5NEE",

    # "PDCS4F4YF8N5AEE",
    # "PDCS4FIRN8N5AEE",
    # "PDCS4FRCD8N5AEE",
    # "PDCS4FGIO8N5AEE",
    # "PDCS4FMAT8N5AEE",
    # "PDCS4FPCP8N5AEE",
    # "PDCS4FRPD8N5AEE",
    # "PDCS4FECM8N5AEE",
    # "PDCS4FPRF8N5AEE",
    # "PDCS4FNWR8N5AEE",
    # "PDCS4FLFF8N5AEE",
    # "PDCS4FHRG8N5AEE",
    # "PDCS4FOCG8N5NEE",

    # "PDCS4FOTF8N5BEE",
    # "PDCS4FOCG8N5OEE",
    # "PDCS4FADC8N5NEE",
    # "PDCS4FADC8D5AEE",
    # "PDCS4FADC8D5BEE",
    # "PDCS4FADC8D5CEE",
    # "PDCS4FPDS8D5AEE",
    # "PDCS4FPDN8N5BEE",
    # "PDCS4FPDN8D5AEE",

    # "PDCS4FPDN8N5BEO",

     "PDCS4FPGK8D5AEE",
    # "PDCS4FPBR8D5AEE",
    # "PDCS4FPBR8D5BEE",
    # "PDCS4FPBR8D5CEE",
    # "PDCS4FPBR8D5NEE",
    # "PDCS4FPBR8D5MEE",
    # "PDCS4FPBR8D5OEE",
    # "PDCS4FIPM8D5AEE",
    # "PDCS4FIPM8D5BEE",
    # "PDCS4FIPM8D5DEE",

    # "PDCS4FI4R8N5BEE",
    # "PDCS4FI8R8N5BEE",
    # "PDCS4FIYF8N5BEE",
    # "PDCS4FWFS8N5BEE",
    # "PDCS4FRMW8N5BEE",
    # "PDCS4FRMW8N5NEE",
    # "PDCS4FRRD8N5BEE",
    # "PDCS4FWDI8N5BEE",
    # "PDCS4FWDI8N5CEE",
    # "PDCS4FWDI8N5NEE",
    # "PDCS4FWDI8N5MEE",

    # "PDCS4FIPM8D5CEE",
    # "PDCS4FIPM8D5DEE",
    # "PDCS4FIPM8D5EEE",
    # "PDCS4FIPM8D5FEE",
    # "PDCS4FIPM8D5MEE",
    # "PDCS4FIPM8D5NEE",
    # "PDCS4FIPM8D5OEE",
    # "PDCS4FIPM8D5PEE",
    # "PDCS4FIPM8D5QEE",
    # "PDCS4FIPM8D5REE",

    # "PDCS4FIOM8N5AEE",
    # "PDCS4FNIF8N5AEE",
    # "PDCS4FI2F8N5AEE",
    # "PDCS4FNV38N5AEE",
    # "PDCS4FNV38N5BEE",
    # "PDCS4FIAP8N5AEE",

    # "PDCS4FCIP8N5AEE",
    # "PDCS4FPDN8N5BEE",

    # "PDCS4FI8R8N5BEE",

    # "PDCS4FPGK8N5OEE",
    # "PDCS4FPGK8N5PEE",
   "PDCS4FPGK8D5OEE",
    # "PDCS4FPGK8D5PEE",
    # "PDCS4FDB28N5AEE",

    # "PDCS4FFCR8N5AEE",
    # "PDCS4FAAD8N5AEE",
    
    # "PDCS4FWFR8N5BEE",
    # "PDCS4FNV58N5AEE",
    # "PDCS4FWRX8N5CEE",
    # "PDCS4FWRX8N5BEE",

    # "PDCS4FCYF8N5AEE",
    # "PDCS4FSEL8N5BEE",
    # "PDCS4FDSM8N5BEE",
    # "PDCS4FCOB8N5NEE",

#  "PDCS4FPGO7D53",
#  "PDCS4FPGO7D54",
#  "PDCS4FPGO7D55",
#  "PDCS4FPGO7D59",

#  "PDCS4FPGP7D51",
#  "PDCS4FPGP7D53",
#  "PDCS4FPGP7D54",
#  "PDCS4FPGP7D55",

    # "PDCS4FNV28N5AEE",

    #  "PDCS4FDBT7D5N",
    # "PDCS4FDBT7D5P",
]


ckr=4
# patnlist=['PDCS4FIYF7N5ANN_t5511','PDCS4FIYF7N5ANN_epic']
# patnlist=['PDCS4FADC7N5DNN_epic']
# patnlist=['PDCS4FCOB7N5ANN_t5511','PDCS4FCOB7N5ANN_epic']
# patnlist=['PDCS4FPBR6N4MNN_epic','PDCS4FPBR6N4MNN_t5511']

hsdi_otf=['00000000','10101010','01100110','11001100','01010101','11111111','00110011','10011001']
hsdmi_otf=['00000000','10101010','01100110','11001100','01010101','11111111','00110011','10011001']

for ipat in range(len(patnlist)):
    ckr=4
    if patnlist[ipat].find("PDCS6R")>-1: ckr=2
    valid_bl_line=8
    dbimode=patnlist[ipat][10]
    hsc_mode=patnlist[ipat][13:15]
    print("COMPARE : %s"%(patnlist[ipat]),end=" ")
    for ipat_equip in range(2):
        # print("========================================")
        # print("=====   PARSING          ===============")
        # print("========================================",end=" : ")
        if ipat_equip==0:
            if (len(patnlist[ipat]))==13 : file_name=patnlist[ipat]+'NN_t5511.txt'
            else: file_name=patnlist[ipat]+'_t5511.txt'
        if ipat_equip==1:
            if (len(patnlist[ipat]))==13 : file_name=patnlist[ipat]+'NN_epic.txt'
            else: file_name=patnlist[ipat]+'_epic.txt'
        # print(file_name)

        tester_name=file_name.split('_')[1].split('.')[0]
        outfile_name=file_name.split('.')[0]+'_parsing.txt'

        lp5_patt0 = pd.read_csv(file_name,sep="\s+")

        # lp5_patt0 = pd.read_csv('PDCS4FIYF7N5ANN_t5511.txt',sep='\s+')#delim_whitespace=True)#,sep=t+") # "/s+"

        # print(lp5_patt0)
        # lp5_patt = pd.read_csv('_D0F_dutviewer_log.txt',sep="\s+")
        startingpoint=0
        startingpoint=lp5_patt0[lp5_patt0['LABEL']=='HSCEND'].reset_index()['PC'][0]
        # print(lp5_patt[lp5_patt['LABEL']=='HSCEND'].reset_index()['PC'][0])

        lp5_patt=lp5_patt0[lp5_patt0['PC']>startingpoint].reset_index().drop(['index'],axis='columns')
        # print(lp5_patt)

        lp5_patt_header=list(lp5_patt)
        # print(lp5_patt_header)   #
        lp5_patt.columns=['IDX', 'LABEL', 'PC', 'UI', 'CLKT', 'CS0', 'CS1', 'CA', 'WCKT', 'RDQST', 'DMI0', 'DMI1', 'DATA_e', 'DATA_o']

        # for iCnt in range(len(lp5_patt_header)):
        #     if lp5_patt_header[iCnt][0:2]=='CA':
        #         lp5_patt_header[iCnt]=lp5_patt_header[iCnt][0:3]+'A'
        # lp5_patt.columns=lp5_patt_header

        RL_=20
        WL_=11
        if dbimode=='D': RL=22

        if patnlist[ipat].find('8N5')>-1 or patnlist[ipat].find('8D5')>-1:
            RL_=23
            WL_=12
            if dbimode=='D': RL=25
            lp5_speed=8533
            lp5_ckr_=2
            valid_bl_line=4

        if patnlist[ipat].find('7N5')>-1 or patnlist[ipat].find('7D5')>-1:
            RL_=20
            WL_=11
            if dbimode=='D': RL=22
            lp5_speed=7500
            lp5_ckr_=4

        
        if patnlist[ipat].find('6N4')>-1 or patnlist[ipat].find('6D4')>-1:
            if patnlist[ipat][5]=='F':
                RL_=0
                WL_=0
                print('WH 6K4')
        if patnlist[ipat].find('3N2')>-1 or patnlist[ipat].find('3D2')>-1:
            if patnlist[ipat][5]=='F' or patnlist[ipat][5]=='R':
                RL_=0
                WL_=0
                print('WH 3K2',ckr)
        if patnlist[ipat].find('1N6')>-1 or patnlist[ipat].find('1D6')>-1:
            if patnlist[ipat][5]=='F' or patnlist[ipat][5]=='R':
                RL_=0
                WL_=0
                print('WH 1K6',ckr)
        
        ckr=lp5_ckr_
        # pd.set_option('display.max_rows', 500) 

        # CA06n=['']*len(lp5_patt['UI'])
        CLKn=[0]*len(lp5_patt['UI'])
        CMDn=['-']*len(lp5_patt['UI'])
        BANKn=['-']*len(lp5_patt['UI'])
        ROWn=['0x0']*len(lp5_patt['UI'])
        COLn=['0x0']*len(lp5_patt['UI'])
        MRn=['-']*len(lp5_patt['UI'])
        ETCn=['-']*len(lp5_patt['UI'])
        Datan=['-']*len(lp5_patt['UI'])
        WCKn=['-']*len(lp5_patt['UI'])
        RDQS0n=['-']*len(lp5_patt['UI'])
        RDQS1n=['-']*len(lp5_patt['UI'])
        DMI0n=['-']*len(lp5_patt['UI'])
        DMI1n=['-']*len(lp5_patt['UI'])


        BANK_RA=[0]*16 # A0 A1 A2 A3 B0 B1 B2 B3 ....  

        RA='0x0'
        COLA='0x0'
        MR_='-'
        BA=0
        ACT_BA=0
        BANK='-'
        ACT_BANK='-'
        clkcnt=0
        CMD_now="-"
        CMD_Prev="-"
        PD_DSM=''
        SAFETY=[0,0,0,0]
        TMRS_SEQ=0 # 1C 2S 3G 4L 5E
        TMRS_=['0','0','0']
        TMRS_PHASE='0'
        TMRS_CODE='T0000'
        ADDR_=['']*1000
        DATA_=['']*1000 # (BL16 or BL32 Data All)
        WR_PGMIDX_=[0]*1000

        CAS_B3=0
        hsdi_otf_idx=0


        for ii in range(1,len(lp5_patt['UI']),1):
            CA06=lp5_patt['CA'][ii]
        #     CA06=str(lp5_patt['CA0A'][ii])[0]+str(lp5_patt['CA1A'][ii])[0]+str(lp5_patt['CA2A'][ii])[0]+str(lp5_patt['CA3A'][ii])[0]+str(lp5_patt['CA4A'][ii])[0]+str(lp5_patt['CA5A'][ii])[0]+str(lp5_patt['CA6A'][ii])[0]
        #     CA06n[ii]=CA06+"_"
        #     WCKn[ii]=CA06+"_"

        #     R0T=''
        #     if str(lp5_patt['RDQS0T_E'][ii])=='Hr':
        #         R0T='1'
        #     elif str(lp5_patt['RDQS0T_E'][ii])=='Lr':
        #         R0T='0'
        #     else:
        #         R0T='_'
        #     if str(lp5_patt['RDQS0T_O'][ii])=='Hr':
        #         R0T=R0T+'1_'
        #     elif str(lp5_patt['RDQS0T_O'][ii])=='Lr':
        #         R0T=R0T+'0_'
        #     else:
        #         R0T=R0T+'__'
        #     RDQS0n[ii]=R0T
        #     if str(lp5_patt['RDQS1T_E'][ii])=='Hr':
        #         R0T='1'
        #     elif str(lp5_patt['RDQS1T_E'][ii])=='Lr':
        #         R0T='0'
        #     else:
        #         R0T='_'
        #     if str(lp5_patt['RDQS1T_O'][ii])=='Hr':
        #         R0T=R0T+'1_'
        #     elif str(lp5_patt['RDQS1T_O'][ii])=='Lr':
        #         R0T=R0T+'0_'
        #     else:
        #         R0T=R0T+'__'
        #     RDQS1n[ii]=R0T

        #     if str(lp5_patt['DMI0_E'][ii])=='Hr' or str(lp5_patt['DMI0_E'][ii])=='1':
        #         R0T='1'
        #     elif str(lp5_patt['DMI0_E'][ii])=='Lr' or str(lp5_patt['DMI0_E'][ii])=='0':
        #         R0T='0'
        #     else:
        #         R0T='_'
        #     if str(lp5_patt['DMI0_O'][ii])=='Hr' or str(lp5_patt['DMI0_O'][ii])=='1':
        #         R0T=R0T+'1_'
        #     elif str(lp5_patt['DMI0_O'][ii])=='Lr' or str(lp5_patt['DMI0_O'][ii])=='0':
        #         R0T=R0T+'0_'
        #     else:
        #         R0T=R0T+'__'
        #     DMI0n[ii]=R0T

        #     if str(lp5_patt['DMI1_E'][ii])=='Hr' or str(lp5_patt['DMI1_E'][ii])=='1':
        #         R0T='1'
        #     elif str(lp5_patt['DMI1_E'][ii])=='Lr' or str(lp5_patt['DMI1_E'][ii])=='0':
        #         R0T='0'
        #     else:
        #         R0T='_'
        #     if str(lp5_patt['DMI1_O'][ii])=='Hr' or str(lp5_patt['DMI1_O'][ii])=='1':
        #         R0T=R0T+'1_'
        #     elif str(lp5_patt['DMI1_O'][ii])=='Lr' or str(lp5_patt['DMI1_O'][ii])=='0':
        #         R0T=R0T+'0_'
        #     else:
        #         R0T=R0T+'__'
        #     DMI1n[ii]=R0T

        #     WCKn[ii]=str(lp5_patt['WCK0T_E'][ii])+str(lp5_patt['WCK0T_O'][ii])+'_'

        # print(CA06)
            if lp5_patt['CLKT'][ii-1]==1 and lp5_patt['CLKT'][ii]==0:
                clkcnt=clkcnt+1
                CLKn[ii]=clkcnt
                if str(lp5_patt['CS0'][ii])[0]=='0':
                    CMD_now="DES"
                else:
                    if CA06[0:7]=='0000000': CMD_now='NOP'
                    elif CA06[0:7]=='0000001': CMD_now='PDE'
                    elif CA06[0:3]=='111': CMD_now='ACT-1'
                    elif CA06[0:3]=='110': CMD_now='ACT-2'
                    elif CA06[0:7]=='0001111': CMD_now='PRE'
                    elif CA06[0:7]=='0001110': CMD_now='REF'
                    elif CA06[0:3]=='010': CMD_now='MWR'
                    elif CA06[0:3]=='011': CMD_now='WR(16)'
                    elif CA06[0:4]=='0010': CMD_now='WR32'
                    elif CA06[0:3]=='100': CMD_now='RD(16)'
                    elif CA06[0:3]=='101': CMD_now='RD32'
                    elif CA06[0:4]=='0011': 
                        if CA06[0:7]=='0011000': CMD_now='CAS-DUM'
                        elif CA06[0:7]=='0011100': CMD_now='CAS-WR'
                        elif CA06[0:7]=='0011010': CMD_now='CAS-RD'
                        elif CA06[0:7]=='0011001': CMD_now='CAS-FS'
                        elif CA06[0:7]=='0011101': CMD_now='CASTOP'
                    elif CA06[0:6]=='000011': CMD_now='MPC'
                    elif CA06[0:7]=='0001011': CMD_now='SRE'
                    elif CA06[0:7]=='0001010': CMD_now='SRX'
                    elif CA06[0:7]=='0001101': CMD_now='MRW-1'
                    elif CA06[0:6]=='000100': CMD_now='MRW-2'
                    elif CA06[0:7]=='0001100': CMD_now='MRR'
                    elif CA06[0:7]=='0000011': CMD_now='WFF'
                    elif CA06[0:7]=='0000010': CMD_now='RFF'
                    elif CA06[0:7]=='0000101': CMD_now='RDC'

                    else: CMD_now='NOP_1'

                    # if str(lp5_patt['CA0A'][ii])[0]=='1' and str(lp5_patt['CA1A'][ii])[0]=='1' and str(lp5_patt['CA2A'][ii])[0]=='1': CMD_now="ACT-1"
                    # elif str(lp5_patt['CA0A'][ii])[0]=='0' and str(lp5_patt['CA1A'][ii])[0]=='0' and str(lp5_patt['CA2A'][ii])[0]=='0' and str(lp5_patt['CA3A'][ii])[0]=='0' and str(lp5_patt['CA4A'][ii])[0]=='0' and str(lp5_patt['CA5A'][ii])[0]=='0' and str(lp5_patt['CA6A'][ii])[0]=='1': CMD_now="PDE"
                    # elif str(lp5_patt['CA0A'][ii])[0]=='1' and str(lp5_patt['CA1A'][ii])[0]=='1' and str(lp5_patt['CA2A'][ii])[0]=='0': CMD_now="ACT-2"
                    # elif str(lp5_patt['CA0A'][ii])[0]=='0' and str(lp5_patt['CA1A'][ii])[0]=='0' and str(lp5_patt['CA2A'][ii])[0]=='0' and str(lp5_patt['CA3A'][ii])[0]=='1' and str(lp5_patt['CA4A'][ii])[0]=='1' and str(lp5_patt['CA5A'][ii])[0]=='1' and str(lp5_patt['CA6A'][ii])[0]=='1': CMD_now="PRE"
                    # elif str(lp5_patt['CA0A'][ii])[0]=='0' and str(lp5_patt['CA1A'][ii])[0]=='0' and str(lp5_patt['CA2A'][ii])[0]=='0' and str(lp5_patt['CA3A'][ii])[0]=='1' and str(lp5_patt['CA4A'][ii])[0]=='1' and str(lp5_patt['CA5A'][ii])[0]=='1' and str(lp5_patt['CA6A'][ii])[0]=='0': CMD_now="_REF"
                    # elif str(lp5_patt['CA0A'][ii])[0]=='0' and str(lp5_patt['CA1A'][ii])[0]=='0' and str(lp5_patt['CA2A'][ii])[0]=='0' and str(lp5_patt['CA3A'][ii])[0]=='0' and str(lp5_patt['CA4A'][ii])[0]=='1' and str(lp5_patt['CA5A'][ii])[0]=='1': CMD_now="MPC"
                    # elif str(lp5_patt['CA0A'][ii])[0]=='0' and str(lp5_patt['CA1A'][ii])[0]=='1' and str(lp5_patt['CA2A'][ii])[0]=='0': CMD_now="MWR"
                    # elif str(lp5_patt['CA0A'][ii])[0]=='0' and str(lp5_patt['CA1A'][ii])[0]=='1' and str(lp5_patt['CA2A'][ii])[0]=='1': CMD_now="WR(16)"
                    # elif str(lp5_patt['CA0A'][ii])[0]=='0' and str(lp5_patt['CA1A'][ii])[0]=='0' and str(lp5_patt['CA2A'][ii])[0]=='1' and str(lp5_patt['CA3A'][ii])[0]=='0' : CMD_now="WR32"
                    # elif str(lp5_patt['CA0A'][ii])[0]=='1' and str(lp5_patt['CA1A'][ii])[0]=='0' and str(lp5_patt['CA2A'][ii])[0]=='0': CMD_now="RD(16)"
                    # elif str(lp5_patt['CA0A'][ii])[0]=='1' and str(lp5_patt['CA1A'][ii])[0]=='0' and str(lp5_patt['CA2A'][ii])[0]=='1': CMD_now="RD(32)"
                    # else: CMD_now="NOP"

                CMDn[ii]=CMD_now
            else:
                CLKn[ii]=clkcnt
                CMDn[ii]=CMD_now
            
            if CMD_now[0:3]=='ACT':
                if CMD_now=='ACT-1' and lp5_patt['CLKT'][ii]==0: 
                    RA0=int(CA06[3])*pow(2,14)+int(CA06[4])*pow(2,15)+int(CA06[5])*pow(2,16)+int(CA06[6])*pow(2,17)
                if CMD_now=='ACT-1' and lp5_patt['CLKT'][ii]==1: 
                    RA1=int(CA06[4])*pow(2,11)+int(CA06[5])*pow(2,12)+int(CA06[6])*pow(2,13)
                    BA=int(CA06[0])+int(CA06[1])*2+int(CA06[2])*4+int(CA06[3])*8
                    BANK=chr(65+int(CA06[0])+int(CA06[1])*2)+str(int(CA06[2])*1+int(CA06[3])*2)
                    ACT_BA=BA
                    ACT_BANK=BANK
                if CMD_now=='ACT-2'and lp5_patt['CLKT'][ii]==0: RA2=int(CA06[3])*pow(2,7)+int(CA06[4])*pow(2,8)+int(CA06[5])*pow(2,9)+int(CA06[6])*pow(2,10)
                if CMD_now=='ACT-2'and lp5_patt['CLKT'][ii]==1: 
                    RA3=int(CA06[0])+int(CA06[1])*2+int(CA06[2])*pow(2,2)+int(CA06[3])*pow(2,3)+int(CA06[4])*pow(2,4)+int(CA06[5])*pow(2,5)+int(CA06[6])*pow(2,6)
                    RA=hex(RA0+RA1+RA2+RA3)
                    BANK_RA[BA]=RA0+RA1+RA2+RA3
                    BA=ACT_BA
                    BANK=ACT_BANK
                # print("%5d"%(ii),"%2s"%(BANK),"0x%05X"%(RA),CMD_now,CA06)
            elif (CMD_now[0:3]=='PRE' or CMD_now[0:3]=='REF') and lp5_patt['CLKT'][ii]==1:
                
                BA=int(CA06[0])+int(CA06[1])*2+int(CA06[2])*4+int(CA06[3])*8
                BANK=chr(65+int(CA06[0])+int(CA06[1])*2)+str(int(CA06[2])*1+int(CA06[3])*2)
                if CA06[6]=='1': BANK='ALL'
                if CMD_now[0:3]=='PRE':
                    if BANK=='ALL': 
                        for bi in range(16): BANK_RA[bi]=-1
                    elif BANK in ['A0','A1','A2','A3','B0','B1','B2','B3','C0','C1','C2','C3','D0','D1','D2','D3']:
                        BANK_RA[BA]=-1
                    else:
                        for bi in range(16): BANK_RA[bi]=-1

            elif CMD_now[0:3]=='NOP' and CMD_Prev[0:3]=='DES' and PD_DSM!='':
                if PD_DSM=='PD':
                    PD_DSM=''
                elif PD_DSM=='DSM':
                    PD_DSM='PD'   
                CMD_now='PDX'+"_"+PD_DSM
                CMDn[ii]=CMD_now
                
            elif CMD_now[0:3]=='NOP' and CMD_Prev[0:3]=='PDX':
                CMD_now='DEX'
            elif CMD_now[0:3]=='NOP' and CMD_Prev[0:3]=='DEX':
                CMD_now='DEX'

            elif CMD_now[0:3]=='CAS' and lp5_patt['CLKT'][ii]==1:
                CAS_B3=int(CA06[6])
                CMD_now=CMD_now+'_F'+str(int(CA06[0])+int(CA06[1])*2+int(CA06[2])*4)
                CMDn[ii]=CMD_now
                hsdi_otf_idx=int(CA06[0])+int(CA06[1])*2+int(CA06[2])*4
                # print("CAS")


            elif CMD_now[0:3]=='MWR' or CMD_now[0:2]=='WR' or CMD_now[0:2]=='RD' or CMD_now[0:3]=='WFF' or CMD_now[0:3]=='RFF':
                if lp5_patt['CLKT'][ii]==0: 
                    COL0=int(CA06[3])*pow(2,0)+int(CA06[4])*pow(2,3)+int(CA06[5])*pow(2,4)+int(CA06[6])*pow(2,5)
                if lp5_patt['CLKT'][ii]==1: 
                    COL1=int(CA06[4])*pow(2,1)+int(CA06[5])*pow(2,2)
                    if CMD_now[0:2]=='RD': COLA=hex((COL0+COL1)*16+CAS_B3*8)
                    else: COLA=hex((COL0+COL1)*16)            
                    BA=int(CA06[0])+int(CA06[1])*2+int(CA06[2])*4+int(CA06[3])*8
                    BANK=chr(65+int(CA06[0])+int(CA06[1])*2)+str(int(CA06[2])*1+int(CA06[3])*2)
                    RA=hex(BANK_RA[BA])

                    if CMD_now[0:3]=='RDC' or CMD_now[0:3]=='WFF' or CMD_now[0:3]=='RFF':
                        RA='0x0'
                        COLA='0x0'
                        BANK='-'
                                    

                    if lp5_patt['CLKT'][ii-1]==0: 
                        IO_Data_=''
                        DMI_Data0_=''
                        DMI_Data1_=''

                        for iBL in range(valid_bl_line*2):
                            IO_data=0

                        Addr_Data=BANK+'_'+RA+'_'+COLA    
                        Addr_Data_=BANK+'_'+'0'*(6-len(RA))+RA[2:len(RA)]+'_'+'0'*(5-len(COLA))+COLA[2:len(COLA)]
                        for iBL in range(valid_bl_line):
                            if CMD_now[0:2]=='RD':
                                IO_Data_=IO_Data_+lp5_patt['DATA_e'][ii+RL_*lp5_ckr_+iBL][2:]+'_'+lp5_patt['DATA_o'][ii+RL_*lp5_ckr_+iBL][2:]+'_'
                                DMI_Data0_=DMI_Data0_+lp5_patt['DMI0'][ii+RL_*lp5_ckr_+iBL][:2]
                                DMI_Data1_=DMI_Data1_+lp5_patt['DMI1'][ii+RL_*lp5_ckr_+iBL][:2]
                            else:
                                if hsdi_otf_idx==0 or (hsc_mode[0]==hsc_mode[1]):
                                    IO_Data_=IO_Data_+lp5_patt['DATA_e'][ii+WL_*lp5_ckr_+iBL][2:]+'_'+lp5_patt['DATA_o'][ii+WL_*lp5_ckr_+iBL][2:]+'_'
                                else: 
                                    # IO_data_tmp=int(lp5_patt['DATA_e'][ii+WL_*lp5_ckr_+iBL][2:],16)^(0xffff*int(hsdi_otf[hsdi_otf_idx][iBL]))
                                    # print('%x %x '%(int(lp5_patt['DATA_e'][ii+WL_*lp5_ckr_+iBL][2:],16),IO_data_tmp))
                                    IO_Data_=IO_Data_+str('%X'%(int(lp5_patt['DATA_e'][ii+WL_*lp5_ckr_+iBL][2:],16)^(0xffff*int(hsdi_otf[hsdi_otf_idx][iBL]))))+'_'
                                    IO_Data_=IO_Data_+str('%X'%(int(lp5_patt['DATA_o'][ii+WL_*lp5_ckr_+iBL][2:],16)^(0xffff*int(hsdi_otf[hsdi_otf_idx][iBL]))))+'_'
                                    
                                DMI_Data0_=DMI_Data0_+lp5_patt['DMI0'][ii+WL_*lp5_ckr_+iBL][:2]
                                DMI_Data1_=DMI_Data1_+lp5_patt['DMI1'][ii+WL_*lp5_ckr_+iBL][:2]
                        if CMD_now[2:]=='32':
                            for iBL in range(valid_bl_line):
                                if CMD_now[0:2]=='RD':
                                    IO_Data_=IO_Data_+lp5_patt['DATA_e'][ii+RL_*lp5_ckr_+iBL+valid_bl_line*2][2:]+'_'+lp5_patt['DATA_o'][ii+RL_*lp5_ckr_+iBL+valid_bl_line*2][2:]+'_'
                                    DMI_Data0_=DMI_Data0_+lp5_patt['DMI0'][ii+RL_*lp5_ckr_+iBL+valid_bl_line*2][:2]
                                    DMI_Data1_=DMI_Data1_+lp5_patt['DMI1'][ii+RL_*lp5_ckr_+iBL+valid_bl_line*2][:2]
                                else:

                                    if hsdi_otf_idx==0 or (hsc_mode[0]==hsc_mode[1]):
                                        IO_Data_=IO_Data_+lp5_patt['DATA_e'][ii+WL_*lp5_ckr_+iBL+valid_bl_line*2][2:]+'_'+lp5_patt['DATA_o'][ii+WL_*lp5_ckr_+iBL+valid_bl_line*2][2:]+'_'
                                    else: 
                                        # IO_data_tmp=int(lp5_patt['DATA_e'][ii+WL_*lp5_ckr_+iBL][2:],16)^(0xffff*int(hsdi_otf[hsdi_otf_idx][iBL]))
                                        # print('%x %x '%(int(lp5_patt['DATA_e'][ii+WL_*lp5_ckr_+iBL][2:],16),IO_data_tmp))
                                        IO_Data_=IO_Data_+str('%X'%(int(lp5_patt['DATA_e'][ii+WL_*lp5_ckr_+iBL+valid_bl_line*2][2:],16)^(0xffff*int(hsdi_otf[hsdi_otf_idx][iBL]))))+'_'
                                        IO_Data_=IO_Data_+str('%X'%(int(lp5_patt['DATA_o'][ii+WL_*lp5_ckr_+iBL+valid_bl_line*2][2:],16)^(0xffff*int(hsdi_otf[hsdi_otf_idx][iBL]))))+'_'

                                    
                                    DMI_Data0_=DMI_Data0_+lp5_patt['DMI0'][ii+WL_*lp5_ckr_+iBL+valid_bl_line*2][:2]
                                    DMI_Data1_=DMI_Data1_+lp5_patt['DMI1'][ii+WL_*lp5_ckr_+iBL+valid_bl_line*2][:2]
                                    

                        DMI_Data0_=DMI_Data0_+'_'
                        DMI_Data1_=DMI_Data1_+'_'

                        if CMD_now[0:2]=='WR':
                            for iA in range(0,len(ADDR_)):
                                if (Addr_Data==ADDR_[iA]): 
                                    DATA_[iA]=IO_Data_
                                    WR_PGMIDX_[iA]=ii
                                    # print(ii,iA,Addr_Data,IO_Data_,CMD_now)
                                    # iA=len(ADDR_)
                                    break
                                elif (ADDR_[iA]==''):
                                    ADDR_[iA]=Addr_Data
                                    DATA_[iA]=IO_Data_
                                    WR_PGMIDX_[iA]=ii
                                    # print(ii,iA,Addr_Data,IO_Data_,CMD_now)
                                    # iA=len(ADDR_)
                                    break

                        if CMD_now[0:3]=='MWR':
                            for iA in range(0,len(ADDR_)):
                                if (Addr_Data==ADDR_[iA]):
                                    IO_MWR_Data=''
                                    IO_Data_BL_Stored=DATA_[iA].split('_')
                                    IO_Data_BL_Write=IO_Data_.split('_')
                                    for iBL in range(valid_bl_line*2):
                                        if DMI_Data0_[iBL]=='0': IO_BL_Data0=IO_Data_BL_Write[iBL][2:4]
                                        elif DMI_Data0_[iBL]=='1': IO_BL_Data0=IO_Data_BL_Stored[iBL][2:4]
                                        if DMI_Data1_[iBL]=='0': IO_BL_Data1=IO_Data_BL_Write[iBL][0:2]
                                        elif DMI_Data1_[iBL]=='1': IO_BL_Data1=IO_Data_BL_Stored[iBL][0:2]
                                        IO_MWR_Data=IO_MWR_Data+IO_BL_Data1+IO_BL_Data0+'_'
                                    # print(DMI_Data0_,DMI_Data1_)
                                    # print(IO_Data_BL_Stored)
                                    # print(IO_Data_BL_Write)
                                    # print(IO_MWR_Data.split("_"))
                                    DATA_[iA]=IO_MWR_Data                            
                                    # DATA_[iA]=IO_Data_
                                    WR_PGMIDX_[iA]=ii
                                    # print(ii,iA,Addr_Data,IO_Data_,CMD_now)
                                    # iA=len(ADDR_)
                                    break
                                elif (ADDR_[iA]==''):
                                    IO_MWR_Data=''
                                    IO_Data_BL_Stored=['----']*valid_bl_line*2
                                    IO_Data_BL_Write=IO_Data_.split('_')
                                    for iBL in range(valid_bl_line*2):
                                        if DMI_Data0_[iBL]=='0': IO_BL_Data0=IO_Data_BL_Write[iBL][2:4]
                                        elif DMI_Data0_[iBL]=='1': IO_BL_Data0=IO_Data_BL_Stored[iBL][2:4]
                                        if DMI_Data1_[iBL]=='0': IO_BL_Data1=IO_Data_BL_Write[iBL][0:2]
                                        elif DMI_Data1_[iBL]=='1': IO_BL_Data1=IO_Data_BL_Stored[iBL][0:2]
                                        IO_MWR_Data=IO_MWR_Data+IO_BL_Data1+IO_BL_Data0+'_'

                                    # print(DMI_Data0_,DMI_Data1_,IO_Data_,DATA_[iA],IO_MWR_Data)

                                    ADDR_[iA]=Addr_Data
                                    DATA_[iA]=IO_MWR_Data
                                    WR_PGMIDX_[iA]=ii
                                    # # print(ii,iA,Addr_Data,IO_Data_,CMD_now)
                                    # # iA=len(ADDR_)
                                    break

                        elif CMD_now[0:2]=='RD' and CMD_now[0:3]!='RD':
                            iA=0
                            IO_Data_tmp=IO_Data_
                            if (Addr_Data in ADDR_): 
                                # print('exist^^^',ii,Addr_Data)
                                for iA in range(0,len(ADDR_)):
                                    if (Addr_Data==ADDR_[iA]): 
                                        # if DATA_[iA]!=IO_Data_: print('%6d(%6s) %4d'%(ii,lp5_patt['IDX'][ii],iA),'FAIL',Addr_Data_,IO_Data_,' - ',DATA_[iA],'%6d(%6s)'%(WR_PGMIDX_[iA],hex(math.ceil((WR_PGMIDX_[iA]+1)/32))))
                                        # else : print('%6d(%6s) %4d'%(ii,lp5_patt['IDX'][ii],iA),'P---',Addr_Data_,IO_Data_,' - ',DATA_[iA],'%6d(%6s)'%(WR_PGMIDX_[iA],hex(math.ceil((WR_PGMIDX_[iA]+1)/32))))
                                            #  else : print('PASS')
                                        break
                                    elif ADDR_[iA]=='':
                                        # print('ERROR ??? ',ii,lp5_patt['IDX'][ii],Addr_Data,iA)
                                        break
                                    # else : print(iA,'FAIL',Addr_Data,IO_Data_)
                                    # break
                            else:
                                if str(CAS_B3)=='1':
                                    # print('exist!!!',ii,Addr_Data)
                                    for iA in range(0,len(ADDR_)):
                                        # IO_Data_tmp=IO_Data_
                                        IO_Data_=IO_Data_tmp[40:80]+IO_Data_tmp[0:40]
                                        if CMD_now[2:]=='32':
                                            IO_Data_=IO_Data_+IO_Data_tmp[120:160]+IO_Data_tmp[80:120]
                                        if (Addr_Data[0:len(Addr_Data)-1]==ADDR_[iA][0:len(ADDR_[iA])-1]): 
                                            # if DATA_[iA]!=IO_Data_: print('%6d(%6s) %4d'%(ii,lp5_patt['IDX'][ii],iA),'FAIL',Addr_Data_,IO_Data_,' - ',DATA_[iA],'%6d(%6s)'%(WR_PGMIDX_[iA],hex(math.ceil((WR_PGMIDX_[iA]+1)/32))))
                                            # else : print('%6d(%6s) %4d'%(ii,lp5_patt['IDX'][ii],iA),'P---',Addr_Data_,IO_Data_,' - ',DATA_[iA],'%6d(%6s)'%(WR_PGMIDX_[iA],hex(math.ceil((WR_PGMIDX_[iA]+1)/32))))
                                            break
                                        elif ADDR_[iA]=='':
                                            # print('ERROR ?_? ',ii,lp5_patt['IDX'][ii],Addr_Data) #,iA,ADDR_[0:iA])
                                            break
                                # else:
                            # print('exist---',ii,Addr_Data,IO_Data_tmp,IO_Data_)

                            # else:  # (ADDR_[iA]==''):
                            #     print('ERROR  ',ii,lp5_patt['IDX'][ii],Addr_Data,Addr_Data_,CAS_B3,RA,COLA)
                                # print(ADDR_)
                                # break

                            # IO_Data_=IO_Data_+hex(IO_data)+'_'
                        Datan[ii]=IO_Data_   
                # if CMD_now[0:3]=='WFF' or CMD_now[0:3]=='RFF' or CMD_now[0:3]=='RDC':
                #     ADDR_[iA]=''
                    # print(CMD_now[0:3],Addr_Data)


            elif CMD_now[0:3]=='SRE' and lp5_patt['CLKT'][ii]==1:
                if CA06[6]=='1': 
                    CMD_now='SRE_PD'                    
                    PD_DSM='PD'
                elif CA06[5]=='1': 
                    CMD_now='SRE_DSM'
                    PD_DSM='DSM'
                CMDn[ii]=CMD_now
                # print(CMD_now,ii)
            elif CMD_now[0:3]=='PDE':
                PD_DSM='PD'

            elif CMD_now[0:3]=='MPC':
                if lp5_patt['CLKT'][ii]==0: MR_OP7=int(CA06[0])*pow(2,7)
                elif lp5_patt['CLKT'][ii]==1: 
                    MR_OP06=int(CA06[0])+int(CA06[1])*2+int(CA06[2])*pow(2,2)+int(CA06[3])*pow(2,3)+int(CA06[4])*pow(2,4)+int(CA06[5])*pow(2,5)+int(CA06[6])*pow(2,6)
                    MR_OP_=hex(MR_OP7+MR_OP06)
                    if MR_OP_=='0x81': ETC='Start_WCK2DQI_Osc.'
                    elif MR_OP_=='0x82': ETC='Stop_WCK2DQI_Osc.'
                    elif MR_OP_=='0x83': ETC='Start_WCK2DQO_Osc.'
                    elif MR_OP_=='0x84': ETC='Stop_WCK2DQO_Osc.'
                    elif MR_OP_=='0x85': ETC='ZQ_CAL_Start'
                    elif MR_OP_=='0x86': ETC='ZQ_CAL_Latch'
            elif CMD_now[0:2]=='MR':            
                if (CMD_now=='MRW-1' or CMD_now[0:3]=='MRR') and lp5_patt['CLKT'][ii]==1:
                    MR_MA0=hex(int(CA06[0])+int(CA06[1])*2+int(CA06[2])*pow(2,2)+int(CA06[3])*pow(2,3)+int(CA06[4])*pow(2,4)+int(CA06[5])*pow(2,5)+int(CA06[6])*pow(2,6))
                    if len(MR_MA0)==3: MR_MA='0x0'+MR_MA0[2]
                    else: MR_MA=MR_MA0
                elif CMD_now=='MRW-2' and lp5_patt['CLKT'][ii]==0:
                    MR_OP7=int(CA06[0])*pow(2,7)
                elif CMD_now=='MRW-2' and lp5_patt['CLKT'][ii]==1:
                    MR_OP06=int(CA06[0])+int(CA06[1])*2+int(CA06[2])*pow(2,2)+int(CA06[3])*pow(2,3)+int(CA06[4])*pow(2,4)+int(CA06[5])*pow(2,5)+int(CA06[6])*pow(2,6)
                    MR_OP_=hex(MR_OP7+MR_OP06)
                    if len(MR_OP_)==3: MR_OP='0x0'+MR_OP_[2]
                    else: MR_OP=MR_OP_          

                if CMD_now[0:3]=='MRR' and lp5_patt['CLKT'][ii]==1: MRn[ii]=MR_MA    
                elif CMD_now=='MRW-2' and lp5_patt['CLKT'][ii]==1:
                    MRn[ii]=MR_MA+'_'+MR_OP[2:4]    
                    if MRn[ii]=='0x09_20':
                        if SAFETY==[0,0,0,0]:
                            ETC='SAFETY1'
                            if lp5_patt['CLKT'][ii+1]==0: SAFETY=[1,0,0,0]
                        elif SAFETY==[1,0,0,0]:
                            ETC='SAFETY2'
                            if lp5_patt['CLKT'][ii+1]==0: SAFETY=[1,1,0,0]
                        elif SAFETY==[1,1,0,0]:
                            ETC='SAFETY3'
                            if lp5_patt['CLKT'][ii+1]==0: SAFETY=[1,1,1,0]
                    elif MRn[ii]=='0x09_7f' and SAFETY==[1,1,1,0]:
                        ETC='SAFETY4'
                        if lp5_patt['CLKT'][ii+1]==0: SAFETY=[0,0,0,0]
                    elif MRn[ii][0:6]=='0x09_0':
                        if lp5_patt['CLKT'][ii-1]==0: TMRS_SEQ=TMRS_SEQ+1
                        # print(MRn[ii])
                        if TMRS_SEQ<4: 
                            # print(MRn[ii])
                            TMRS_[TMRS_SEQ-1]=MRn[ii][6]
                            ETC=str(TMRS_SEQ)
                        elif TMRS_SEQ==4:
                            ETC='LATCH'
                        elif TMRS_SEQ==5:
                            if TMRS_==['0','0','0']:
                                TMRS_PHASE='1'
                                ETC='PHASE1'
                            elif TMRS_==['1','2','0']: 
                                TMRS_PHASE='2'
                                ETC='PHASE2'
                            elif TMRS_==['3','1','4']: 
                                TMRS_PHASE='3'
                                ETC='PHASE3'
                            else:
                                TMRS_CODE='T'+TMRS_PHASE+TMRS_[0]+TMRS_[1]+TMRS_[2]
                                ETC=TMRS_CODE
                            if lp5_patt['CLKT'][ii+1]==0:TMRS_SEQ=0

                            
            else:
                BANK='-'
                RA='-'
                COLA='-'
                MR_MA='-'
                MR_OP='-'
                MR_OP7=0
                ETC='-'

            BANKn[ii]=BANK
            ROWn[ii]=RA
            COLn[ii]=COLA
            ETCn[ii]=ETC
            CMD_Prev=CMD_now



        lp5_patt['CLK_cnt']=CLKn
        lp5_patt['CMD']=CMDn
        lp5_patt['BANK']=BANKn
        lp5_patt['ROW']=ROWn
        lp5_patt['COLA']=COLn
        lp5_patt['MR_VAL']=MRn
        lp5_patt['ETC']=ETCn
        lp5_patt['Data']=Datan
        # lp5_patt['CA']=CA06n

        # lp5_patt['WCK']=WCKn
        # lp5_patt['RDQS0']=RDQS0n
        # lp5_patt['RDQS1']=RDQS1n
        # lp5_patt['DMI0']=DMI0n
        # lp5_patt['DMI1']=DMI1n

        # print(lp5_patt)
        # print(list(lp5_patt))
        #                      ['IDX', 'LABEL', 'PC', 'UI', 'CLKT', 'CS0', 'CS1', 'CA', 'WCKT', 'RDQST', 'DMI0', 'DMI1', 'DATA_e', 'DATA_o', 'CLK_cnt', 'CMD', 'BANK', 'ROW', 'COLA', 'MR_VAL', 'ETC', 'Data']
        # lp5_patt_a0=lp5_patt[['IDX', 'PATT', 'LABEL', 'PC', 'UI','CLKT', 'CS0A', 'CS1A', 'CA', 'WCK', 'RDQS0', 'RDQS1', 'DMI0', 'DMI1' , 'DQ_E', 'DQ_O' ,'CLK_cnt', 'CMD', 'BANK', 'ROW', 'COLA', 'MR_VAL', 'ETC', 'Data']]
        # lp5_patt_a0.columns=['IDX', 'PATT', 'LABEL', 'PC', 'UI', 'CLKT', 'CS0', 'CS1', 'CA', 'WCK', 'RDQS0', 'RDQS1', 'DMI0', 'DMI1', 'DQ_E', 'DQ_O', 'CLK_cnt', 'CMD', 'BANK', 'ROW', 'COLA', 'MR_VAL', 'ETC', 'Data']

        # lp5_patt_a0=lp5_patt
        # print(lp5_patt_a0)

        # patt_name='GSTC_lp5_patt0.csv'

        try:
            lp5_patt.to_csv(outfile_name)
            # print("to file : ",outfile_name)
        except:
            lp5_patt.to_csv('GSTC_lp5_patt11.csv')
        if ipat_equip==1:
            lp5_patt_epic=lp5_patt
        if ipat_equip==0:
            lp5_patt_t5511=lp5_patt


    #=================================================================================
    #=================================================================================
    #=================================================================================
    #=================================================================================
    #=================================================================================
    #=================================================================================
    # print("========================================")
    # print("=====   COMPARE          ===============")
    # print("========================================")

    # patt_name='PDCS4FCOB7N5ANN'
    # patt_name='PDCS4FADC7N5ANN'
    # patt_name='PDCS4FPBR6N4MNN'

    if (len(patnlist[ipat])==13):
        epic_patt_name=patnlist[ipat]+'NN_epic_parsing.txt'
        t5511_patt_name=patnlist[ipat]+'NN_t5511_parsing.txt'
    else:
        epic_patt_name=patnlist[ipat]+'_epic_parsing.txt'
        t5511_patt_name=patnlist[ipat]+'_t5511_parsing.txt'


    epic_patt = pd.read_csv(epic_patt_name,sep=",")
    t5511_patt = pd.read_csv(t5511_patt_name,sep=",")

    col_list=list(t5511_patt)
    col_list[0]='linecnt'
    t5511_patt.columns=col_list
    epic_patt.columns=col_list

    # print(epic_patt)
    # print(t5511_patt)


    # print(epic_patt[epic_patt['CMD']=='ACT-2']['CMD'].count())
    # print(t5511_patt[t5511_patt['CMD']=='ACT-2']['CMD'].count())

    # epic_patt2=epic_patt[(epic_patt['UI']==2) | (epic_patt['UI']==6)]

    if ckr==2:
        epic_patt2=epic_patt[(epic_patt['UI']==1) | (epic_patt['UI']==3) | (epic_patt['UI']==5) | (epic_patt['UI']==7) | (epic_patt['UI']==9) | (epic_patt['UI']==11) | (epic_patt['UI']==13) | (epic_patt['UI']==15)].reset_index().drop(['index'],axis='columns')
        t5511_patt2=t5511_patt[(t5511_patt['UI']==1) | (t5511_patt['UI']==3) | (t5511_patt['UI']==5) | (t5511_patt['UI']==7) | (t5511_patt['UI']==9) | (t5511_patt['UI']==11) | (t5511_patt['UI']==13) | (t5511_patt['UI']==15)].reset_index().drop(['index'],axis='columns')
    else:
        epic_patt2=epic_patt[(epic_patt['UI']==2) | (epic_patt['UI']==6) | (epic_patt['UI']==10) | (epic_patt['UI']==14)].reset_index().drop(['index'],axis='columns')
        t5511_patt2=t5511_patt[(t5511_patt['UI']==2) | (t5511_patt['UI']==6) | (t5511_patt['UI']==10) | (t5511_patt['UI']==14)].reset_index().drop(['index'],axis='columns')
    # print(epic_patt2)
    # print(t5511_patt2)


    epic_patt=epic_patt2
    t5511_patt=t5511_patt2


    epic_cmd=epic_patt[(epic_patt['CMD']!='DES') & (epic_patt['CMD']!='DEX')].reset_index().drop(['index'],axis='columns')
    t5511_cmd=t5511_patt[(t5511_patt['CMD']!='DES') & (t5511_patt['CMD']!='DEX')].reset_index().drop(['index'],axis='columns')

    epic_cmd_gap=[0]*len(epic_cmd['IDX'])
    t5511_cmd_gap=[0]*len(t5511_cmd['IDX'])

    for i in range(1,len(epic_cmd['IDX'])):
        epic_cmd_gap[i]=epic_cmd['linecnt'][i]-epic_cmd['linecnt'][i-1]
    for i in range(1,len(t5511_cmd['IDX'])):
        t5511_cmd_gap[i]=t5511_cmd['linecnt'][i]-t5511_cmd['linecnt'][i-1]

    epic_cmd['CGAP']=epic_cmd_gap.copy()
    t5511_cmd['CGAP']=t5511_cmd_gap.copy()

    epic_cmd['CBRC']=epic_cmd['CMD']+'_'+epic_cmd['BANK']+'_'+epic_cmd['ROW']+'_'+epic_cmd['COLA']
    t5511_cmd['CBRC']=t5511_cmd['CMD']+'_'+t5511_cmd['BANK']+'_'+t5511_cmd['ROW']+'_'+t5511_cmd['COLA']


    # if (len(epic_cmd['IDX'])==len(t5511_cmd['IDX'])):
    epic_cmd=epic_cmd

    epic_cmd=epic_cmd.reset_index()#.rename(index={'index':'idx'},inplace=True)
    cmd_list=list(epic_cmd)
    cmd_list[0]='idx'
    epic_cmd.columns=cmd_list
    t5511_cmd=t5511_cmd.reset_index()#.rename(index={'index':'idx'},inplace=True)
    cmd_list=list(t5511_cmd)
    cmd_list[0]='idx'
    t5511_cmd.columns=cmd_list

    # print(epic_cmd)
    # print(t5511_cmd)

    cmd_gap_cmp=pd.merge(t5511_cmd[['idx','CBRC','Data','CGAP']],epic_cmd[['idx','CBRC','Data','CGAP','IDX']],how = "inner", on = "idx")
    cmd_gap_cmp['gap_cmp']=t5511_cmd['CGAP']-epic_cmd['CGAP']

    cmd_cmp=[0]*len(cmd_gap_cmp['idx'])
    data_cmp=[0]*len(cmd_gap_cmp['idx'])


    # print(list(cmd_gap_cmp))

    cmd_gap_cmp.columns=['idx', 'CBRC_t5511', 'Data_t5511', 'CGAP_t5511', 'CBRC_epic', 'Data_epic', 'CGAP_epic','EPIC_IDX', 'gap_cmp']
    # print(cmd_gap_cmp[cmd_gap_cmp['cmp']!=0])

    for i in range(len(cmd_gap_cmp['idx'])):
        if (cmd_gap_cmp['CBRC_t5511'][i]!=cmd_gap_cmp['CBRC_epic'][i]):
            cmd_cmp[i]=1
        if (cmd_gap_cmp['Data_t5511'][i]!=cmd_gap_cmp['Data_epic'][i]):
            data_cmp[i]=1

    cmd_gap_cmp['cmd_cmp']=cmd_cmp
    cmd_gap_cmp['data_cmp']=data_cmp

    # print(cmd_gap_cmp)

    # print(cmd_gap_cmp[(cmd_gap_cmp['gap_cmp']!=0)])
    # print(cmd_gap_cmp[(cmd_gap_cmp['cmd_cmp']!=0)])
    # print(cmd_gap_cmp[(cmd_gap_cmp['data_cmp']!=0)])
    # print(cmd_gap_cmp[(cmd_gap_cmp['gap_cmp']!=0) or (cmd_gap_cmp['cmd_cmp']!=0) or (cmd_gap_cmp['data_cmp']!=0)])

    # cmd_gap_cmp.to_csv(patnlist[ipat]+'_CMD_.txt')

    cmd_cnt_gap=len(epic_cmd['idx'])-len(t5511_cmd['idx'])

    print("%5d (%6d %6d ) %4d %4d %4d"%(cmd_cnt_gap,len(epic_cmd['idx']),len(t5511_cmd['idx']),len(cmd_gap_cmp[(cmd_gap_cmp['gap_cmp']!=0)]['idx']),len(cmd_gap_cmp[(cmd_gap_cmp['cmd_cmp']!=0)]['idx']),len(cmd_gap_cmp[(cmd_gap_cmp['data_cmp']!=0)]['idx'])))
    # print("COMPARE : %s %5d (%6d %6d ) %4d %4d %4d"%(patnlist[ipat],cmd_cnt_gap,len(epic_cmd['idx']),len(t5511_cmd['idx']),len(cmd_gap_cmp[(cmd_gap_cmp['gap_cmp']!=0)]['idx']),len(cmd_gap_cmp[(cmd_gap_cmp['cmd_cmp']!=0)]['idx']),len(cmd_gap_cmp[(cmd_gap_cmp['data_cmp']!=0)]['idx'])))
    cmd_gap_cmp.to_csv(patnlist[ipat]+'_CMD_.txt')

