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
filename_org=['']*270
file_cnt=0



path = 'C:\\Users\\mano.hong\\Desktop\\8.5G_APEX_DSOL_PATN\\OY211206\\'
# print(path)
#path="./T5511/Dsol_200109/X16_8BANK_R21/"
file_list = os.listdir(path)
print(file_list)
#path = "./T5511/Dsol_191226/*k*.asc"
#file_list = glob.glob(path)

for i in range(len(file_list)):
   if file_list[i][file_list[i].find(".asc")-3:file_list[i].find(".asc")-2]=="h":
      filename_org[file_cnt]=file_list[i]
      file_cnt=file_cnt+1
      # print(file_list[i])
#  print(file_list[i][file_list[i].find("PDBS"):])
#  print(file_list[i][file_list[i].find(".asc"):])


##HSDO_XOR

XORFLG=1


LP5_CMD=[
   'A0ACT112','B0ACT112','C0ACT112','D0ACT112','A1ACT112','B1ACT112','C1ACT112','D1ACT112','A2ACT112','B2ACT112','C2ACT112','D2ACT112','A3ACT112','B3ACT112','C3ACT112','D3ACT112',
   'A0ACT113','B0ACT113','C0ACT113','D0ACT113','A1ACT113','B1ACT113','C1ACT113','D1ACT113','A2ACT113','B2ACT113','C2ACT113','D2ACT113','A3ACT113','B3ACT113','C3ACT113','D3ACT113',
   'A0ACT114','B0ACT114','C0ACT114','D0ACT114','A1ACT114','B1ACT114','C1ACT114','D1ACT114','A2ACT114','B2ACT114','C2ACT114','D2ACT114','A3ACT114','B3ACT114','C3ACT114','D3ACT114',
   'A0WR12','B0WR12','C0WR12','D0WR12','A1WR12','B1WR12','C1WR12','D1WR12','A2WR12','B2WR12','C2WR12','D2WR12','A3WR12','B3WR12','C3WR12','D3WR12',
   'A0WR13','B0WR13','C0WR13','D0WR13','A1WR13','B1WR13','C1WR13','D1WR13','A2WR13','B2WR13','C2WR13','D2WR13','A3WR13','B3WR13','C3WR13','D3WR13',
   'A0WR14','B0WR14','C0WR14','D0WR14','A1WR14','B1WR14','C1WR14','D1WR14','A2WR14','B2WR14','C2WR14','D2WR14','A3WR14','B3WR14','C3WR14','D3WR14',
   'A0WMR12','B0WMR12','C0WMR12','D0WMR12','A1WMR12','B1WMR12','C1WMR12','D1WMR12','A2WMR12','B2WMR12','C2WMR12','D2WMR12','A3WMR12','B3WMR12','C3WMR12','D3WMR12',
   'A0WMR13','B0WMR13','C0WMR13','D0WMR13','A1WMR13','B1WMR13','C1WMR13','D1WMR13','A2WMR13','B2WMR13','C2WMR13','D2WMR13','A3WMR13','B3WMR13','C3WMR13','D3WMR13',
   'A0WMR14','B0WMR14','C0WMR14','D0WMR14','A1WMR14','B1WMR14','C1WMR14','D1WMR14','A2WMR14','B2WMR14','C2WMR14','D2WMR14','A3WMR14','B3WMR14','C3WMR14','D3WMR14',
   'A0WRL12','B0WRL12','C0WRL12','D0WRL12','A1WRL12','B1WRL12','C1WRL12','D1WRL12','A2WRL12','B2WRL12','C2WRL12','D2WRL12','A3WRL12','B3WRL12','C3WRL12','D3WRL12', 
   'A0WRL13','B0WRL13','C0WRL13','D0WRL13','A1WRL13','B1WRL13','C1WRL13','D1WRL13','A2WRL13','B2WRL13','C2WRL13','D2WRL13','A3WRL13','B3WRL13','C3WRL13','D3WRL13', 
   'A0WRL14','B0WRL14','C0WRL14','D0WRL14','A1WRL14','B1WRL14','C1WRL14','D1WRL14','A2WRL14','B2WRL14','C2WRL14','D2WRL14','A3WRL14','B3WRL14','C3WRL14','D3WRL14', 
   'A0RD12','B0RD12','C0RD12','D0RD12','A1RD12','B1RD12','C1RD12','D1RD12','A2RD12','B2RD12','C2RD12','D2RD12','A3RD12','B3RD12','C3RD12','D3RD12',
   'A0RD13','B0RD13','C0RD13','D0RD13','A1RD13','B1RD13','C1RD13','D1RD13','A2RD13','B2RD13','C2RD13','D2RD13','A3RD13','B3RD13','C3RD13','D3RD13',
   'A0RD14','B0RD14','C0RD14','D0RD14','A1RD14','B1RD14','C1RD14','D1RD14','A2RD14','B2RD14','C2RD14','D2RD14','A3RD14','B3RD14','C3RD14','D3RD14',
   'A0RDL12','B0RDL12','C0RDL12','D0RDL12','A1RDL12','B1RDL12','C1RDL12','D1RDL12','A2RDL12','B2RDL12','C2RDL12','D2RDL12','A3RDL12','B3RDL12','C3RDL12','D3RDL12', 
   'A0RDL13','B0RDL13','C0RDL13','D0RDL13','A1RDL13','B1RDL13','C1RDL13','D1RDL13','A2RDL13','B2RDL13','C2RDL13','D2RDL13','A3RDL13','B3RDL13','C3RDL13','D3RDL13', 
   'A0RDL14','B0RDL14','C0RDL14','D0RDL14','A1RDL14','B1RDL14','C1RDL14','D1RDL14','A2RDL14','B2RDL14','C2RDL14','D2RDL14','A3RDL14','B3RDL14','C3RDL14','D3RDL14', 
   'A0PRE12','B0PRE12','C0PRE12','D0PRE12','A1PRE12','B1PRE12','C1PRE12','D1PRE12','A2PRE12','B2PRE12','C2PRE12','D2PRE12','A3PRE12','B3PRE12','C3PRE12','D3PRE12',
   'A0PRE13','B0PRE13','C0PRE13','D0PRE13','A1PRE13','B1PRE13','C1PRE13','D1PRE13','A2PRE13','B2PRE13','C2PRE13','D2PRE13','A3PRE13','B3PRE13','C3PRE13','D3PRE13', 
   'A0PRE14','B0PRE14','C0PRE14','D0PRE14','A1PRE14','B1PRE14','C1PRE14','D1PRE14','A2PRE14','B2PRE14','C2PRE14','D2PRE14','A3PRE14','B3PRE14','C3PRE14','D3PRE14', 
   'A0PBR12','B0PBR12','C0PBR12','D0PBR12','A1PBR12','B1PBR12','C1PBR12','D1PBR12','A2PBR12','B2PBR12','C2PBR12','D2PBR12','A3PBR12','B3PBR12','C3PBR12','D3PBR12', 
   'A0PBR13','B0PBR13','C0PBR13','D0PBR13','A1PBR13','B1PBR13','C1PBR13','D1PBR13','A2PBR13','B2PBR13','C2PBR13','D2PBR13','A3PBR13','B3PBR13','C3PBR13','D3PBR13', 
   'A0PBR14','B0PBR14','C0PBR14','D0PBR14','A1PBR14','B1PBR14','C1PBR14','D1PBR14','A2PBR14','B2PBR14','C2PBR14','D2PBR14','A3PBR14','B3PBR14','C3PBR14','D3PBR14',  
   'PDX'
    ]
    
