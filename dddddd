#!/usr/bin/env python

import sys
import os
import glob
import errno

CONV_VER="V1.00"
 
## REVISION HISTORY

## ir errprint=1 then print error to monitor (Also write to file)
errprint=0

#filename_org=["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
filename_org=['']*200
file_cnt=0
#print ("file_list: {}".format(file_list))
# print(len(sys.argv),sys.argv[0],sys.argv[1])

Cbit=['C0','C1','C2','C3','C4','C5','C6','C7','C8','C9','C10','C11','C12','C13','C14','C15','C16','C17','C18','C19','C20','C21','C22','C23','C24','C25','C26','C27','C28','C29','C30','C31','W','DRE','DRE2','R','M2','/D','/D2','SCROFF']

xyreg_name=['XC_1','XS_1','XK_1','XB_1','XC_2','XS_2','XK_2','XB_2','XC_3','XS_3','XK_3','XB_3','XC_4','XS_4','XK_4','XB_4','XH_1''XH_2','XH_3','XH_4','XT1','XT2','XT3','XT4','XT5','XT6','XT7','XT8','XT9','XT10','XT11','XT12','XT13','XT14','XT15','XT16','YC_1','YS_1','YK_1','YB_1','YC_2','YS_2','YK_2','YB_2','YC_3','YS_3','YK_3','YB_3','YC_4','YS_4','YK_4','YB_4','YH_1''YH_2','YH_3','YH_4','YT1','YT2','YT3','YT4','YT5','YT6','YT7','YT8','YT9','YT10','YT11','YT12','YT13','YT14','YT15','YT16']

xyreg_=[0]*100
# yreg_name=['YC_1','YS_1','YK_1','YB_1','YC_2','YS_2','YK_2','YB_2','YC_3','YS_3','YK_3','YB_3','YC_4','YS_4','YK_4','YB_4','YH_1''YH_2','YH_3','YH_4','YT1','YT2','YT3','YT4','YT5','YT6','YT7','YT8','YT9','YT10','YT11','YT12','YT13','YT14','YT15','YT16']
# yreg_=[0]*50
dreg_name=['D1A_1','D1B_1','D1C_1','D1D_1','D2A_1','D2B_1','D2C_1','D2D_1','D1E_1','D1F_1','D1G_1','D1H_1','D3_1','D3B_1','D4_1','D4B_1','D1A_2','D1B_2','D1C_2','D1D_2','D2A_2','D2B_2','D2C_2','D2D_2','D1E_2','D1F_2','D1G_2','D1H_2','D3_2','D3B_2','D4_2','D4B_2','D1A_3','D1B_3','D1C_3','D1D_3','D2A_3','D2B_3','D2C_3','D2D_3','D1E_3','D1F_3','D1G_3','D1H_3','D3_3','D3B_3','D4_3','D4B_3','D1A_4','D1B_4','D1C_4','D1D_4','D2A_4','D2B_4','D2C_4','D2D_4','D1E_4','D1F_4','D1G_4','D1H_4','D3_4','D3B_4','D4_4','D4B_4','D5_1','D6_1','D5_2','D6_2','D5_3','D6_3','D5_4','D6_4']
dreg_=[0]*200
dreg_region=[0]*200

tpreg_name=['TPH1A_1','TPH1B_1','TPH1C_1','TPH1D_1','TPH1E_1','TPH1F_1','TPH1G_1','TPH1H_1','TPH1A_2','TPH1B_2','TPH1C_2','TPH1D_2','TPH1E_2','TPH1F_2','TPH1G_2','TPH1H_2','TPH1A_3','TPH1B_3','TPH1C_3','TPH1D_3','TPH1E_3','TPH1F_3','TPH1G_3','TPH1H_3','TPH1A_4','TPH1B_4','TPH1C_4','TPH1D_4','TPH1E_4','TPH1F_4','TPH1G_4','TPH1H_4','TPH2A_1','TPH2B_1','TPH2C_1','TPH2D_1','TPH2E_1','TPH2F_1','TPH2G_1','TPH2H_1','TPH2A_2','TPH2B_2','TPH2C_2','TPH2D_2','TPH2E_2','TPH2F_2','TPH2G_2','TPH2H_2','TPH2A_3','TPH2B_3','TPH2C_3','TPH2D_3','TPH2E_3','TPH2F_3','TPH2G_3','TPH2H_3','TPH2A_4','TPH2B_4','TPH2C_4','TPH2D_4','TPH2E_4','TPH2F_4','TPH2G_4','TPH2H_4']
tpreg_=[0]*100

tp1=0
tp2=0
tp1_=[0,0,0,0,0]
tp2_=[0,0,0,0,0]

for idr in range(len(dreg_name)):
   if dreg_name[idr]=='D2A_1':
      dreg_[idr]=int('0x3f0',16)
   elif dreg_name[idr]=='D2A_2':
      dreg_[idr]=int('0x3f0',16)
   elif dreg_name[idr]=='D3B_1':
      dreg_[idr]=int('0xffff',16)
   elif dreg_name[idr]=='D4B_1':
      dreg_[idr]=int('0x20',16)
   elif dreg_name[idr]=='D4B_2':
      dreg_[idr]=int('0x20',16)

for itp in range(len(tpreg_name)):
   if tpreg_name[itp]=='TPH1A_1':
      tpreg_[itp]=int('0x6666',16)
   if tpreg_name[itp]=='TPH2A_1':
      tpreg_[itp]=int('0x6666',16)

x_addr=0
y_addr=0

label_name=['']*100
label_pc=[0]*100
label_idx=[0]*100
ccflg='1011000000000001'

