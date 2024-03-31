eta_dis=0.87; batt_para(1)=eta_dis; %discharging
eta_ch=0.87; batt_para(2)=eta_ch; %charging
Es=4/eta_dis; batt_para(3)=Es;  % battery energy capacity:4MWh, charging/discharging efficiency:87%, Es: power output
pmax_dis=1;   batt_para(4)=pmax_dis; %batt discharging power capacity
pmax_ch=1;   batt_para(5)=pmax_ch; %batt charging power capacity
s_l=0.1; s_u=0.9; %soc lower and upper bound

L0=0.42; %initial SOC
LK=0.1; %specified SOC at the end
K=24;% 24 hours stands for longth of path

lambda=xlsread('price.xlsx','B2:B8761'); %load price information,time scale?