LP5_CMD_13=[
   'MPC1','MPC3','MRW11','MRW13','MRW21','MRW23','MRW11A','MRW13A','MRW21A','MRW23A','MRR1','MRR3','TMRS11','TMRS13','TMRS21','TMRS23','TMRS23P',
   'A0ACT11','B0ACT11','C0ACT11','D0ACT11','A1ACT11','B1ACT11','C1ACT11','D1ACT11','A2ACT11','B2ACT11','C2ACT11','D2ACT11','A3ACT11','B3ACT11','C3ACT11','D3ACT11',
   'A0ACT13','B0ACT13','C0ACT13','D0ACT13','A1ACT13','B1ACT13','C1ACT13','D1ACT13','A2ACT13','B2ACT13','C2ACT13','D2ACT13','A3ACT13','B3ACT13','C3ACT13','D3ACT13',
   'A0ACT21','B0ACT21','C0ACT21','D0ACT21','A1ACT21','B1ACT21','C1ACT21','D1ACT21','A2ACT21','B2ACT21','C2ACT21','D2ACT21','A3ACT21','B3ACT21','C3ACT21','D3ACT21',
   'A0ACT23','B0ACT23','C0ACT23','D0ACT23','A1ACT23','B1ACT23','C1ACT23','D1ACT23','A2ACT23','B2ACT23','C2ACT23','D2ACT23','A3ACT23','B3ACT23','C3ACT23','D3ACT23',
   'A0WR1','B0WR1','C0WR1','D0WR1','A1WR1','B1WR1','C1WR1','D1WR1','A2WR1','B2WR1','C2WR1','D2WR1','A3WR1','B3WR1','C3WR1','D3WR1',
   'A0WR3','B0WR3','C0WR3','D0WR3','A1WR3','B1WR3','C1WR3','D1WR3','A2WR3','B2WR3','C2WR3','D2WR3','A3WR3','B3WR3','C3WR3','D3WR3',
   'A0WMR1','B0WMR1','C0WMR1','D0WMR1','A1WMR1','B1WMR1','C1WMR1','D1WMR1','A2WMR1','B2WMR1','C2WMR1','D2WMR1','A3WMR1','B3WMR1','C3WMR1','D3WMR1',
   'A0WRA3','B0WRA3','C0WRA3','D0WRA3','A1WRA3','B1WRA3','C1WRA3','D1WRA3','A2WRA3','B2WRA3','C2WRA3','D2WRA3','A3WRA3','B3WRA3','C3WRA3','D3WRA3',
   'A0WRL1','B0WRL1','C0WRL1','D0WRL1','A1WRL1','B1WRL1','C1WRL1','D1WRL1','A2WRL1','B2WRL1','C2WRL1','D2WRL1','A3WRL1','B3WRL1','C3WRL1','D3WRL1',
   'A0WRL3','B0WRL3','C0WRL3','D0WRL3','A1WRL3','B1WRL3','C1WRL3','D1WRL3','A2WRL3','B2WRL3','C2WRL3','D2WRL3','A3WRL3','B3WRL3','C3WRL3','D3WRL3',
   'A0WRLA3','B0WRLA3','C0WRLA3','D0WRLA3','A1WRLA3','B1WRLA3','C1WRLA3','D1WRLA3','A2WRLA3','B2WRLA3','C2WRLA3','D2WRLA3','A3WRLA3','B3WRLA3','C3WRLA3','D3WRLA3',
   'CASWRS1','CASRDS1','CASECS1','CASOFF1','CASDUM1','CAS3','CASX3',
   'A0RD1','B0RD1','C0RD1','D0RD1','A1RD1','B1RD1','C1RD1','D1RD1','A2RD1','B2RD1','C2RD1','D2RD1','A3RD1','B3RD1','C3RD1','D3RD1',
   'A0RD3','B0RD3','C0RD3','D0RD3','A1RD3','B1RD3','C1RD3','D1RD3','A2RD3','B2RD3','C2RD3','D2RD3','A3RD3','B3RD3','C3RD3','D3RD3',
   'A0RDA3','B0RDA3','C0RDA3','D0RDA3','A1RDA3','B1RDA3','C1RDA3','D1RDA3','A2RDA3','B2RDA3','C2RDA3','D2RDA3','A3RDA3','B3RDA3','C3RDA3','D3RDA3',
   'A0RDL1','B0RDL1','C0RDL1','D0RDL1','A1RDL1','B1RDL1','C1RDL1','D1RDL1','A2RDL1','B2RDL1','C2RDL1','D2RDL1','A3RDL1','B3RDL1','C3RDL1','D3RDL1',
   'A0RDL3','B0RDL3','C0RDL3','D0RDL3','A1RDL3','B1RDL3','C1RDL3','D1RDL3','A2RDL3','B2RDL3','C2RDL3','D2RDL3','A3RDL3','B3RDL3','C3RDL3','D3RDL3',
   'A0RDLA3','B0RDLA3','C0RDLA3','D0RDLA3','A1RDLA3','B1RDLA3','C1RDLA3','D1RDLA3','A2RDLA3','B2RDLA3','C2RDLA3','D2RDLA3','A3RDLA3','B3RDLA3','C3RDLA3','D3RDLA3',
   'A0PRE1','B0PRE1','C0PRE1','D0PRE1','A1PRE1','B1PRE1','C1PRE1','D1PRE1','A2PRE1','B2PRE1','C2PRE1','D2PRE1','A3PRE1','B3PRE1','C3PRE1','D3PRE1',
   'A0PRE3','B0PRE3','C0PRE3','D0PRE3','A1PRE3','B1PRE3','C1PRE3','D1PRE3','A2PRE3','B2PRE3','C2PRE3','D2PRE3','A3PRE3','B3PRE3','C3PRE3','D3PRE3',
   'PREA1','PREA3','SRE1','SRE3','DSM3','SRPDE3','SRX1','SRX3','PDE11','PDE13','PDE21','PDE23','PD211','PD213','PD221','PD223','CBR1','CBR3',
   'A0PBR1','B0PBR1','C0PBR1','D0PBR1','A1PBR1','B1PBR1','C1PBR1','D1PBR1','A2PBR1','B2PBR1','C2PBR1','D2PBR1','A3PBR1','B3PBR1','C3PBR1','D3PBR1',
   'A0PBR3','B0PBR3','C0PBR3','D0PBR3','A1PBR3','B1PBR3','C1PBR3','D1PBR3','A2PBR3','B2PBR3','C2PBR3','D2PBR3','A3PBR3','B3PBR3','C3PBR3','D3PBR3',
   'WFF1','WFF3','RFF1','RFF3','RDC1','RDC3'
   ]

LP5_CMD_02=[
   'MPC0','MPC2','MRW10','MRW12','MRW20','MRW22','MRW11A','MRW13A','MRW21A','MRW23A','MRR0','MRR2','TMRS10','TMRS12','TMRS20','TMRS22','TMRS22P',
   'A0ACT10','B0ACT10','C0ACT10','D0ACT10','A1ACT10','B1ACT10','C1ACT10','D1ACT10','A2ACT10','B2ACT10','C2ACT10','D2ACT10','A3ACT10','B3ACT10','C3ACT10','D3ACT10',
   'A0ACT12','B0ACT12','C0ACT12','D0ACT12','A1ACT12','B1ACT12','C1ACT12','D1ACT12','A2ACT12','B2ACT12','C2ACT12','D2ACT12','A3ACT12','B3ACT12','C3ACT12','D3ACT12',
   'A0ACT20','B0ACT20','C0ACT20','D0ACT20','A1ACT20','B1ACT20','C1ACT20','D1ACT20','A2ACT20','B2ACT20','C2ACT20','D2ACT20','A3ACT20','B3ACT20','C3ACT20','D3ACT20',
   'A0ACT22','B0ACT22','C0ACT22','D0ACT22','A1ACT22','B1ACT22','C1ACT22','D1ACT22','A2ACT22','B2ACT22','C2ACT22','D2ACT22','A3ACT22','B3ACT22','C3ACT22','D3ACT22',
   'A0WR0','B0WR0','C0WR0','D0WR0','A1WR0','B1WR0','C1WR0','D1WR0','A2WR0','B2WR0','C2WR0','D2WR0','A3WR0','B3WR0','C3WR0','D3WR0',
   'A0WR2','B0WR2','C0WR2','D0WR2','A1WR2','B1WR2','C1WR2','D1WR2','A2WR2','B2WR2','C2WR2','D2WR2','A3WR2','B3WR2','C3WR2','D3WR2',
   'A0WMR0','B0WMR0','C0WMR0','D0WMR0','A1WMR0','B1WMR0','C1WMR0','D1WMR0','A2WMR0','B2WMR0','C2WMR0','D2WMR0','A3WMR0','B3WMR0','C3WMR0','D3WMR0',
   'A0WRA2','B0WRA2','C0WRA2','D0WRA2','A1WRA2','B1WRA2','C1WRA2','D1WRA2','A2WRA2','B2WRA2','C2WRA2','D2WRA2','A3WRA2','B3WRA2','C3WRA2','D3WRA2',
   'A0WRL0','B0WRL0','C0WRL0','D0WRL0','A1WRL0','B1WRL0','C1WRL0','D1WRL0','A2WRL0','B2WRL0','C2WRL0','D2WRL0','A3WRL0','B3WRL0','C3WRL0','D3WRL0',
   'A0WRL2','B0WRL2','C0WRL2','D0WRL2','A1WRL2','B1WRL2','C1WRL2','D1WRL2','A2WRL2','B2WRL2','C2WRL2','D2WRL2','A3WRL2','B3WRL2','C3WRL2','D3WRL2',
   'A0WRLA2','B0WRLA2','C0WRLA2','D0WRLA2','A1WRLA2','B1WRLA2','C1WRLA2','D1WRLA2','A2WRLA2','B2WRLA2','C2WRLA2','D2WRLA2','A3WRLA2','B3WRLA2','C3WRLA2','D3WRLA2',
   'CASWRS0','CASRDS0','CASECS0','CASOFF0','CASDUM0','CAS2','CASX2',
   'A0RD0','B0RD0','C0RD0','D0RD0','A1RD0','B1RD0','C1RD0','D1RD0','A2RD0','B2RD0','C2RD0','D2RD0','A3RD0','B3RD0','C3RD0','D3RD0',
   'A0RD2','B0RD2','C0RD2','D0RD2','A1RD2','B1RD2','C1RD2','D1RD2','A2RD2','B2RD2','C2RD2','D2RD2','A3RD2','B3RD2','C3RD2','D3RD2',
   'A0RDA2','B0RDA2','C0RDA2','D0RDA2','A1RDA2','B1RDA2','C1RDA2','D1RDA2','A2RDA2','B2RDA2','C2RDA2','D2RDA2','A3RDA2','B3RDA2','C3RDA2','D3RDA2',
   'A0RDL0','B0RDL0','C0RDL0','D0RDL0','A1RDL0','B1RDL0','C1RDL0','D1RDL0','A2RDL0','B2RDL0','C2RDL0','D2RDL0','A3RDL0','B3RDL0','C3RDL0','D3RDL0',
   'A0RDL2','B0RDL2','C0RDL2','D0RDL2','A1RDL2','B1RDL2','C1RDL2','D1RDL2','A2RDL2','B2RDL2','C2RDL2','D2RDL2','A3RDL2','B3RDL2','C3RDL2','D3RDL2',
   'A0RDLA2','B0RDLA2','C0RDLA2','D0RDLA2','A1RDLA2','B1RDLA2','C1RDLA2','D1RDLA2','A2RDLA2','B2RDLA2','C2RDLA2','D2RDLA2','A3RDLA2','B3RDLA2','C3RDLA2','D3RDLA2',
   'A0PRE0','B0PRE0','C0PRE0','D0PRE0','A1PRE0','B1PRE0','C1PRE0','D1PRE0','A2PRE0','B2PRE0','C2PRE0','D2PRE0','A3PRE0','B3PRE0','C3PRE0','D3PRE0',
   'A0PRE2','B0PRE2','C0PRE2','D0PRE2','A1PRE2','B1PRE2','C1PRE2','D1PRE2','A2PRE2','B2PRE2','C2PRE2','D2PRE2','A3PRE2','B3PRE2','C3PRE2','D3PRE2',
   'PREA0','PREA2','SRE0','SRE2','DSM2','SRPDE2','SRX0','SRX2','PDE10','PDE12','PDE20','PDE22','PD210','PD212','PD220','PD222','CBR0','CBR2',
   'A0PBR0','B0PBR0','C0PBR0','D0PBR0','A1PBR0','B1PBR0','C1PBR0','D1PBR0','A2PBR0','B2PBR0','C2PBR0','D2PBR0','A3PBR0','B3PBR0','C3PBR0','D3PBR0',
   'A0PBR2','B0PBR2','C0PBR2','D0PBR2','A1PBR2','B1PBR2','C1PBR2','D1PBR2','A2PBR2','B2PBR2','C2PBR2','D2PBR2','A3PBR2','B3PBR2','C3PBR2','D3PBR2',
   'WFF0','WFF2','RFF0','RFF2','RDC0','RDC2'
   ]