FMD01_CA0=['Y0,Y8','X16','C0','C0','X16','X0','C0','Y16','C0','C0,C0','C0,Y12','/X16','/X16','/Y16','C0,Y13','C0,FL']
FMD01_CA1=['Y1,Y9','X17','C1','C1','X17','X1','C1','Y17','C1','C1,C1','C1,Y13','/X17','/X17','/Y17','Y10,FL','C1,Y13']
FMD01_CA2=['Y2,Y10','X18','C2','C2','X18','X2','C2','Y18','C2','C2,C2','C2,Y14','/X18','/X18','/Y18','C2,FL','C2,FL']
FMD01_CA3=['Y3,Y11','X19','X7','C3','X19','X3','Y4','Y19','C3','C3,C3','X14,Y15','/X19','/X19','/Y19','C3,FL','C3,FL']
FMD01_CA4=['Y4,Y12','X11','X8','C4','FL','X4','Y7','Y5','Y7','C4,C4','X15,FL','X11','FL','Y5','Y9,FL','C4,FL']
FMD01_CA5=['Y5,Y13','X12','X9','C5','C5','X5','Y8','Y6','Y8','C5,C5','FL,FL','X12','C5','Y6','Y9,FL','C5,FL']
FMD01_CA6=['Y6,Y14','X13','X10','C6','C6','X6','Y9','C6','Y9','Y7,Y15','FL,FL','X13','C6','C6','Y8,FL','Y3,FL']

FMD02_CA0=['Y0,Y8','C0','C0','C0','C0','X0','C0','C0','C0','C0,C0','C0,Y12','/X16','/X16','/Y16','C0,Y13','C0,FL']
FMD02_CA1=['Y1,Y9','C1','C1','C1','C1','X1','C1','C1','C1','C1,C1','C1,Y13','/X17','/X17','/Y17','Y10,FL','C1,Y13']
FMD02_CA2=['Y2,Y10','C2','C2','C2','C2','X2','C2','C2','C2','C2,C2','C2,Y14','/X18','/X18','/Y18','C2,FL','C2,FL']
FMD02_CA3=['Y3,Y11','C3','X7','C3','C3','X3','Y4','C3','C3','C3,C3','X14,Y15','/X19','/X19','/Y19','C3,FL','C3,FL']
FMD02_CA4=['Y4,Y12','X11','X8','C4','FL','X4','Y7','Y5','Y7','C4,C4','X15,FL','X11','FL','Y5','Y9,FL','C4,FL']
FMD02_CA5=['Y5,Y13','X12','X9','C5','C5','X5','Y8','Y6','Y8','C5,C5','FL,FL','X12','C5','Y6','Y9,FL','C5,FL']
FMD02_CA6=['Y6,Y14','X13','X10','C6','C6','X6','Y9','C6','Y9','Y7,Y15','FL,FL','X13','C6','C6','Y8,FL','Y3,FL']


scr2=[0x0000,0x03FF,0x0400,0x07FF,0x0800,0x0BFF,0x0C00,0x0FFF,0x1000,0x13FF,0x1400,0x17FF,0x1800,0x1BFF,0x1C00,0x1FFF,
0x2000,0x23FF,0x2400,0x27FF,0x2800,0x2BFF,0x2C00,0x2FFF,0x3000,0x33FF,0x3400,0x37FF,0x3800,0x3BFF,0x3C00,0x3FFF,
0x4000,0x43FF,0x4400,0x47FF,0x4800,0x4BFF,0x4C00,0x4FFF,0x5000,0x53FF,0x5400,0x57FF,0x5800,0x5BFF,0x5C00,0x5FFF,
0x6000,0x63FF,0x6400,0x67FF,0x6800,0x6BFF,0x6C00,0x6FFF,0x7000,0x73FF,0x7400,0x77FF,0x7800,0x7BFF,0x7C00,0x7FFF,
0x8000,0x83FF,0x8400,0x87FF,0x8800,0x8BFF,0x8C00,0x8FFF,0x9000,0x93FF,0x9400,0x97FF,0x9800,0x9BFF,0x9C00,0x9FFF,
0xA000,0xA3FF,0xA400,0xA7FF,0xA800,0xABFF,0xAC00,0xAFFF,0xB000,0xB3FF,0xB400,0xB7FF,0xB800,0xBBFF,0xBC00,0xBFFF,
0xC000,0xC3FF,0xC400,0xC7FF,0xC800,0xCBFF,0xCC00,0xCFFF,0xD000,0xD3FF,0xD400,0xD7FF,0xD800,0xDBFF,0xDC00,0xDFFF,
0xE000,0xE3FF,0xE400,0xE7FF,0xE800,0xEBFF,0xEC00,0xEFFF,0xF000,0xF3FF,0xF400,0xF7FF,0xF800,0xFBFF,0xFC00,0xFFFF]

# if len(sys.argv) > 2:
#    print('VERSION:'+CONV_VER)
#    print('NOT Enough Arguements,  Check Arguments! ')
#    print('check ORG_PATN1 ORG_PATN2 ...')
#    sys.exit()
# elif len(sys.argv) == 3 :
#    errprint=1
# else:
#    errprint=0
#    sys.exit()

header_sdef_alias=['']*3000
header_sdef_desc=['']*3000
header_sdef_cbit=['']*3000
sdef_idx=0

xsp=127

# path=str(sys.argv[1])
path='.\\'

#path="./T5511/Dsol_200109/X16_8BANK_R21/"
file_list = os.listdir(path)
# print(path)
# src_file=str(sys.argv[1])
patline=['']
patline_seq=['']
pccnt_seq=[0]
icnt_seq=[0]
label_seq=['']
lineway_seq=[0]
patline_f0=['']


patnlist=[
   '',
   'FUNA(4060,6,4,4,183,LP5VD2,LP5TCK,"VND01","FTD02","PNND2","PDBS4FADC7N5A",#6666,0.0NS, 3.9US," Address Compliment                    ")',
   'FUNA(4007,6,4,4,183,LP5VD2,LP5TCK,"VND01","FTD01","PNND2","PDBS4FCOB7N5A",#6666,0.0NS,  1.0S," Column Bar test                       ")', 
   ]


# print(patnlist[0][5:len(patnlist[0])-1].split(','))



