clc
clear all
%% Importing Returns Data
Data1 = readtable("Returns Data.xlsx");
AAPL_R = geomean(1+Data1.AAPL);
JPM_R = geomean(1+Data1.JPM);
PFE_R = geomean(1+Data1.PFE);
TSLA_R = geomean(1+Data1.TSLA);
CVX_R = geomean(1+Data1.CVX);
DAL_R = geomean(1+Data1.DAL);
%% Importing Stock Prices
Data2 = readtable("Stock Data.xlsx");
AAPL_S = Data2.AAPL;
JPM_S = Data2.JPM;
PFE_S = Data2.PFE;
TSLA_S = Data2.TSLA;
CVX_S = Data2.CVX;
DAL_S = Data2.DAL;
%%
f = -[AAPL_S JPM_S PFE_S TSLA_S CVX_S DAL_S];
A = [AAPL_R JPM_R PFE_R TSLA_R CVX_R DAL_R]';
b = 50000*ones(2516,1);
lb = [0,0,0,0,0,0];
[x, fval]= linprog(f, A, b, [], [],lb, []);