LP5_CMD_WR0=[
   'A0WR0','B0WR0','C0WR0','D0WR0','A1WR0','B1WR0','C1WR0','D1WR0','A2WR0','B2WR0','C2WR0','D2WR0','A3WR0','B3WR0','C3WR0','D3WR0',
   'A0WMR0','B0WMR0','C0WMR0','D0WMR0','A1WMR0','B1WMR0','C1WMR0','D1WMR0','A2WMR0','B2WMR0','C2WMR0','D2WMR0','A3WMR0','B3WMR0','C3WMR0','D3WMR0',
   'A0WRL0','B0WRL0','C0WRL0','D0WRL0','A1WRL0','B1WRL0','C1WRL0','D1WRL0','A2WRL0','B2WRL0','C2WRL0','D2WRL0','A3WRL0','B3WRL0','C3WRL0','D3WRL0',
   'WFF0',
   'A0WR1','B0WR1','C0WR1','D0WR1','A1WR1','B1WR1','C1WR1','D1WR1','A2WR1','B2WR1','C2WR1','D2WR1','A3WR1','B3WR1','C3WR1','D3WR1',
   'A0WMR1','B0WMR1','C0WMR1','D0WMR1','A1WMR1','B1WMR1','C1WMR1','D1WMR1','A2WMR1','B2WMR1','C2WMR1','D2WMR1','A3WMR1','B3WMR1','C3WMR1','D3WMR1',
   'A0WRL1','B0WRL1','C0WRL1','D0WRL1','A1WRL1','B1WRL1','C1WRL1','D1WRL1','A2WRL1','B2WRL1','C2WRL1','D2WRL1','A3WRL1','B3WRL1','C3WRL1','D3WRL1',
   'WFF1'
   ]

LP5_CMD_RD0=[
   'A0RD0','B0RD0','C0RD0','D0RD0','A1RD0','B1RD0','C1RD0','D1RD0','A2RD0','B2RD0','C2RD0','D2RD0','A3RD0','B3RD0','C3RD0','D3RD0',
   'A0RDL0','B0RDL0','C0RDL0','D0RDL0','A1RDL0','B1RDL0','C1RDL0','D1RDL0','A2RDL0','B2RDL0','C2RDL0','D2RDL0','A3RDL0','B3RDL0','C3RDL0','D3RDL0',
   'RFF0','RDC0','MRR0',
   'A0RD1','B0RD1','C0RD1','D0RD1','A1RD1','B1RD1','C1RD1','D1RD1','A2RD1','B2RD1','C2RD1','D2RD1','A3RD1','B3RD1','C3RD1','D3RD1',
   'A0RDL1','B0RDL1','C0RDL1','D0RDL1','A1RDL1','B1RDL1','C1RDL1','D1RDL1','A2RDL1','B2RDL1','C2RDL1','D2RDL1','A3RDL1','B3RDL1','C3RDL1','D3RDL1',
   'RFF1','RDC1','MRR1'
   ]
    


LP5_CMD_BN1=[
   'A0ACT112','B0ACT112','C0ACT112','D0ACT112','A1ACT112','B1ACT112','C1ACT112','D1ACT112','A2ACT112','B2ACT112','C2ACT112','D2ACT112','A3ACT112','B3ACT112','C3ACT112','D3ACT112',
   'A0ACT113','B0ACT113','C0ACT113','D0ACT113','A1ACT113','B1ACT113','C1ACT113','D1ACT113','A2ACT113','B2ACT113','C2ACT113','D2ACT113','A3ACT113','B3ACT113','C3ACT113','D3ACT113',
   'A0ACT114','B0ACT114','C0ACT114','D0ACT114','A1ACT114','B1ACT114','C1ACT114','D1ACT114','A2ACT114','B2ACT114','C2ACT114','D2ACT114','A3ACT114','B3ACT114','C3ACT114','D3ACT114',
   'A0WR12','B0WR12','C0WR12','D0WR12','A1WR12','B1WR12','C1WR12','D1WR12','A2WR12','B2WR12','C2WR12','D2WR12','A3WR12','B3WR12','C3WR12','D3WR12',
   'A0WR13','B0WR13','C0WR13','D0WR13','A1WR13','B1WR13','C1WR13','D1WR13','A2WR13','B2WR13','C2WR13','D2WR13','A3WR13','B3WR13','C3WR13','D3WR13',
   'A0WR14','B0WR14','C0WR14','D0WR14','A1WR14','B1WR14','C1WR14','D1WR14','A2WR14','B2WR14','C2WR14','D2WR14','A3WR14','B3WR14','C3WR14','D3WR14',
   'A0WMR12','B0WMR12','C0WMR12','D0WMR12','A1WMR12','B1WMR12','C1WMR12','D1WMR12','A2WMR12','B2WMR12','C2WMR12','D2WMR12','A3WMR12','B3WMR12','C3WMR12','D3WMR12',
   'A0WMR13','B0WMR13','C0WMR13','D0WMR13','A1WMR13','B1WMR13','C1WMR13','D1WMR13','A2WMR13','B2WMR13','C2WMR13','D2WMR13','A3WMR13','B3WMR13','C3WMR13','D3WMR13',
   'A0WMR14','B0WMR14','C0WMR14','D0WMR14','A1WMR14','B1WMR14','C1WMR14','D1WMR14','A2WMR14','B2WMR14','C2WMR14','D2WMR14','A3WMR14','B3WMR14','C3WMR14','D3WMR14',
   'A0WRL12','B0WRL12','C0WRL12','D0WRL12','A1WRL12','B1WRL12','C1WRL12','D1WRL12','A2WRL12','B2WRL12','C2WRL12','D2WRL12','A3WRL12','B3WRL12','C3WRL12','D3WRL12', 
   'A0WRL13','B0WRL13','C0WRL13','D0WRL13','A1WRL13','B1WRL13','C1WRL13','D1WRL13','A2WRL13','B2WRL13','C2WRL13','D2WRL13','A3WRL13','B3WRL13','C3WRL13','D3WRL13', 
   'A0WRL14','B0WRL14','C0WRL14','D0WRL14','A1WRL14','B1WRL14','C1WRL14','D1WRL14','A2WRL14','B2WRL14','C2WRL14','D2WRL14','A3WRL14','B3WRL14','C3WRL14','D3WRL14', 
   'A0RD12','B0RD12','C0RD12','D0RD12','A1RD12','B1RD12','C1RD12','D1RD12','A2RD12','B2RD12','C2RD12','D2RD12','A3RD12','B3RD12','C3RD12','D3RD12',
   'A0RD13','B0RD13','C0RD13','D0RD13','A1RD13','B1RD13','C1RD13','D1RD13','A2RD13','B2RD13','C2RD13','D2RD13','A3RD13','B3RD13','C3RD13','D3RD13',
   'A0RD14','B0RD14','C0RD14','D0RD14','A1RD14','B1RD14','C1RD14','D1RD14','A2RD14','B2RD14','C2RD14','D2RD14','A3RD14','B3RD14','C3RD14','D3RD14',
   'A0RDL12','B0RDL12','C0RDL12','D0RDL12','A1RDL12','B1RDL12','C1RDL12','D1RDL12','A2RDL12','B2RDL12','C2RDL12','D2RDL12','A3RDL12','B3RDL12','C3RDL12','D3RDL12', 
   'A0RDL13','B0RDL13','C0RDL13','D0RDL13','A1RDL13','B1RDL13','C1RDL13','D1RDL13','A2RDL13','B2RDL13','C2RDL13','D2RDL13','A3RDL13','B3RDL13','C3RDL13','D3RDL13', 
   'A0RDL14','B0RDL14','C0RDL14','D0RDL14','A1RDL14','B1RDL14','C1RDL14','D1RDL14','A2RDL14','B2RDL14','C2RDL14','D2RDL14','A3RDL14','B3RDL14','C3RDL14','D3RDL14', 
   'A0PRE12','B0PRE12','C0PRE12','D0PRE12','A1PRE12','B1PRE12','C1PRE12','D1PRE12','A2PRE12','B2PRE12','C2PRE12','D2PRE12','A3PRE12','B3PRE12','C3PRE12','D3PRE12',
   'A0PRE13','B0PRE13','C0PRE13','D0PRE13','A1PRE13','B1PRE13','C1PRE13','D1PRE13','A2PRE13','B2PRE13','C2PRE13','D2PRE13','A3PRE13','B3PRE13','C3PRE13','D3PRE13', 
   'A0PRE14','B0PRE14','C0PRE14','D0PRE14','A1PRE14','B1PRE14','C1PRE14','D1PRE14','A2PRE14','B2PRE14','C2PRE14','D2PRE14','A3PRE14','B3PRE14','C3PRE14','D3PRE14', 
   'A0PBR12','B0PBR12','C0PBR12','D0PBR12','A1PBR12','B1PBR12','C1PBR12','D1PBR12','A2PBR12','B2PBR12','C2PBR12','D2PBR12','A3PBR12','B3PBR12','C3PBR12','D3PBR12', 
   'A0PBR13','B0PBR13','C0PBR13','D0PBR13','A1PBR13','B1PBR13','C1PBR13','D1PBR13','A2PBR13','B2PBR13','C2PBR13','D2PBR13','A3PBR13','B3PBR13','C3PBR13','D3PBR13', 
   'A0PBR14','B0PBR14','C0PBR14','D0PBR14','A1PBR14','B1PBR14','C1PBR14','D1PBR14','A2PBR14','B2PBR14','C2PBR14','D2PBR14','A3PBR14','B3PBR14','C3PBR14','D3PBR14'  
   ]

