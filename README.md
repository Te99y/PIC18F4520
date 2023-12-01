# PIC18F4520 
  2023-大三上必修的微算機功課

## 必須資料 :  
1. PIC18Fxxx Instruction Set : http://technology.niagarac.on.ca/staff/mboldin/18F_Instruction_Set/
2. Microchip Data Sheet : https://ww1.microchip.com/downloads/en/DeviceDoc/39631E.pdf

## 常見問題 & 解決方法 :

1. 怎麼開File Register, SFRs視窗 -> 在Navbar的 Window/Target Memory View
2. 同時有兩個asm在current config -> 對asm點右鍵, Include/Exclude files from current configuration
3. 不知道要如何在project間切換    -> 對project點右鍵, Set as main project
4. 用MacOs -> 幫你上香, 有解決的同學可以分享一下, 裝裝看虛擬機 https://youtu.be/pvITZxpkmtE?si=OvqHNrq2Y1WBbU3O
5. 接上Debugger後要怎麼跑code -> 記得project property的hardware tool要選PICkit4, 然後直接跑
6. 不知道怎麼看project property -> 對project點右鍵, 最下面
7. PICkit 4 not Found -> 如果沒有要接PIC4就看project property, hardware tool要選Simulator; 如果要接可能是線沒插好
8. VDD, VSS, 電壓相關問題 -> 你的電腦可能給的電壓不夠/ 地線,電源線有沒有接反/ 去project property>PICkit4選power target circult from PICkit4
9. Target Device ID (0x0) is an Invalid Device ID -> 線沒插好
10. 