for ipat in range(len(patnlist)):
   if len(patnlist[ipat])<10:
      continue
   dreg_region=[0]*200

   print(patnlist[ipat])
   patn_lst=patnlist[ipat][5:len(patnlist[ipat])-1].split(',')
   patn_name=patn_lst[10].strip('"')+'NN.asc'
   patn_fmt=patn_lst[8].strip('"')
   patn_iofmt=patn_lst[11]
   patn_scr=patn_lst[9].strip('"')[4]
   patn_tn=patn_lst[0]

   if patn_scr=='2':
      xsp=0x7f

   # print(patn_scr,xsp)

   if patn_fmt=='FTD01':
      pat_format='FMD01'
   elif patn_fmt=='FTD02':
      pat_format='FMD02'
   else:
      pat_format=patn_fmt

   region_src = open('XHREGION.asc', 'r')
   rlabel='ABCDEF:'      
   rlabel_set=''
   for rline in region_src:
      rline_tmp=rline.split()
      if patn_name[6:13] in rline and rlabel=='ABCDEF:':
         rlabel=rline_tmp[len(rline_tmp)-1]+":"
      if rlabel in rline and rlabel!='ABCDEF:':
         rlabel_set='Y'
         # print(rline)
      elif rlabel_set=='Y' and len(rline_tmp)>0:
         # print(rline)         
         if rline_tmp[0]=='GOTO':
            rlabel_set=''
         if rline_tmp[0]=='REG' and rline_tmp[2][0]=='D':
            if rline_tmp[2]=='D1': rline_tmp[2]='D1A_1'
            if rline_tmp[2]=='D2': rline_tmp[2]='D2A_1' 
            if rline_tmp[2]=='D1_2': rline_tmp[2]='D1A_2'
            if rline_tmp[2]=='D2_2': rline_tmp[2]='D2A_2' 
            if rline_tmp[2]=='D3B': rline_tmp[2]='D3B_1' 
            if rline_tmp[2]=='D4B': rline_tmp[2]='D4B_1' 
            if rline_tmp[2]=='D5': rline_tmp[2]='D5_1'
            if rline_tmp[2]=='D6': rline_tmp[2]='D6_1' 
            
            for idr in range(len(dreg_name)):
               if dreg_name[idr]==rline_tmp[2]:
                  dreg_region[idr]=1
                  if rline_tmp[4]=='XSP':
                     dreg_[idr]=xsp
                     # print(dreg_name[idr],xsp)
                  elif rline_tmp[4][0]=='#':
                     dreg_[idr]=int(rline_tmp[1:],16)


   # src = open(src_file, 'r')
   src = open(patn_name, 'r')
   linecnt=0
   patt_start=0
   patt_register=0
   for line in src:
      tmpline=line
      tmpsplit=line.split()
      # if len(tmpsplit)>0:
      # if linecnt<100:
         # print(line,end='')
         # if len(tmpsplit)>0:
            # print(tmpsplit[0])
      if len(tmpsplit)>0:
         if tmpsplit[0][0]!=';':
            if patt_start==0 and patt_register==0:
               if tmpsplit[0]=='INSERT':
                  ins_file_naem=tmpsplit[1]
                  ins_src = open(path+ins_file_naem+'.asc', 'r')
                  for ins_line in ins_src:
                     ins_tmpline=ins_line
                     ins_tmpsplit=ins_line.split()
                     if len(ins_tmpsplit)>1:
                        if ins_tmpsplit[0][0]!=';' and ins_tmpline[0:10].find('SDEF')>-1:
                           # print(ins_line,end='')
                           if ins_tmpsplit[1][len(ins_tmpsplit[1])-1]=='=':
                              header_sdef_alias[sdef_idx]=ins_tmpsplit[1][len(ins_tmpsplit[1])-2]   
                              # print('===')
                           else:
                              # print(ins_tmpline,sdef_idx)
                              header_sdef_alias[sdef_idx]=ins_tmpsplit[1]
                              for ij in range(3,len(ins_tmpsplit)):
                                 desc_match=0
                                 # print(ins_tmpsplit[ij])
                                 for ik in range(sdef_idx):
                                    # print(ik,header_sdef_alias[sdef_idx])   
                                    if ins_tmpsplit[ij]==header_sdef_alias[ik]:
                                       # print(ins_tmpsplit[ij],header_sdef_desc[ik])
                                       header_sdef_cbit[sdef_idx]=header_sdef_cbit[sdef_idx]+header_sdef_desc[ik]+' '
                                       # print(ins_tmpsplit[ij],header_sdef_desc[ik],header_sdef_cbit[sdef_idx])
                                       desc_match=1
                                 if desc_match==0:
                                    # print('-',end='')
                                    # print(ins_tmpsplit[ij],ins_tmpsplit[1])
                                    header_sdef_cbit[sdef_idx]=header_sdef_cbit[sdef_idx]+ins_tmpsplit[ij]+' '
                           header_sdef_desc[sdef_idx]=ins_tmpline[ins_tmpline.find('=')+2:len(ins_tmpline)-1]
                           sdef_idx=sdef_idx+1
                  ins_src.close()
               # print(patt_start,line,end='')
            if patt_start==1:
               tmpline_cb=''
               if tmpline.find(';')>0:
                  tmpsplit=tmpline[:tmpline.find(';')].split()
               else:
                  tmpsplit=tmpline.split()
               
               if tmpsplit[0]=='INSERT': # insert 1
                  ins_file_naem=tmpsplit[1]
                  ins_src = open(path+ins_file_naem+'.asc', 'r')
                  for ins_line in ins_src:
                     tmpline_cb=''
                     ins_tmpline=ins_line
                     # ins_tmpsplit=ins_line.split()
                     if ins_tmpline.find(';')>0:
                        ins_tmpsplit=ins_tmpline[:ins_tmpline.find(';')].split()
                     else:
                        ins_tmpsplit=ins_tmpline.split()

                     if len(ins_tmpsplit)>0:
                        if ins_tmpsplit[0]=='INSERT':   # insert 2
                           ins_file_naem2=ins_tmpsplit[1]
                           ins_src2 = open(path+ins_file_naem2+'.asc', 'r')
                           for ins_line2 in ins_src2:
                              tmpline_cb=''
                              ins_tmpline2=ins_line2
                              # ins_tmpsplit=ins_line.split()
                              if ins_tmpline2.find(';')>0:
                                 ins_tmpsplit2=ins_tmpline2[:ins_tmpline2.find(';')].split()
                              else:
                                 ins_tmpsplit2=ins_tmpline2.split()
                              if len(ins_tmpsplit2)>0:
                                 if ins_tmpsplit2[0][0]!=';':
                                    for ik in range(len(ins_tmpsplit2)):
                                       alias_match=0
                                       for ik2 in range(sdef_idx):
                                          if ins_tmpsplit2[ik]==header_sdef_alias[ik2]:
                                             tmpline_cb=tmpline_cb+header_sdef_cbit[ik2]+' '
                                             alias_match=1
                                       if alias_match==0:
                                          tmpline_cb=tmpline_cb+ins_tmpsplit2[ik]+' '
                                    # print(ins_tmpsplit,"-",tmpline_cb.split())
                                    patline[linecnt]=tmpline_cb
                                    linecnt=linecnt+1
                                    patline.append([''])
                        else:
                           if ins_tmpsplit[0][0]!=';':
                              for ik in range(len(ins_tmpsplit)):
                                 alias_match=0
                                 for ik2 in range(sdef_idx):
                                    if ins_tmpsplit[ik]==header_sdef_alias[ik2]:
                                       tmpline_cb=tmpline_cb+header_sdef_cbit[ik2]+' '
                                       alias_match=1
                                 if alias_match==0:
                                    tmpline_cb=tmpline_cb+ins_tmpsplit[ik]+' '
                              # print(ins_tmpsplit,"-",tmpline_cb.split())
                              patline[linecnt]=tmpline_cb
                              linecnt=linecnt+1
                              patline.append([''])
                  ins_src.close()
               else:
                  # print(tmpline,end='')
                  for ik in range(len(tmpsplit)):
                     alias_match=0
                     for ik2 in range(sdef_idx):
                        if tmpsplit[ik]==header_sdef_alias[ik2]:
                           tmpline_cb=tmpline_cb+header_sdef_cbit[ik2]+' '
                           alias_match=1
                     if alias_match==0:
                        tmpline_cb=tmpline_cb+tmpsplit[ik]+' '
                  # print(tmpsplit,"-",tmpline_cb.split())
                  patline[linecnt]=tmpline_cb
                  linecnt=linecnt+1
                  # print(len(patline))
                  patline.append([''])

            if patt_register==1:
               if tmpsplit[0]=='D1': tmpsplit[0]='D1A_1'
               if tmpsplit[0]=='D2': tmpsplit[0]='D2A_1' 
               if tmpsplit[0]=='D1_2': tmpsplit[0]='D1A_2'
               if tmpsplit[0]=='D2_2': tmpsplit[0]='D2A_2' 
               if tmpsplit[0]=='D3B': tmpsplit[0]='D3B_1' 
               if tmpsplit[0]=='D4B': tmpsplit[0]='D4B_1' 
               if tmpsplit[0]=='D5': tmpsplit[0]='D5_1'
               if tmpsplit[0]=='D6': tmpsplit[0]='D6_1' 
               if tmpsplit[0]=='XH': tmpsplit[0]='XH_1'
               if tmpsplit[0]=='YH': tmpsplit[0]='YH_1' 

               if tmpsplit[0][0]=='D':
                  for idr in range(len(dreg_name)):
                     if dreg_name[idr]==tmpsplit[0]:
                        if dreg_region[idr]==0:
                           if tmpsplit[2][0]=='#':
                              dreg_[idr]=int(tmpsplit[2][1:],16)
                           else:
                              dreg_[idr]=int(tmpsplit[2])
               if tmpsplit[0][0]=='T':
                  if patn_iofmt=='#0000' or patn_iofmt=='#0' or patn_iofmt=='0':
                     if tmpsplit[2][0]=='#':
                        tpreg_val=int(tmpsplit[2][1:],16)
                     else:
                        tpreg_val=int(tmpsplit[2])
                  else:
                     if patn_iofmt[0]=='#':
                        tpreg_val=int(patn_iofmt[1:],16)
                     else:
                        tpreg_val=int(patn_iofmt)

                  for itph in range(len(tpreg_name)):
                     if tpreg_name[itph]=='TPH1A_1' or tpreg_name[itph]=='TPH2A_1':
                        tpreg_[itph]=tpreg_val

            if tmpsplit[0]=='START':
               patt_start=1
               patt_register=0
            if tmpsplit[0]=='REGISTER':
               patt_register=1

   src.close()

   # for i in range(sdef_idx):
   #    tmpsplit=header_sdef_cbit[i].split()
   #    for ij in range(len(tmpsplit)):
   #       if (tmpsplit[ij].find('<')>=-1):
   #          if (tmpsplit[ij][0])=='X':
   #             print(tmpsplit[ij][:tmpsplit[ij].find('<')])
   #    print(i,header_sdef_alias[i],"=",header_sdef_cbit[i].split())

   # for i in range(100):
   #    print(i,header_sdef_alias[i],"=",header_sdef_cbit[i].split())

   pcnt=0
   lineway=[0]*linecnt
   pccnt=[0]*linecnt
   label=['-']*linecnt
   labelcnt=0

   for i in range(linecnt):
      pattmp0=patline[i].split()
      if pattmp0[0]!=':':
         pcnt=pcnt+1
         waycnt=0
         if len(pattmp0[0])>0:
            if pattmp0[0][len(pattmp0[0])-1]==':':
               label[i]=pattmp0[0][:len(pattmp0[0])-1]
      waycnt=waycnt+1
      pccnt[i]=pcnt
      lineway[i]=waycnt
      # print('%5d %5X %10s %2d '%(i,pccnt[i],label[i],lineway[i]),patline[i])
      # if patline[i][:4]=='STPS':
      #    break
      if label[i]!='-':
         label_name[labelcnt]= label[i]
         label_pc[labelcnt]= pccnt[i]
         label_idx[labelcnt]= i
         labelcnt=labelcnt+1


   # for i in range(labelcnt):
      # print(label_name[i],label_idx[i],"%04X"%(label_pc[i]))

   #---------------------------------------------------------------------
   pi=0
   jump_=0
   call_=0
   rtn_=0
   call_addr=[0]*10
   ret_addr=[0]*10
   cr_sp=0

   jump_addr=0

   loop_cnt=[-1]*10
   loop_addr=[0]*10


   # call_addr=0
   # ret_addr=0

   cr_sp=0
   pat_seq_cnt=0
   # print(linecnt)
   for i in range(linecnt*50):

      # print('%5d %5d %5X %10s %2d '%(i,pi,pccnt[pi],label[pi],lineway[pi]),patline[pi])
      # patline_seq[pat_seq_cnt]=patline[pi]
      patline_split=patline[pi].split()
      patline_seq[pat_seq_cnt]=''
      for isp in range(len(patline_split)):
         patline_seq[pat_seq_cnt]=patline_seq[pat_seq_cnt]+str(patline_split[isp])+' '



      pccnt_seq[pat_seq_cnt]=pccnt[pi]
      icnt_seq[pat_seq_cnt]=pi
      label_seq[pat_seq_cnt]=label[pi]
      lineway_seq[pat_seq_cnt]=lineway[pi]

      patline_seq.append([''])
      pccnt_seq.append([0])
      icnt_seq.append([0])
      label_seq.append([''])
      lineway_seq.append([0])
      pat_seq_cnt=pat_seq_cnt+1
      if lineway[pi]==1 and patline[pi].find('JNC')>-1:
         if patline_split[0][0:3]=='JNC':
            j_sp_loc=0
         elif patline_split[1][0:3]=='JNC':
            j_sp_loc=1
         elif patline_split[2][0:3]=='JNC':
            j_sp_loc=2
         else:
            j_sp_loc=3
         cflg_=int(patline_split[j_sp_loc][3:])
         # print(ccflg,patline[pi].split()[0])
         # print(cflg_,ccflg[16-cflg_],ccflg)
         if ccflg[16-cflg_]=='1':
            for ii in range(labelcnt):
               if patline_split[j_sp_loc+1]==label_name[ii]:
                  jump_addr=label_idx[ii]
                  jump_=1
            # print("jnc jump",jump_addr,patline[pi].split()[1])
      elif lineway[pi]==1 and patline[pi][:15].find('JSR')>-1:            
         if patline_split[0][0:3]=='JSR':
            j_sp_loc=0
         elif patline_split[1][0:3]=='JSR':
            j_sp_loc=1
         elif patline_split[2][0:3]=='JSR':
            j_sp_loc=2
         else:
            j_sp_loc=3
         # print("jsr","%d"%(cr_sp),patline[pi].split(),call_addr)
         for ii in range(labelcnt):
            if patline_split[j_sp_loc+1]==label_name[ii]:
               call_addr[cr_sp]=label_idx[ii]
               ret_addr[cr_sp]=pi+16
               call_=1
         cr_sp=cr_sp+1  
         # print(call_addr,ret_addr)
         # print('%5d %5d %5X %10s %2d '%(i,pi,pccnt[pi],label[pi],lineway[pi]),patline[pi])
      elif lineway[pi]==1 and patline[pi][:15].find('RTN')>-1:
         rtn_=1
      elif lineway[pi]==1 and patline[pi][:15].find('JMP')>-1:  
         if patline_split[0][0:3]=='JMP':
            j_sp_loc=0
         elif patline_split[1][0:3]=='JMP':
            j_sp_loc=1
         elif patline_split[2][0:3]=='JMP':
            j_sp_loc=2
         else:
            j_sp_loc=3
         for ii in range(labelcnt):
            if patline_split[j_sp_loc+1]==label_name[ii]:
               jump_addr=label_idx[ii]
               jump_=1
      elif lineway[pi]==1 and patline[pi][:15].find('JNI')>-1:  
         if patline_split[0][0:3]=='JNI':
            j_sp_loc=0
         elif patline_split[1][0:3]=='JNI':
            j_sp_loc=1
         elif patline_split[2][0:3]=='JNI':
            j_sp_loc=2
         else:
            j_sp_loc=3

         jninum_=int(patline_split[j_sp_loc][3:])
         if loop_cnt[jninum_]<0:   # first  case
            loop_cnt[jninum_]=1

         if loop_cnt[jninum_]==0:  # loop complete case
            loop_cnt[jninum_]=-1
            jump_=0
         else:                      # loop process
            loop_cnt[jninum_]=loop_cnt[jninum_]-1
            jump_=1
            for ii in range(labelcnt):
               if patline_split[j_sp_loc+1]==label_name[ii]:
                  jump_addr=label_idx[ii]
               # jump_=1

         # print(patline_split,loop_cnt)


      if lineway[pi]==16 and jump_==1:
         pi=jump_addr
         jump_=0
      elif lineway[pi]==16 and call_==1:
         pi=call_addr[cr_sp-1]
         call_=0
      elif lineway[pi]==16 and rtn_==1:
         pi=ret_addr[cr_sp-1]
         # print(ret_addr,cr_sp,pi)
         cr_sp=cr_sp-1
         rtn_=0
      else:
         pi=pi+1

      if patline_split[0]=='STPS':
         break

   #path = "./T5511/Dsol_191226/*k*.asc"
   #file_list = glob.glob(path)


   # ------------------------------------------------------------------------
   # ------------------------------------------------------------------------
   # ----           pattern extract routine -nn                                          
   # ----                                                                    
   # ------------------------------------------------------------------------
   # ------------------------------------------------------------------------

   # pat_format='FMD02'
   CYP=0

   F_CA=['','','','','','','']
   PinFm_CA=['','','','','','','']
   P_CA=['','','','','','','']
   # print(pat_format)
   if pat_format=='FMD01':
      F_CA[0]=FMD01_CA0
      F_CA[1]=FMD01_CA1
      F_CA[2]=FMD01_CA2
      F_CA[3]=FMD01_CA3
      F_CA[4]=FMD01_CA4
      F_CA[5]=FMD01_CA5
      F_CA[6]=FMD01_CA6
      # print(pat_format)
   elif pat_format=='FMD02':
      F_CA[0]=FMD02_CA0
      F_CA[1]=FMD02_CA1
      F_CA[2]=FMD02_CA2
      F_CA[3]=FMD02_CA3
      F_CA[4]=FMD02_CA4
      F_CA[5]=FMD02_CA5
      F_CA[6]=FMD02_CA6
      # print(pat_format)

   x_val=0
   y_val=0

   x_tmp0=''
   x_tmp =''
   y_tmp0=''
   y_tmp =''

   for i in range(pat_seq_cnt):
      PinFm_CA=['','','','','','','']
      P_CA=['','','','','','','']
      pat_seq_sp=patline_seq[i].split()

      # print('%5d %5d %5X %10s %2d '%(i,icnt_seq[i],pccnt_seq[i],label_seq[i],lineway_seq[i]),end=' : ')
      patline_f0[i]=format('%6X %10s %5X %2d '%(i,label_seq[i],pccnt_seq[i],lineway_seq[i]))
      # print('%100s'%(patline_seq[i]),end=' : ')

      if patline_seq[i].find('CYP')>-1:
         cyp_tmp=patline_seq[i][patline_seq[i].find('CYP'):patline_seq[i].find('CYP')+10].split()[0]
         CYP=int(cyp_tmp[3:])
      else:      
         CYP=1
      # print("CYP=%2d"%(CYP),end=" ")

      if patline_seq[i].find('M2')>-1:
         for iCA in range(7):
            PinFm_CA[iCA]=F_CA[iCA][CYP-1].split(',')[1]
      else:
         for iCA in range(7):
            if F_CA[iCA][CYP-1].find(',')>-1:
               PinFm_CA[iCA]=F_CA[iCA][CYP-1].split(',')[0]
            else:
               PinFm_CA[iCA]=F_CA[iCA][CYP-1]


      # print('%3s %3s %3s %3s %3s %3s %3s'%(PinFm_CA[0],PinFm_CA[1],PinFm_CA[2],PinFm_CA[3],PinFm_CA[4],PinFm_CA[5],PinFm_CA[6]),end=" ~ ")



      x_tmp0=x_tmp
      y_tmp0=y_tmp
      # x,y address register
      if patline_seq[i].find('X<')>-1:
         x_tmp=patline_seq[i][patline_seq[i].find('X<'):patline_seq[i].find('X<')+10].split()[0].split('<')[1]
      elif patline_seq[i].find(' XT')>-1:
         x_tmp=patline_seq[i][patline_seq[i].find(' XT')+1:patline_seq[i].find(' XT')+10].split()[0]
      else:
         x_tmp="XC_1"

      if x_tmp=='XT':
         x_tmp='XT1'
      elif x_tmp.find('_')==-1 and x_tmp[1]!='T':
         x_tmp=x_tmp+'_1'

      if patline_seq[i].find('Y<')>-1:
         y_tmp=patline_seq[i][patline_seq[i].find('Y<'):patline_seq[i].find('Y<')+10].split()[0].split('<')[1]
      elif patline_seq[i].find(' YT')>-1:
         y_tmp=patline_seq[i][patline_seq[i].find(' YT')+1:patline_seq[i].find(' YT')+10].split()[0]
      else:
         y_tmp="YC_1"

      if y_tmp=='YT':
         y_tmp='YT1'
      elif y_tmp.find('_')==-1 and y_tmp[1]!='T':
         y_tmp=y_tmp+'_1'


      for ixy in range(len(xyreg_name)):
         if x_tmp==xyreg_name[ixy]:
            x_val=xyreg_[ixy]
         if y_tmp==xyreg_name[ixy]:
            y_val=xyreg_[ixy]

      if 'SCROFF' not in pat_seq_sp:
         # print(patline_seq[i])
         # print(x_val,end='_')
         if patn_scr=='2':
            if x_val>0xffff:
               x_val2=x_val//0x10000
               x_val=scr2[x_val%0x10000]
               x_val=x_val2*0x10000+x_val
            else:
               x_val=scr2[x_val]
         # print(x_val,end=' ')



      xbin=bin(x_val)
      xbinary=''
      for ibin in range(22-len(xbin)):
         xbinary=xbinary+'0'
      xbinary=xbinary+xbin[2:]

      ybin=bin(y_val)
      ybinary=''
      for ibin in range(22-len(ybin)):
         ybinary=ybinary+'0'
      ybinary=ybinary+ybin[2:]

      if patline_seq[i].find('D<TP_')>-1:
         tp_idx=int(patline_seq[i][patline_seq[i].find('D<TP_')+6])
         tp1=tp1_[tp_idx]
         tp2=tp2_[tp_idx]
      else:
         tp1=tp1_[1]
         tp2=tp2_[1]


      for iCA in range(7):
         if PinFm_CA[iCA][0]=='C':
            if PinFm_CA[iCA] in pat_seq_sp:
               P_CA[iCA]='1'
            else:
               P_CA[iCA]='0'
         elif PinFm_CA[iCA][0]=='X':
            xbit=int(PinFm_CA[iCA][1:])
            # print('%2d %5x'%(xbit,x_val))
            # if xbit>15:
               # print('%2d %5x'%(xbit,x_val))
            P_CA[iCA]=xbinary[19-xbit]
         elif PinFm_CA[iCA][0]=='Y':
            ybit=int(PinFm_CA[iCA][1:])
            P_CA[iCA]=ybinary[19-ybit]
         elif PinFm_CA[iCA]=='FL':
            P_CA[iCA]='0'
         elif PinFm_CA[iCA]=='FH':
            P_CA[iCA]='1'
         else:
            P_CA[iCA]=PinFm_CA[iCA]

      if 'C9' in pat_seq_sp:
         P_R0_CS='1'
      else:
         P_R0_CS='0'
      if 'C29' in pat_seq_sp:
         P_R1_CS='1'
      else:
         P_R1_CS='0'

      if 'C14' in pat_seq_sp:
         P_CKT='1'
      else:
         P_CKT='0'

      if 'C27' in pat_seq_sp and 'C28' in pat_seq_sp:
         P_WCKT='11_'
      elif 'C27' in pat_seq_sp:
         P_WCKT='10_'
      elif 'C28' in pat_seq_sp:
         P_WCKT='01_'
      else:
         P_WCKT='00_'

      if 'C15' in pat_seq_sp and 'C16' in pat_seq_sp:
         P_RDQS0T='11_'
      elif 'C15' in pat_seq_sp:
         P_RDQS0T='10_'
      elif 'C16' in pat_seq_sp:
         P_RDQS0T='01_'
      else:
         P_RDQS0T='00_'

      if 'C17' in pat_seq_sp and 'C18' in pat_seq_sp:
         P_RDQS1T='11_'
      elif 'C17' in pat_seq_sp:
         P_RDQS1T='10_'
      elif 'C18' in pat_seq_sp:
         P_RDQS1T='01_'
      else:
         P_RDQS1T='00_'


      if 'C19' in pat_seq_sp and 'C20' in pat_seq_sp:
         P_DMI0='11_'
      elif 'C19' in pat_seq_sp:
         P_DMI0='10_'
      elif 'C20' in pat_seq_sp:
         P_DMI0='01_'
      else:
         P_DMI0='00_'

      if 'C21' in pat_seq_sp and 'C22' in pat_seq_sp:
         P_DMI1='11_'
      elif 'C21' in pat_seq_sp:
         P_DMI1='10_'
      elif 'C22' in pat_seq_sp:
         P_DMI1='01_'
      else:
         P_DMI1='00_'




      # print('%3s %3s %3s %3s %3s %3s %3s %3s %3s %3s %4s %4s %4s'%(P_CKT,P_R0_CS,P_R1_CS,P_CA[0],P_CA[1],P_CA[2],P_CA[3],P_CA[4],P_CA[5],P_CA[6],P_WCKT,P_RDQS0T,P_RDQS1T),end=" ")
      # patline_f0[i]=patline_f0[i]+format('%1s %1s %1s %1s%1s%1s%1s%1s%1s%1s_ %2s %2s %2s '%(P_CKT,P_R0_CS,P_R1_CS,P_CA[0],P_CA[1],P_CA[2],P_CA[3],P_CA[4],P_CA[5],P_CA[6],P_WCKT,P_RDQS0T,P_RDQS1T))
      patline_f0[i]=patline_f0[i]+format('%1s %1s %1s %1s%1s%1s%1s%1s%1s%1s_ %2s %2s %2s %2s %2s '%(P_CKT,P_R0_CS,P_R1_CS,P_CA[6],P_CA[5],P_CA[4],P_CA[3],P_CA[2],P_CA[1],P_CA[0],P_WCKT,P_RDQS0T,P_RDQS1T,P_DMI0,P_DMI1))

      # patline_f0[i]=patline_f0[i]+format(' (%20s_%20s) '%(xbinary,ybinary))
      # patline_f0[i]=patline_f0[i]+format(' (%7x_%7x) '%(x_val,y_val))

      # tp data register


      
      for ixy in range(len(pat_seq_sp)):
         xy_val=0
         if pat_seq_sp[ixy].find("<")>1:
            xy_sp=pat_seq_sp[ixy].split('<')
            if xy_sp[0]=='XT':
               xy_sp[0]='XT1'
            elif xy_sp[0]=='YT':
               xy_sp[0]='YT1'
            elif xy_sp[0]=='TP':
               xy_sp[0]='TP1_1'
            elif xy_sp[0]=='TP1' or xy_sp[0]=='TP2':
               xy_sp[0]=xy_sp[0]+"_1"
            elif xy_sp[0]=='TPH':
               xy_sp[0]='TPH1A_1'
            elif xy_sp[0]=='TPH1' or xy_sp[0]=='TPH2':
               xy_sp[0]=xy_sp[0]+"A_1"
            elif xy_sp[0]=='D1' or xy_sp[0]=='D2':
               xy_sp[0]=xy_sp[0]+"A_1" 
            elif xy_sp[0].find('_')==-1 and xy_sp[0][1]!='T':   # non XT% YT%
               xy_sp[0]=xy_sp[0]+"_1"

            # A < #00
            if xy_sp[1].find("#")>-1:
               # xy_sp[1]=int('0x'+xy_sp[1][xy_sp[1].find('#')+1:],16)
               xy_val=int('0x'+xy_sp[1][xy_sp[1].find('#')+1:],16)
               # print(xy_sp[0],'%5X'%(xy_val))

            # A < B op C
            elif xy_sp[1].find('+')>-1 or xy_sp[1].find('-')>-1 or xy_sp[1].find('"')>-1:
               op_1=0
               op_2=0
               if xy_sp[1].find('+')>-1:
                  xy_sp_tmp=xy_sp[1].split('+')
               elif xy_sp[1].find('-')>-1:
                  xy_sp_tmp=xy_sp[1].split('-')
               elif xy_sp[1].find('"')>-1:
                  xy_sp_tmp=xy_sp[1].split('"')

               if xy_sp_tmp[0].find('_')==-1:
                     xy_sp_tmp[0]=xy_sp_tmp[0]+"_1"
                  
               for iixy in range(len(xyreg_name)):
                  if xy_sp_tmp[0]==xyreg_name[iixy]:
                     op_1=xyreg_[iixy]



               for iit in range(len(tpreg_name)):
                  if xy_sp_tmp[0]==tpreg_name[iit]:
                     op_1=tpreg_[iit]
               if xy_sp_tmp[0] in ['TP','TP2','TP_1','TP1_1','TP1_2','TP1_3','TP1_4','TP2_1','TP2_2','TP2_3','TP2_4']:
                  if xy_sp_tmp[0]=='TP' or xy_sp_tmp[0]=='TP_1':
                     xy_sp_tmp[0]='TP1_1' 
                  elif xy_sp_tmp[0]=='TP2':
                     xy_sp_tmp[0]='TP2_1' 
                  tp_idx=int(xy_sp_tmp[0][4])
                  if xy_sp_tmp[0][:3]=='TP1':
                     op_1=tp1_[tp_idx]
                  elif xy_sp_tmp[0][:3]=='TP2':
                     op_1=tp2_[tp_idx]
                  else:
                     op_1=tp1_[tp_idx+10]

               if xy_sp_tmp[1]=='1':
                  op_2=int(xy_sp_tmp[1])
               elif xy_sp_tmp[1][0]=='D':
                  if xy_sp_tmp[1].find('_')==-1:
                     xy_sp_tmp[1]=xy_sp_tmp[1]+"_1"
                  for idr in range(len(dreg_name)):
                     if xy_sp_tmp[1]==dreg_name[idr]:
                        op_2=dreg_[idr]

               if xy_sp[1].find('+')>-1:
                  xy_val=op_1+op_2
               elif xy_sp[1].find('-')>-1:
                  xy_val=op_1-op_2
               elif xy_sp[1].find('"')>-1:
                  xy_val=op_1^op_2

               # print('%X %X %X'%(xy_val,op_1,op_2))


   #        A < B
            elif xy_sp[1][0]=='D':
               if xy_sp[1]=='D1' or xy_sp[1]=='D2':
                  xy_sp[1]=xy_sp[1]+'A_1'
               elif xy_sp[1]=='D1_2' or xy_sp[1]=='D2_2':
                  xy_sp[1]=xy_sp[1][:2]+'A_2'
               elif xy_sp[1].find('_')==-1:
                  xy_sp[1]=xy_sp[1]+"_1"

               for idr in range(len(dreg_name)):
                  if xy_sp[1]==dreg_name[idr]:
                     xy_val=dreg_[idr]
               # print(xy_sp," %5X "%(xy_val))
            elif xy_sp[1][0]=='T':
               if xy_sp[1]=='TP':
                  xy_sp[1]='TP1_1'
               if xy_sp[1]=='TP1' or xy_sp[1]=='TP2':
                  xy_sp[1]=xy_sp[1]+"_1"
               elif xy_sp[1]=='TPH':
                  xy_sp[1]='TPH1A_1'
               elif xy_sp[1]=='TPH1' or xy_sp[1]=='TPH2':
                  xy_sp[1]=xy_sp[1]+"A_1"
               # xy_val=dreg_[0]    
               for itp in range(len(tpreg_name)):
                  if xy_sp[1]==tpreg_name[itp]:
                     # print(xy_sp[1])
                     xy_val=tpreg_[itp]
               # print(xy_sp,xy_val,tpreg_)
         
            else:
               xy_val=int(xy_sp[1])



            for iixy in range(len(xyreg_name)):
               if xy_sp[0]==xyreg_name[iixy]:
                  xyreg_[iixy]=xy_val
            for idr in range(len(dreg_name)):
               if xy_sp[0]==dreg_name[idr]:
                  dreg_[idr]=xy_val
            for iit in range(len(tpreg_name)):
               if xy_sp[0]==tpreg_name[iit]:
                  tpreg_[iit]=xy_val
            if xy_sp[0] in ['TP1_1','TP1_2','TP1_3','TP1_4','TP2_1','TP2_2','TP2_3','TP2_4']:
               tp_idx=int(xy_sp[0][4])
               if xy_sp[0][:3]=='TP1':
                  tp1_[tp_idx]=xy_val
               elif xy_sp[0][:3]=='TP2':
                  tp2_[tp_idx]=xy_val
               else:
                  tp1_[tp_idx+10]=xy_val
               # print(tp1_,tp2_)
            # print(xy_sp,xreg_,yreg_,xy_val)

      for ixy in range(len(xyreg_name)):
         if x_tmp==xyreg_name[ixy]:
            x_addr=xyreg_[ixy]
         if y_tmp==xyreg_name[ixy]:
            y_addr=xyreg_[ixy]


      tp1f=0
      tp2f=0
      if 'W' in pat_seq_sp or 'R' in pat_seq_sp:
         tp1f=tp1
         tp2f=tp2
         if '/D2' in pat_seq_sp:
            tp2f=tp2^65535
         elif '/D' in pat_seq_sp:
            tp1f=tp1^65535
         # print('%5s %5s %5X %5X %4X %4X'%(x_tmp,y_tmp,x_addr,y_addr,tp1f,tp2f),end='')  #~~
      # else:
         # print('%5s %5s %5X %5X %4X %4X'%(x_tmp,y_tmp,x_addr,y_addr,0,0),end='') #~~

         # print('%5s %5s %5X %5X %4X %4X'%(x_tmp,y_tmp,x_addr,y_addr,0,0),xyreg_,dreg_,end='')

   # print('%5d %5d %5X %10s %2d '%(i,icnt_seq[i],pccnt_seq[i],label_seq[i],lineway_seq[i]),end=' : ')
   #    print('%100s'%(patline_seq[i]),end=' : ')

      # print('%3s %3s %3s %3s %3s %3s %3s %3s %3s %3s %4s %4s %4s'%(P_CKT,P_R0_CS,P_R1_CS,P_CA[0],P_CA[1],P_CA[2],P_CA[3],P_CA[4],P_CA[5],P_CA[6],P_WCKT,P_RDQS0T,P_RDQS1T),end=" ")


      patline_f0[i]=patline_f0[i]+format('0x%04X 0x%04X'%(tp1f,tp2f))
      patline_f0.append([''])



      # print('')


   pf_cnt=i
   fwr1 = open(patn_lst[10].strip('"')+'_bi.txt',"w")
   fwr1.write('IDX   LABEL PC UI CLKT   CS0   CS1   CA WCKT RDQS0   RDQS1 DMI0 DMI1 DATAe DATAo \n')
   for i in range(pf_cnt):
      # print(patline_f0[i])
      fwr1.write(patline_f0[i])
      fwr1.write('\n')
   fwr1.close