LP5_CMD_BN0=[
   'A0ACT102','B0ACT102','C0ACT102','D0ACT102','A1ACT102','B1ACT102','C1ACT102','D1ACT102','A2ACT102','B2ACT102','C2ACT102','D2ACT102','A3ACT102','B3ACT102','C3ACT102','D3ACT102',
   'A0ACT103','B0ACT103','C0ACT103','D0ACT103','A1ACT103','B1ACT103','C1ACT103','D1ACT103','A2ACT103','B2ACT103','C2ACT103','D2ACT103','A3ACT103','B3ACT103','C3ACT103','D3ACT103',
   'A0ACT104','B0ACT104','C0ACT104','D0ACT104','A1ACT104','B1ACT104','C1ACT104','D1ACT104','A2ACT104','B2ACT104','C2ACT104','D2ACT104','A3ACT104','B3ACT104','C3ACT104','D3ACT104',
   'A0WR02','B0WR02','C0WR02','D0WR02','A1WR02','B1WR02','C1WR02','D1WR02','A2WR02','B2WR02','C2WR02','D2WR02','A3WR02','B3WR02','C3WR02','D3WR02',
   'A0WR03','B0WR03','C0WR03','D0WR03','A1WR03','B1WR03','C1WR03','D1WR03','A2WR03','B2WR03','C2WR03','D2WR03','A3WR03','B3WR03','C3WR03','D3WR03',
   'A0WR04','B0WR04','C0WR04','D0WR04','A1WR04','B1WR04','C1WR04','D1WR04','A2WR04','B2WR04','C2WR04','D2WR04','A3WR04','B3WR04','C3WR04','D3WR04',
   'A0WMR02','B0WMR02','C0WMR02','D0WMR02','A1WMR02','B1WMR02','C1WMR02','D1WMR02','A2WMR02','B2WMR02','C2WMR02','D2WMR02','A3WMR02','B3WMR02','C3WMR02','D3WMR02',
   'A0WMR03','B0WMR03','C0WMR03','D0WMR03','A1WMR03','B1WMR03','C1WMR03','D1WMR03','A2WMR03','B2WMR03','C2WMR03','D2WMR03','A3WMR03','B3WMR03','C3WMR03','D3WMR03',
   'A0WMR04','B0WMR04','C0WMR04','D0WMR04','A1WMR04','B1WMR04','C1WMR04','D1WMR04','A2WMR04','B2WMR04','C2WMR04','D2WMR04','A3WMR04','B3WMR04','C3WMR04','D3WMR04',
   'A0WRL02','B0WRL02','C0WRL02','D0WRL02','A1WRL02','B1WRL02','C1WRL02','D1WRL02','A2WRL02','B2WRL02','C2WRL02','D2WRL02','A3WRL02','B3WRL02','C3WRL02','D3WRL02', 
   'A0WRL03','B0WRL03','C0WRL03','D0WRL03','A1WRL03','B1WRL03','C1WRL03','D1WRL03','A2WRL03','B2WRL03','C2WRL03','D2WRL03','A3WRL03','B3WRL03','C3WRL03','D3WRL03', 
   'A0WRL04','B0WRL04','C0WRL04','D0WRL04','A1WRL04','B1WRL04','C1WRL04','D1WRL04','A2WRL04','B2WRL04','C2WRL04','D2WRL04','A3WRL04','B3WRL04','C3WRL04','D3WRL04', 
   'A0RD02','B0RD02','C0RD02','D0RD02','A1RD02','B1RD02','C1RD02','D1RD02','A2RD02','B2RD02','C2RD02','D2RD02','A3RD02','B3RD02','C3RD02','D3RD02',
   'A0RD03','B0RD03','C0RD03','D0RD03','A1RD03','B1RD03','C1RD03','D1RD03','A2RD03','B2RD03','C2RD03','D2RD03','A3RD03','B3RD03','C3RD03','D3RD03',
   'A0RD04','B0RD04','C0RD04','D0RD04','A1RD04','B1RD04','C1RD04','D1RD04','A2RD04','B2RD04','C2RD04','D2RD04','A3RD04','B3RD04','C3RD04','D3RD04',
   'A0RDL02','B0RDL02','C0RDL02','D0RDL02','A1RDL02','B1RDL02','C1RDL02','D1RDL02','A2RDL02','B2RDL02','C2RDL02','D2RDL02','A3RDL02','B3RDL02','C3RDL02','D3RDL02', 
   'A0RDL03','B0RDL03','C0RDL03','D0RDL03','A1RDL03','B1RDL03','C1RDL03','D1RDL03','A2RDL03','B2RDL03','C2RDL03','D2RDL03','A3RDL03','B3RDL03','C3RDL03','D3RDL03', 
   'A0RDL04','B0RDL04','C0RDL04','D0RDL04','A1RDL04','B1RDL04','C1RDL04','D1RDL04','A2RDL04','B2RDL04','C2RDL04','D2RDL04','A3RDL04','B3RDL04','C3RDL04','D3RDL04', 
   'A0PRE02','B0PRE02','C0PRE02','D0PRE02','A1PRE02','B1PRE02','C1PRE02','D1PRE02','A2PRE02','B2PRE02','C2PRE02','D2PRE02','A3PRE02','B3PRE02','C3PRE02','D3PRE02',
   'A0PRE03','B0PRE03','C0PRE03','D0PRE03','A1PRE03','B1PRE03','C1PRE03','D1PRE03','A2PRE03','B2PRE03','C2PRE03','D2PRE03','A3PRE03','B3PRE03','C3PRE03','D3PRE03', 
   'A0PRE04','B0PRE04','C0PRE04','D0PRE04','A1PRE04','B1PRE04','C1PRE04','D1PRE04','A2PRE04','B2PRE04','C2PRE04','D2PRE04','A3PRE04','B3PRE04','C3PRE04','D3PRE04', 
   'A0PBR02','B0PBR02','C0PBR02','D0PBR02','A1PBR02','B1PBR02','C1PBR02','D1PBR02','A2PBR02','B2PBR02','C2PBR02','D2PBR02','A3PBR02','B3PBR02','C3PBR02','D3PBR02', 
   'A0PBR03','B0PBR03','C0PBR03','D0PBR03','A1PBR03','B1PBR03','C1PBR03','D1PBR03','A2PBR03','B2PBR03','C2PBR03','D2PBR03','A3PBR03','B3PBR03','C3PBR03','D3PBR03', 
   'A0PBR04','B0PBR04','C0PBR04','D0PBR04','A1PBR04','B1PBR04','C1PBR04','D1PBR04','A2PBR04','B2PBR04','C2PBR04','D2PBR04','A3PBR04','B3PBR04','C3PBR04','D3PBR04'  
   ]
    

ATE_CMD=['NOP','JNC','JSR','JZD','RTN','JET','OUT','JNI1','JNI2','JNI3','JNI4','JNI5','JNI6','JNI7','JNI8','IDXI1','IDXI2','IDXI3','IDXI4','IDXI5','IDXI6','IDXI7','IDXI8','STI','LDI']

ATE_TRA1=['TTESET','TTEGET','TTECAL']
ATE_TRA2=['TTSET','ESRST','TTRST','TTSTR','ESINC','TTCHK']
ATE_ADDR=['XYCLD','XYCLD1','XYCLD2','XYCLD3','XYCLD4','XY2CLD','XY3CLD','XY4CLD','XY2SLD','XY3SLD','XY4SLD','XYSLD2','XYBLD','XYSLD','XYKLD','XTSET','YTSET']

ATE_ADDROP=['X2DEC','X3DEC','X4DEC','YCCLR','BCCLR','BCSCLR','XINC','X2INC','X3INC','X4INC','XDEC','YINC','Y2INC','Y3INC','Y4INC','YDEC','Y2DEC','Y3DEC','Y4DEC','XAD1',
            'XAD2','XAD3','XAD4','XDD1','XDD2','XDD3','XDD4','YAD1ALL','YAD2ALL','YAD3ALL','YAD4ALL','YDD1ALL','YDD2ALL','YDD3ALL','YDD4ALL','YAD1','YAD2','YAD3','YAD4',
            'Y2AD1','Y2AD2','Y2AD3','Y2AD4','Y3AD1','Y3AD2','Y3AD3','Y3AD4','Y4AD1','Y4AD2','Y4AD3','Y4AD4','YDD1','YDD2','YDD3','YDD4','Y2DD1','Y2DD2','Y2DD3','Y2DD4',
            'Y3DD1','Y3DD2','Y3DD3','Y3DD4','Y4DD1','Y4DD2','Y4DD3','Y4DD4','XINS','X2INS','X3INS','X4INS','YINS','XDES','YDES','XAS1','XAS2','XAS3','XAS4','XDS1','XDS2',
            'XDS3','XDS4','YAS1','YAS2','YAS3','YAS4','YDS1','YDS2','YDS3','YDS4','Y2DS4','Y3DS4','Y4DS4','Y2AS4','Y3AS4','Y4AS4','YAB1','YAB2','YDB1','YDB2','XT','YT'
            ]
ATE_ADDROP2=['XC<','XS<','XK<','XB<','XT<','YC<','YS<','YK<','YB<','YT<','XC_','XS_','XK_','XB_','XT_','YC_','YS_','YK_','YB_','YT_','D3<','D4<']
ATE_ADDROP3=['/X','/Y']

ATE_XADDR=['/X','XAD','XDD','XAS','XDS','INI','BCC','XIN','XSI','XSD','XDE','XC<','XS<']
ATE_YADDR=['/Y','YAD','YDD','YAS','YDS','YIN','YDE','YC<','YS<']
ATE_LDQM=['ADQM','FDQM','FDM0','FDM1','LMDA','LDQM','LDMF','LDMS','DMFI','DMAL']
ATE_UDQM=[       'SDQM','SDM0','SDM1','UMDA','UDQM','UDMF','UDMS','DMSE']

ATE_DATA=['TP<TP+1']

T5511_ONLY=[
   'XYCLD3','XYCLD4','XY3CLD','XY4CLD','XY3SLD','XY4SLD'
   'A0ACT113','B0ACT113','C0ACT113','D0ACT113','A1ACT113','B1ACT113','C1ACT113','D1ACT113','A2ACT113','B2ACT113','C2ACT113','D2ACT113','A3ACT113','B3ACT113','C3ACT113','D3ACT113',
   'A0ACT114','B0ACT114','C0ACT114','D0ACT114','A1ACT114','B1ACT114','C1ACT114','D1ACT114','A2ACT114','B2ACT114','C2ACT114','D2ACT114','A3ACT114','B3ACT114','C3ACT114','D3ACT114',
   'A0WR13','B0WR13','C0WR13','D0WR13','A1WR13','B1WR13','C1WR13','D1WR13','A2WR13','B2WR13','C2WR13','D2WR13','A3WR13','B3WR13','C3WR13','D3WR13',
   'A0WR14','B0WR14','C0WR14','D0WR14','A1WR14','B1WR14','C1WR14','D1WR14','A2WR14','B2WR14','C2WR14','D2WR14','A3WR14','B3WR14','C3WR14','D3WR14',
   'A0WMR13','B0WMR13','C0WMR13','D0WMR13','A1WMR13','B1WMR13','C1WMR13','D1WMR13','A2WMR13','B2WMR13','C2WMR13','D2WMR13','A3WMR13','B3WMR13','C3WMR13','D3WMR13',
   'A0WMR14','B0WMR14','C0WMR14','D0WMR14','A1WMR14','B1WMR14','C1WMR14','D1WMR14','A2WMR14','B2WMR14','C2WMR14','D2WMR14','A3WMR14','B3WMR14','C3WMR14','D3WMR14',
   'A0WRL13','B0WRL13','C0WRL13','D0WRL13','A1WRL13','B1WRL13','C1WRL13','D1WRL13','A2WRL13','B2WRL13','C2WRL13','D2WRL13','A3WRL13','B3WRL13','C3WRL13','D3WRL13', 
   'A0WRL14','B0WRL14','C0WRL14','D0WRL14','A1WRL14','B1WRL14','C1WRL14','D1WRL14','A2WRL14','B2WRL14','C2WRL14','D2WRL14','A3WRL14','B3WRL14','C3WRL14','D3WRL14', 
   'A0RD13','B0RD13','C0RD13','D0RD13','A1RD13','B1RD13','C1RD13','D1RD13','A2RD13','B2RD13','C2RD13','D2RD13','A3RD13','B3RD13','C3RD13','D3RD13',
   'A0RD14','B0RD14','C0RD14','D0RD14','A1RD14','B1RD14','C1RD14','D1RD14','A2RD14','B2RD14','C2RD14','D2RD14','A3RD14','B3RD14','C3RD14','D3RD14',
   'A0RDL13','B0RDL13','C0RDL13','D0RDL13','A1RDL13','B1RDL13','C1RDL13','D1RDL13','A2RDL13','B2RDL13','C2RDL13','D2RDL13','A3RDL13','B3RDL13','C3RDL13','D3RDL13', 
   'A0RDL14','B0RDL14','C0RDL14','D0RDL14','A1RDL14','B1RDL14','C1RDL14','D1RDL14','A2RDL14','B2RDL14','C2RDL14','D2RDL14','A3RDL14','B3RDL14','C3RDL14','D3RDL14', 
   'A0PRE13','B0PRE13','C0PRE13','D0PRE13','A1PRE13','B1PRE13','C1PRE13','D1PRE13','A2PRE13','B2PRE13','C2PRE13','D2PRE13','A3PRE13','B3PRE13','C3PRE13','D3PRE13', 
   'A0PRE14','B0PRE14','C0PRE14','D0PRE14','A1PRE14','B1PRE14','C1PRE14','D1PRE14','A2PRE14','B2PRE14','C2PRE14','D2PRE14','A3PRE14','B3PRE14','C3PRE14','D3PRE14', 
   'A0PBR13','B0PBR13','C0PBR13','D0PBR13','A1PBR13','B1PBR13','C1PBR13','D1PBR13','A2PBR13','B2PBR13','C2PBR13','D2PBR13','A3PBR13','B3PBR13','C3PBR13','D3PBR13', 
   'A0PBR14','B0PBR14','C0PBR14','D0PBR14','A1PBR14','B1PBR14','C1PBR14','D1PBR14','A2PBR14','B2PBR14','C2PBR14','D2PBR14','A3PBR14','B3PBR14','C3PBR14','D3PBR14',  
   'X3DEC','X4DEC','X3INC','X4INC','Y3INC','Y4INC','Y3DEC','Y4DEC','YAD1ALL','YAD2ALL','YAD3ALL','YAD4ALL','YDD1ALL','YDD2ALL','YDD3ALL','YDD4ALL',
   'Y3AD1','Y3AD2','Y3AD3','Y3AD4','Y4AD1','Y4AD2','Y4AD3','Y4AD4','Y3DD1','Y3DD2','Y3DD3','Y3DD4','Y4DD1','Y4DD2','Y4DD3','Y4DD4','X3INS','X4INS',
   'Y3DS4','Y4DS4','Y3AS4','Y4AS4',
   ]

need_cas=0
wr_cmd_delay=100

org_num   = 16

#for n_conv in range(1,2): # len(sys.argv)):
for n_conv in range(file_cnt): # len(sys.argv)):

   src_file  = str(path+filename_org[n_conv])
#  src_file  = str(sys.argv[1])
#  org_num   = int(sys.argv[2])
   #dest_file = str(sys.argv[2])
   src_patn=src_file[0:8]
   src = open(src_file, 'r')
   format="UNIX"
#  src2= open(src_file, 'r')
#  src3= open(src_file, 'r')
#  T_Speed=int(sys.argv[2])
   
#  print "Parameter Extracing ",src_file, "..."
   # print("Pattern ........... ",src_file,"...")
    
    
   ## Variable Declaration
   patline=[[],[],[],[],[],[],[],[],[],[]]
   patlinetmp=[]
   patlinetmp2=[""]
   patlinetmp3=[""]
   patlinetmp4=[""]
   patlineway=[]
   patlineway3=[0]
   patlineway4=[0]
   patlineac2=[]
   patlineout=[]
   patline_seq=[[],[],[],[],[],[],[],[],[],[]]
   #cmt_temp=[]
   CMTFLG=0
   pat_temp=[]

   ## START CONVERTING
   
   errflg=0
   warnflg=0
   ## READ SOURCE PATTERN
   pname_flg=0
   linecnt=0
   lineoutcnt=0
   lineoutend=0
   lineendcnt=0
   startcheck=0
   patmain=1  # 0 patt  1 insert
   waycnt=0
   moveop0=0
   moveop1=0
   i=0
   templine2=""
   headermb=0

   lineway01=""
   lineway02=""
   lineway03=""
   lineway04=""
   lineway05=""
   lineway06=""
   lineway07=""
   lineway08=""
   lineway09=""
   lineway10=""
   lineway11=""
   lineway12=""
   lineway13=""
   lineway14=""
   lineway15=""
   lineway16=""

   for line in src:
      templine=line
      temp=line.split()
      if startcheck==0:
         if(line[0:5]=='START'):
            startcheck=1
         patlineway.append([])
         patlineway[lineoutcnt]=0
      elif startcheck==1:
         if len(temp)>2:
            if temp[0][0]!=";":
               if temp[0] in ATE_CMD or temp[1] in ATE_CMD:
                  waycnt=1
               else:
                  waycnt=waycnt+1
               patlineway.append([])
               patlineway[lineoutcnt]=waycnt
            else:
               patlineway.append([])
               patlineway[lineoutcnt]=0
         else:
            patlineway.append([])
            patlineway[lineoutcnt]=0
      else:
         patline.append([])
         patline[linecnt].append(temp)
         patlineway.append([])
         patlineway[lineoutcnt]=0
         linecnt=linecnt+1

      patlinetmp2.append("")
      patlinetmp3.append("")
      patlinetmp4.append("")
      patlineway3.append(0)
      patlineway4.append(0)
      patlinetmp2[lineoutcnt]=templine
      
      i=i+1
#      print("temp ",templine,end="")
#      print("save ",patlinetmp[lineoutcnt][0][0:len(templine)-1]," __ ",len(templine),len(patlinetmp[lineoutcnt][0]))
      lineoutcnt=lineoutcnt+1

#      else:
      
#      print linecnt,' ',patline[linecnt][0]

   patlinetmp2.append("")
   patlinetmp3.append("")
   patlinetmp4.append("")
   patlineway3.append(0)
   patlineway4.append(0)
   patlinetmp2[lineoutcnt]="\n"
   patlineway.append([])
   patlineway[lineoutcnt]=0
   lineoutcnt=lineoutcnt+1
   patlinetmp2.append("")
   patlinetmp3.append("")
   patlinetmp4.append("")
   patlineway3.append(0)
   patlineway4.append(0)
   patlinetmp2[lineoutcnt]="\n"
   patlineway.append([])
   patlineway[lineoutcnt]=0
   lineoutcnt=lineoutcnt+1

   lineoutend=lineoutcnt

   patword=[""]
   patlabel=[""]
   patwordcnt=1
   patlabelcnt=1
   bankmode=0

   patdelay=0  # WR2 to real WR data

   src.close()

   linecnt=1
   startcheck=0
   previousline="" 
   nextlinewr=0
   wayevenop=0
   wayoddop=0
   
   moveup_ok=0
   movedn_ok=0
   

   templineway =["","","","","","","","","","","","","","","","","",""]
   templineway2=["","","","","","","","","","","","","","","","","",""]
   tempwaymove =[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

   tempwaymv=[[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
   tempwaymv[0]  =[0,0,0,0,0,0,0,0,0]
   tempwaymv[1]  =[0,0,0,0,0,0,0,0,0]
   tempwaymv[3]  =[0,0,0,0,0,0,0,0,0]
   tempwaymv[5]  =[0,0,0,0,0,0,0,0,0]
   tempwaymv[7]  =[0,0,0,0,0,0,0,0,0]
   tempwaymv[9]  =[0,0,0,0,0,0,0,0,0]
   tempwaymv[11] =[0,0,0,0,0,0,0,0,0]
   tempwaymv[13] =[0,0,0,0,0,0,0,0,0]
   tempwaymv[15] =[0,0,0,0,0,0,0,0,0]

   tempwaymv[2]  =[0,3,5,7,9,11,13,15,1]
   tempwaymv[4]  =[0,5,7,3,9,1,11,13,15]
   tempwaymv[6]  =[0,7,9,5,11,3,13,1,15]
   tempwaymv[8]  =[0,9,11,7,13,5,15,3,1]
   tempwaymv[10] =[0,11,13,9,15,7,5,3,1]
   tempwaymv[12] =[0,13,15,11,9,7,5,3,1]
   tempwaymv[14] =[0,15,13,11,9,7,5,3,1]
   tempwaymv[16] =[0,15,13,11,9,7,5,3,1]
   tempwaymvuse =[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

   findmvword=["","","","","","","","","",""]

   fwr1 = open("nne2","w")
   
   icnt=1
   
#####  if patlinetmp3[ii].find("START")>-1 and patlinetmp3[ii].find("#00")>-1:
#####     startchk=1
#####  if patlinetmp3[ii].find("MODULE")>-1 and patlinetmp3[ii].find("END")>-1:
#####     endchk=1
#####  if startchk==1 and endchk==0 and len(patlinetmp3[ii].split())==0:
#####     k=-1
#####  else:
#####
   startchk=0
   endchk=0
   templine2=""
   mbegin=0
   rster=0
   freerun=0
   linuxrt=patlinetmp2[0][len(patlinetmp2[0])-1]
   patspeed=""
   bankmode="0"
   ckr=4
   ckloc=0 
   hsdootf=0   
   tmode="NN"


   if src_file.find("\\w")>0 or src_file.find("\\a")>0 or src_file.find("\\tw")>0   :  freerun=1
   if src_file.find("\\wd")>0 or src_file.find("\\twd")>0 or src_file.find("\\td")>0 or src_file.find("\\d")>0  or src_file.find("\\ad")>0  :  ckr=2
   elif src_file.find("\\twq")>0 or src_file.find("\\tq")>0 or src_file.find("\\wq")>0 or src_file.find("\\q")>0  or src_file.find("\\aq")>0  :  ckr=4
   
   if src_file.find("\\t")>0  :  hsdootf=1

#   print(src_file," ",src_file.find("\\ad"),ckr,freerun)

   for i in range(lineoutend-100,lineoutend-70):
      # print(lineoutend)
      templine=patlinetmp2[i]
      # print(i,templine)
      temp=templine.split()
      if len(temp)>1 and templine.find("CLK")>-1 and ckloc==0:
         ckloc=templine.find("CLK")



   for i in range(0,lineoutend):
#      if patlinetmp2[i].find("START")>-1 and patlinetmp2[i].find("#00")>-1:
#         startchk=1
#      if patlinetmp2[i].find("MODULE")>-1 and patlinetmp2[i].find("END")>-1:
#         endchk=1
      templine=patlinetmp2[i]
      temp=templine.split()
      if startchk==0:
         if len(temp)==1:
            if temp[0]=="REGISTER":
               rster=1
         if len(temp)>1:
            if templine.find("MPAT")>-1:
               if temp[1][0]=="W" or temp[1][0]=="A":
                  freerun=1
                  wfr="F"
                  tmp3=temp[1][1:len(temp[1])]
               elif temp[1][0:2]=="TW" or temp[1][0:2]=="TA":
                  freerun=1
                  wfr="F"
                  tmp3=temp[1][2:len(temp[1])]
               elif temp[1][0]=="T":
                  wfr="S"
                  tmp3=temp[1][1:len(temp[1])]
               else:
                  tmp3=temp[1]
                  wfr="S"
                  
               if tmp3[1]=="4":
                  bankmode="4" #4BG
               if tmp3[1]=="F":
                  bankmode="6" #16B
               if tmp3[1]=="8":
                  bankmode="8" #8B
               
               if tmp3[6]=="5" and tmp3[8]=="5":
                  patspeed="5K5"
               elif tmp3[6]=="7" and tmp3[8]=="5":
                  patspeed="7K5"
               elif tmp3[6]=="6" and tmp3[8]=="4":
                  patspeed="6K4"
               elif tmp3[6]=="4" and tmp3[8]=="2":
                  patspeed="4K2"
               elif tmp3[6]=="3" and tmp3[8]=="7":
                  patspeed="3K7"
               elif tmp3[6]=="3" and tmp3[8]=="2":
                  patspeed="3K2"
                  if temp[1][1]=="D":
                     wfr="R"
                  if tmp3[1]=="4":
                     bankmode="6" #4BG
               elif tmp3[6]=="1" and tmp3[8]=="6":
                  patspeed="1K6"
                  if temp[1][1]=="D":
                     wfr="R"
                  if tmp3[1]=="4":
                     bankmode="6" #4BG
                  
               elif tmp3[6]=="5" and tmp3[7]=="3" and tmp3[8]=="3":
                  patspeed="0K5"
                  tmp3[6]=="0"
                  tmp3[8]=="5"
                  
               if hsdootf==1 : tmode="NF"
               
               tmp1=path+"PDCS"+bankmode+wfr+tmp3[3:6]+tmp3[6]+tmp3[2]+tmp3[8:10]+tmode
               tmp1a="PDCS"+bankmode+wfr+tmp3[3:6]+tmp3[6]+tmp3[2]+tmp3[8:10]+tmode
               # print(path)
               if org_num==8: tmp1=path+"PD3S"+bankmode+wfr+tmp3[3:6]+tmp3[6]+tmp3[2]+tmp3[8:10]+tmode
               
#               if tmp1[10]=="N":
#                  tmp2=tmp1[0:10]+"K"+tmp1[11:len(tmp1)]
#                  tmp1=tmp2
               templine2=temp[0]+"    "+tmp1a+" ; "+temp[1]+templine[len(templine)-1]
               print(tmp1a,templine2,end="")
               tmp_fname=tmp1
               fwr1 = open(tmp1+".asc","w")
               fwr1.write(templine2)
#               print(templine2,end="")
               patlinetmp2[i]=templine2
            elif rster==0 and mbegin==1:
               templine2="    "+temp[0]+" "+temp[1]+templine[templine.find(temp[1])+len(temp[1]):len(templine)]
#               print(templine2,end="")
               fwr1.write(templine2)
               patlinetmp2[i]=templine2
            
            elif temp[0]=="INSERT":
               templine2="    "+temp[0]+" "+temp[1]+templine[templine.find(temp[1])+len(temp[1]):len(templine)]
#               print(templine2,end="")
               fwr1.write(templine2)
               patlinetmp2[i]=templine2               
            elif patlinetmp2[i].find("MODULE")>-1 and patlinetmp2[i].find("BEGIN")>-1:
               mbegin=1
               templine2=temp[0]+" "+temp[1]+templine[templine.find(temp[1])+len(temp[1]):len(templine)]
#               print(templine2,end="")
               fwr1.write(templine2)
               patlinetmp2[i]=templine2
         
            elif (temp[0].find("=")>-1 or temp[1].find("=")>-1) and startchk==0:
               # print(temp)
               if temp[1][0]==";":
                  tmp1=temp[0][0:temp[0].find("=")]
                  tmp2=temp[0][temp[0].find("=")+1:len(temp[0])]
                  templine2="    "+tmp1+" "*(7-len(tmp1))+"= "+tmp2+" "*(12-len(tmp2))+templine[templine.find(";"):len(templine)]
#                  print(templine2,end="")
                  fwr1.write(templine2)
                  patlinetmp2[i]=templine2
               elif temp[2][0]==";":
                  if temp[0][len(temp[0])-1]=="=":
                     tmp1=temp[0][0:temp[0].find("=")]
                     tmp2=temp[1]
                     templine2="    "+tmp1+" "*(7-len(tmp1))+"= "+tmp2+" "*(12-len(tmp2))+templine[templine.find(";"):len(templine)]
#                     print(templine2,end="")
                     fwr1.write(templine2)
                     patlinetmp2[i]=templine2
                  elif temp[1][0]=="=":
                     tmp1=temp[0]
                     tmp2=temp[1][1:len(temp[1])]
                     templine2="    "+tmp1+" "*(7-len(tmp1))+"= "+tmp2+" "*(12-len(tmp2))+templine[templine.find(";"):len(templine)]
#                     print(templine2,end="")
                     fwr1.write(templine2)
                     patlinetmp2[i]=templine2

               elif temp[1]=="=":
                  tmp1=temp[0]
                  tmp2=temp[2]
                  templine2="    "+tmp1+" "*(7-len(tmp1))+"= "+tmp2+" "*(12-len(tmp2))+templine[templine.find(";"):len(templine)]
#                  print(templine2,end="")
                  fwr1.write(templine2)
                  patlinetmp2[i]=templine2

            
            elif patlinetmp2[i].find("START")>-1 and patlinetmp2[i].find("#00")>-1:
               startchk=1
               templine2="START  #00"+templine[templine.find("#00")+3:len(templine)]
               patlinetmp2[i]=templine2
               tmp1=templine[len(templine)-1]
#               print(templine2,end="")
               fwr1.write(templine2)
               if patspeed=="7K5" or patspeed=="6K4" or patspeed=="5K5" or patspeed=="4K2" or patspeed=="3K7":   
#                  print("    INSERT TESTMRSSETCKR4",tmp1,end="")
                  fwr1.write("    INSERT WHTMRSSETCKR4\n")
                  fwr1.write(tmp1)
               elif patspeed=="3K2" or patspeed=="1K6":   
                  if ckr==2:
#                     print("    INSERT TESTMRSSETCKR2",tmp1,end="")
                     fwr1.write("    INSERT WHTMRSSETCKR2\n")
                     fwr1.write(tmp1)
                  if ckr==4:
#                     print("    INSERT TESTMRSSETCKR4",tmp1,end="")
                     fwr1.write("    INSERT WHTMRSSETCKR4\n")
                     fwr1.write(tmp1)
            else:
#               print(templine,end="")
               fwr1.write(templine)

         elif patlinetmp2[i].find("=")>-1 and startchk==0 and len(temp)==1:
            tmp1=temp[0][0:temp[0].find("=")]
            tmp2=temp[0][temp[0].find("=")+1:len(temp[0])]
            templine2="    "+tmp1+" "*(7-len(tmp1))+"= "+tmp2+" "*(12-len(tmp2))+templine[templine.find(";"):len(templine)]
#            print(templine2,end="")
            fwr1.write(templine2)
            patlinetmp2[i]=templine2

         else:
#            print(templine,end="")
            fwr1.write(templine)
      
      else:
         if len(temp)>1:
            if temp[0]=="INSERT" or temp[0]=="INSESRT" : #ERT":
               if temp[1].find("REF")>-1:

                  templine2="    "+temp[0]+" "+temp[1]+patspeed     #+templine[templine.find(temp[1])+len(temp[1]):len(templine)-1]
                  if freerun==1:
                     templine2=templine2+"_WCK\n"
                  templine2=templine2+templine[templine.find(temp[1])+len(temp[1]):len(templine)-1]
#                  print(templine2,end="")
                  fwr1.write(templine2)
               elif temp[1][0:6]=="WCKALL":
                  templine2=" ;; "+temp[0]+" "+temp[1]+templine[templine.find(temp[1])+len(temp[1]):len(templine)]
#                  print(templine2,end="")
                  fwr1.write(templine2)
                  if patspeed=="7K5" or patspeed=="6K4" or patspeed=="5K5" or patspeed=="4K2" or patspeed=="3K7":
                     w1st="        JSR WCK4A"+patspeed[0]+patspeed[2]+" I : XYCLD                                                                             ;\n"
#                     print("        JSR WCK4AWL I : XYCLD                                                                             ;",linuxrt,end="")
#                     print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                     print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                     print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                     print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                     print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                     print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                     print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                     print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                     print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                     print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                     print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                     print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                     print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                     print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                     print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
                     # fwr1.write("        JSR WCK4AWL I : XYCLD                                                                             ;\n")
                     fwr1.write(w1st)
                     fwr1.write("                      : XYCLD                                                                             ;\n")
                     fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                     fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                     fwr1.write("                      : XYCLD                                                                             ;\n")
                     fwr1.write("                      : XYCLD                                                                             ;\n")
                     fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                     fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                     fwr1.write("                      : XYCLD                                                                             ;\n")
                     fwr1.write("                      : XYCLD                                                                             ;\n")
                     fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                     fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                     fwr1.write("                      : XYCLD                                                                             ;\n")
                     fwr1.write("                      : XYCLD                                                                             ;\n")
                     fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                     fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                  elif patspeed=="3K2" or patspeed=="1K6":
                     if ckr==2:     
#                        print("        JSR WCK2AWL I : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
                        w1st="        JSR WCK2A"+patspeed[0]+patspeed[2]+" I : XYCLD                                                                             ;\n"
                        fwr1.write(w1st)
                        # fwr1.write("        JSR WCK2AWL I : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                     elif ckr==4:     
#                        print("        JSR WCK4AWL I : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD                                                                             ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
#                        print("                      : XYCLD        CLK                                                                  ;",linuxrt,end="")
                        w1st="        JSR WCK4A"+patspeed[0]+patspeed[2]+" I : XYCLD                                                                             ;\n"
                        # fwr1.write("        JSR WCK4AWL I : XYCLD                                                                             ;\n")
                        fwr1.write(w1st)
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD                                                                             ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
                        fwr1.write("                      : XYCLD        CLK                                                                  ;\n")
               else:
                  templine2="    "+temp[0]+" "+temp[1]+templine[templine.find(temp[1])+len(temp[1]):len(templine)]
#                  print(templine2,end="")
                  fwr1.write(templine2)
               patlinetmp2[i]=templine2               
            elif patlinetmp2[i].find("MODULE")>-1 and patlinetmp2[i].find("END")>-1:
               endchk=1
               if freerun==1:
#                  print("    INSERT WCKFREEWLC",linuxrt,end="")
                  # fwr1.write("    INSERT WCKFREEWLC\n")
                  w1stf="    INSERT "+w1st[w1st.find("WCK"):w1st.find("WCK")+7]+" \n"
                  fwr1.write(w1stf)
                  # fwr1.write("    INSERT WCKFREEWLC\n")
            

#               print(templine,end="")
               fwr1.write(templine)
            else:
               prevckloc=ckloc
               ckloc=0
               cloc=-1
               cloc2=-1
               wloc=-1
               wloc2=-1
               if freerun==1 and templine.find("WCK")>0 and (templine.find("WCK")<templine.find(";")):
                  for j in range(0,len(temp)):
                     if temp[j][0:3]=="WCK" and wloc==-1:
                        wloc=j
                     if temp[j].find(":")>-1 and cloc==-1:
                        if j==0 and temp[j][0]==":":
                           cloc=j
                        elif j>0:
                           cloc=j

#                  print(temp[cloc],temp[cloc+1],wloc,cloc)
                  if templine.find("CLK")<60 and templine.find("CLK")>-1:
                     ckloc=templine.find("CLK")
                  else:
                     ckloc=0
                     for j in range(1,8):
                        if patlinetmp2[i+j].find("CLK")>-1 and patlinetmp2[i+j].find("CLK")<60 and ckloc==0:
                           ckloc=patlinetmp2[i+j].find("CLK")
                     if ckloc==0:
                        ckloc=prevckloc
                  if temp[cloc+1]=="WCK":
                     templine2=templine[0:templine.find(" : ")+3]+temp[cloc+2]+" "*(8-len(temp[cloc+2]))+"WCK  "+templine[ckloc:len(templine)]
                  elif templine.find("WCK")<60:
                     templine2=templine[0:templine.find(temp[cloc+1])]+temp[cloc+1]+" "*(10-len(temp[cloc+1])-(templine.find(temp[cloc+1])-(10+templine[10:].find(":"))))+"WCK  "+templine[ckloc:len(templine)]
                     
                  else:
                     templine2=templine[0:templine.find(temp[cloc+1])]+temp[cloc+1]+" "*(10-len(temp[cloc+1])-(templine.find(temp[cloc+1])-(10+templine[10:].find(":"))))+"WCK  "+templine[ckloc:templine.find(temp[wloc])]+"   "+templine[templine.find(temp[wloc])+3:len(templine)]
                  
                  if templine2[templine2.find("WCK")+3:].find("WCK")>-1 and templine2[templine2.find("WCK")+3:].find("WCK")<templine2[templine2.find("WCK")+3:].find(";") :
                     templine2s=templine2[:templine2.find("WCK")+3]
                     wckfind1=templine2.find("WCK")
                     wckfind2=templine2[templine2.find("WCK")+3:].find("WCK")
                     templine2s=templine2s+templine2[wckfind1+3:wckfind1+3+wckfind2]+"   "+templine2[wckfind1+3+wckfind2+3:]
                     templine2=templine2s
                     

                  # if templine2[templine2.find(":")+3:].find("WA ")>-1 and templine2[templine2.find(":")+3:].find("WA ")<templine2.find(";"):
                  #    templine2s=templine2[templine2.find("WA "):templine2.find("WA ")+16]
                  #    if templine2s.find(' /D ')>-1 and templine2s.find(' /D2 ')>-1:
                  #       templine2s='WA D11    '+templine2s[10:]
                  #    elif templine2s.find(' /D ')==-1 and templine2s.find(' /D2 ')>-1:
                  #       templine2s='WA D01    '+templine2s[10:]
                  #    elif templine2s.find(' /D ')>-1 and templine2s.find(' /D2 ')==-1:
                  #       templine2s='WA D10    '+templine2s[10:]
                  #    elif templine2s.find(' /D ')==-1 and templine2s.find(' /D2 ')==-1:
                  #       templine2s='WA D00    '+templine2s[10:]
                  #    templine2=templine2[:templine2.find("WA ")]+templine2s+templine2[templine2.find("WA ")+16:]
                  #    # print(templine2s)

                  # if templine2[templine2.find(":")+3:].find("CPE ")>-1 and templine2[templine2.find(":")+3:].find("CPE ")<templine2.find(";"):
                  #    templine2s=templine2[templine2.find("CPE "):templine2.find("CPE ")+16]
                  #    if templine2s.find(' /D ')>-1 and templine2s.find(' /D2 ')>-1:
                  #       templine2s='CPE D11    '+templine2s[11:]
                  #    elif templine2s.find(' /D ')==-1 and templine2s.find(' /D2 ')>-1:
                  #       templine2s='CPE D10    '+templine2s[11:]
                  #    elif templine2s.find(' /D ')>-1 and templine2s.find(' /D2 ')==-1:
                  #       templine2s='CPE D01    '+templine2s[11:]
                  #    elif templine2s.find(' /D ')==-1 and templine2s.find(' /D2 ')==-1:
                  #       templine2s='CPE D10    '+templine2s[11:]
                  #    templine2=templine2[:templine2.find("CPE ")]+templine2s+templine2[templine2.find("CPE ")+16:]
                  
#                  print(templine2,end="")
                  fwr1.write(templine2)
                  patlinetmp2[i]=templine2    
               
               else:
#                  print(templine,end="")
                  fwr1.write(templine)
         else:
#            print(templine,end="")
            fwr1.write(templine)

   icntend=icnt

   fwr1.close()





#    each_wr=0
#    each_rd=0
#    each_wrrd_afterline=0
#    cas_wr_need=-1   # <0 no  >0 yes
#    cas_rd_need=-1   # <0 no  >0 yes
#    wck_op=0    # 0 no  1 yes
#    wck_transition_1to0=-1    # 0 no  1 yes
#    each_wrrd=0

#    tWCKENL_WR=7
#    tWCKPRE_static_WR=3
#    tWCKENL_RD=6
#    # print(filename_org[n_conv],filename_org[n_conv][3])
#    if filename_org[n_conv][3]=='d':
#       tWCKENL_RD=8
#    tWCKPRE_static_RD=4

#    for i in range(0,lineoutend):
# #      if patlinetmp2[i].find("START")>-1 and patlinetmp2[i].find("#00")>-1:
# #         startchk=1
# #      if patlinetmp2[i].find("MODULE")>-1 and patlinetmp2[i].find("END")>-1:
# #         endchk=1
#       templine=patlinetmp2[i]
#       templine2=templine
#       temp=templine.split()
#       eachlineend=0
#       line_align=0
#       if len(temp)>2:
#          templine_p1=patlinetmp2[i+1]
#          templine_p4=patlinetmp2[i+4]
#          temp4=templine_p4.split()
#          if (i<lineoutend-8):
#             templine_p8=patlinetmp2[i+8]
#             temp8=templine_p8.split()
#          for ii in range(len(temp)):
#             if temp[ii][0]==';':
#                eachlineend=1
#             if eachlineend==0 and each_wrrd==0 and temp[ii] in LP5_CMD_WR0:
#                each_wr=0
#                if each_rd>1:
#                   each_rd=-1
#                each_rd=-1
#                each_wrrd_afterline=1
#                wck_op=1
#                wck_transition_1to0=1000
#                each_wrrd=1
#             if eachlineend==0 and each_wrrd==0 and temp[ii] in LP5_CMD_RD0:
#                each_rd=0
#                if each_wr>1:
#                   each_wr=-1
#                each_wr=-1
#                each_wrrd_afterline=1
#                wck_op=1
#                wck_transition_1to0=1000
#                each_wrrd=1
#                # print(templine)
#          if each_wr>-1:
#             each_wr=each_wr+1
#          if each_rd>-1:
#             each_rd=each_rd+1
#          for ii in range(len(temp4)):
#             if temp4[ii][0]==';':
#                eachlineend=1
#             if temp4[ii] in LP5_CMD_WR0:
#                if cas_wr_need<0:
#                   cas_wr_need=0
#                   cas_rd_need=-1
#             if temp4[ii] in LP5_CMD_RD0:
#                if cas_rd_need<0:
#                   cas_rd_need=0
#                   cas_wr_need=-1
   
#          if cas_wr_need>-1:
#             cas_wr_need=cas_wr_need+1
#          if cas_rd_need>-1:
#             cas_rd_need=cas_rd_need+1

#          # if cas_wr_need>((tWCKENL_WR+tWCKPRE_static_WR)*4+6) and (each_wr>16 or each_wr<0):  
#          #    cas_wr_need=-1
#          #    each_wr=-1

#          if each_wr>80: #((tWCKENL_WR+tWCKPRE_static_WR)*4+6):
#             cas_wr_need=-1
#             each_wr=-1

#          # if cas_rd_need>((tWCKENL_RD+tWCKPRE_static_RD)*4+6):# and (each_rd>((tWCKENL_RD+tWCKPRE_static_RD)*4+6) or each_rd<0):
#          #    cas_rd_need=-1
#          #    each_rd=-1

#          if each_rd>80: #((tWCKENL_RD+tWCKPRE_static_RD)*4+6):
#             cas_rd_need=-1
#             each_rd=-1


#          if each_wrrd_afterline>0:
#             each_wrrd_afterline=each_wrrd_afterline+1
#          if each_wrrd_afterline>4:
#             each_wrrd=0
#          if each_wrrd_afterline>16:
#             each_wrrd_afterline=0
         
#          if cas_rd_need>0 and cas_rd_need<5:
#             if cas_rd_need==1:
#                CAS_=' CASRDS0 '
#             if cas_rd_need==2:
#                CAS_=' CASRDS1 '
#             if cas_rd_need==3:
#                CAS_=' CAS2    '
#             if cas_rd_need==4:
#                CAS_=' CAS3    '            
#             if templine_p4[templine_p4.find(":")+3:].find("RDC")-2>-1:
#                cas_loc_start=templine_p4.find(":")+3+templine_p4[templine_p4.find(":")+3:].find("RDC")
#             elif templine_p4[templine_p4.find(":")+3:].find("RD")-2>-1:
#                cas_loc_start=templine_p4.find(":")+3+templine_p4[templine_p4.find(":")+3:].find("RD")-2
#             elif templine_p4[templine_p4.find(":")+3:].find("MRR")-2>-1:
#                cas_loc_start=templine_p4.find(":")+3+templine_p4[templine_p4.find(":")+3:].find("MRR")
#             elif templine_p4[templine_p4.find(":")+3:].find("RFF")-2>-1:
#                cas_loc_start=templine_p4.find(":")+3+templine_p4[templine_p4.find(":")+3:].find("RFF")

#             if templine[cas_loc_start-1:cas_loc_start+8]=='         ':
#                templine=templine[:cas_loc_start-1]+CAS_+templine[cas_loc_start+8:]
#             elif templine[cas_loc_start-1:cas_loc_start+6]==' CASDUM':
#                templine=templine[:cas_loc_start-1]+' CASRDS'+templine[cas_loc_start+6:]
#             # else:
#             #    print(tmp_fname,templine[cas_loc_start-1:cas_loc_start+6])




#          if cas_wr_need>0 and cas_wr_need<5:
#             if cas_wr_need==1:
#                CAS_=' CASWRS0 '
#             if cas_wr_need==2:
#                CAS_=' CASWRS1 '
#             if cas_wr_need==3:
#                CAS_=' CAS2    '
#             if cas_wr_need==4:
#                CAS_=' CAS3    '            
#             if templine_p4[templine_p4.find(":")+3:].find("WR")-2>-1:
#                cas_loc_start=templine_p4.find(":")+3+templine_p4[templine_p4.find(":")+3:].find("WR")-2
#             elif templine_p4[templine_p4.find(":")+3:].find("WMR")-2>-1:
#                cas_loc_start=templine_p4.find(":")+3+templine_p4[templine_p4.find(":")+3:].find("WMR")-2
#             elif templine_p4[templine_p4.find(":")+3:].find("WFF")-2>-1:
#                cas_loc_start=templine_p4.find(":")+3+templine_p4[templine_p4.find(":")+3:].find("WFF")

#             if templine[cas_loc_start-1:cas_loc_start+8]=='         ':
#                templine=templine[:cas_loc_start-1]+CAS_+templine[cas_loc_start+8:]
#             elif templine[cas_loc_start-1:cas_loc_start+6]==' CASDUM':
#                templine=templine[:cas_loc_start-1]+' CASWRS'+templine[cas_loc_start+6:]
#             # else:
#                # print(tmp_fname,templine[cas_loc_start-1:cas_loc_start+6])
#          if templine[templine.find(":")+3:].find("WA ")>-1 and templine[templine.find(":")+3:].find("WA ")<templine.find(";"):
#             wck_transition_1to0=0
#             # if templine_p1[templine_p1.find(":")+3:].find("WA ")==-1:
#             #    wck_transition_1to0=0
#             # else:
#             #    wck_transition_1to0=0

#          if templine[templine.find(":")+3:].find(" CPE")>-1 and templine[templine.find(":")+3:].find(" CPE")<templine.find(";"):
#             wck_transition_1to0=0
#             # if templine_p1[templine_p1.find(":")+3:].find("CPE ")==-1:
#             #    wck_transition_1to0=0
#             # else:
#             #    wck_transition_1to0=0

#          if wck_transition_1to0>-1:
#             wck_transition_1to0=wck_transition_1to0+1

#          if wck_op==1 and wck_transition_1to0>3 and wck_transition_1to0<1000:
#             if i>lineoutend-16:
#                wck_op=0
#                wck_transition_1to0=-1
#             else:
#                templine_p20=patlinetmp2[i+4]
#                templine_p21=patlinetmp2[i+8]
#                templine_p22=patlinetmp2[i+12]
#                templine_p23=patlinetmp2[i+16]
#                if templine_p20[templine_p20.find(":")+3:].find("WA ")>-1 and templine_p20[templine_p20.find(":")+3:].find("WA ")<templine_p20.find(";"):
#                   wck_transition_1to0=0
#                elif templine_p20[templine_p20.find(":")+3:].find(" CPE")>-1 and templine_p20[templine_p20.find(":")+3:].find(" CPE")<templine_p20.find(";"): 
#                   wck_transition_1to0=0
#                elif templine_p21[templine_p21.find(":")+3:].find("WA ")>-1 and templine_p21[templine_p21.find(":")+3:].find("WA ")<templine_p21.find(";"):
#                   wck_transition_1to0=0
#                elif templine_p21[templine_p21.find(":")+3:].find(" CPE")>-1 and templine_p21[templine_p21.find(":")+3:].find(" CPE")<templine_p21.find(";"): 
#                   wck_transition_1to0=0
#                elif templine_p22[templine_p22.find(":")+3:].find("WA ")>-1 and templine_p22[templine_p22.find(":")+3:].find("WA ")<templine_p22.find(";"):
#                   wck_transition_1to0=0
#                elif templine_p22[templine_p22.find(":")+3:].find(" CPE")>-1 and templine_p22[templine_p22.find(":")+3:].find(" CPE")<templine_p22.find(";"): 
#                   wck_transition_1to0=0
#                elif templine_p23[templine_p23.find(":")+3:].find("WA ")>-1 and templine_p23[templine_p23.find(":")+3:].find("WA ")<templine_p23.find(";"):
#                   wck_transition_1to0=0
#                elif templine_p23[templine_p23.find(":")+3:].find(" CPE")>-1 and templine_p23[templine_p23.find(":")+3:].find(" CPE")<templine_p23.find(";"): 
#                   wck_transition_1to0=0
#                else:
#                   wck_transition_1to0=-100
#                   wck_op=0

#          if templine.find(' : ')>10 and templine.find(' : ')<25:
#             line_align=templine.find(' : ')+1
#             WCK_='     '
#             if wck_op==0 and cas_rd_need<0 and cas_wr_need<0:
#                WCK_='     '
#             elif wck_op==0 and cas_rd_need>((tWCKENL_RD+tWCKPRE_static_RD)*4+6) and each_rd<=80: #((tWCKENL_RD+tWCKPRE_static_RD)*4+6): #32:
#                WCK_=' WCK '
#             elif wck_op==0 and cas_wr_need>((tWCKENL_WR+tWCKPRE_static_WR)*4+6) and each_wr<=80: #((tWCKENL_WR+tWCKPRE_static_WR)*4+6): #32
#                WCK_=' WCK '
#             elif wck_op==0 and (cas_rd_need>2 or cas_wr_need>2):
#                WCK_=' WHH '
#             elif wck_op==1:
#                if cas_wr_need<0 and cas_rd_need<0:
#                   WCK_=' WCK '
#                elif cas_rd_need>((tWCKENL_RD+tWCKPRE_static_RD)*4+6):
#                   WCK_=' WCK '
#                elif cas_wr_need>((tWCKENL_WR+tWCKPRE_static_WR)*4+6):
#                   WCK_=' WCK '
#                elif cas_wr_need>3 and cas_wr_need<(tWCKENL_WR*4+2+1):
#                   WCK_=' WHH '
#                elif cas_wr_need>(tWCKENL_WR*4+2) and cas_wr_need<((tWCKENL_WR+tWCKPRE_static_WR)*4+2):
#                   WCK_='     '
#                elif cas_wr_need==((tWCKENL_WR+tWCKPRE_static_WR)*4+3) or cas_wr_need==((tWCKENL_WR+tWCKPRE_static_WR)*4+5):
#                   WCK_=' WHH '
#                elif cas_wr_need==((tWCKENL_WR+tWCKPRE_static_WR)*4+4) or cas_wr_need==((tWCKENL_WR+tWCKPRE_static_WR)*4+6):
#                   WCK_='     '
#                elif cas_rd_need>3 and cas_rd_need<(tWCKENL_RD*4+2+1):
#                   WCK_=' WHH '
#                elif cas_rd_need>(tWCKENL_RD*4+2) and cas_rd_need<((tWCKENL_RD+tWCKPRE_static_RD)*4+2):
#                   WCK_='     '
#                elif cas_rd_need==((tWCKENL_RD+tWCKPRE_static_RD)*4+3) or cas_rd_need==((tWCKENL_RD+tWCKPRE_static_RD)*4+5):
#                   WCK_=' WHH '
#                elif cas_rd_need==((tWCKENL_RD+tWCKPRE_static_RD)*4+4) or cas_rd_need==((tWCKENL_RD+tWCKPRE_static_RD)*4+6):
#                   WCK_='     '
#             else:
#                WCK_='     '


#             if line_align==22:
#                # templine2=templine[:templine.find(':')+10]+templine[templine.find(':')+15:templine.find(':')+19]+templine[templine.find(':')+9:templine.find(':')+14]+templine[templine.find(':')+19:]
#                templine2=templine[:templine.find(' : ')+11]+templine[templine.find(' : ')+16:templine.find(' : ')+20]+WCK_+templine[templine.find(' : ')+20:]
#             elif line_align<22 and templine[0]==' ':
#                # templine2=' '*(22-line_align)+templine[:templine.find(':')+10]+templine[templine.find(':')+15:templine.find(':')+19]+templine[templine.find(':')+9:templine.find(':')+14]+templine[templine.find(':')+19:]
#                templine2=' '*(22-line_align)+templine[:templine.find(' : ')+11]+templine[templine.find(' : ')+16:templine.find(' : ')+20]+WCK_+templine[templine.find(' : ')+20:]
            
#          else:
#             templine2=templine
#       else:
#          templine2=templine

#       patlinetmp3[i]=templine2
#       # print('%4d %4d %4d %4d %4d %4d %4d '%(wck_transition_1to0,cas_wr_need,cas_rd_need,wck_op,each_wr,each_rd,each_wrrd_afterline)," ",templine2,end='')


#    tmp_fname2=tmp_fname[:tmp_fname.find('PDBS')+5]+'S'+tmp_fname[tmp_fname.find('PDBS')+6:]
#    tmp_mpat2='MPAT    PDBS4S'+patlinetmp3[0][patlinetmp3[0].find('PDBS')+6:len(patlinetmp3[0])]


#    print(tmp_fname,":",tmp_fname2,":",tmp_mpat2)

#    fwr2 = open(tmp_fname2+".asc","w")
#    fwr2.write(tmp_mpat2)
#    for i in range(1,lineoutend):
#       templine3=patlinetmp3[i]
#       fwr2.write(templine3)
#       if templine3[:20].find('START')>-1:
#          fwr2.write("\n    INSERT TESTMRSSETCKR4\n")
#    fwr2.close()

   
   




#print()
#print()
#print("====================================")
#print("#        [EXTRACTION DONE]         #")
#print("#    LP5_Pattern Word Extractor    #")
#print("====================================")

