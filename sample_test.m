clc
clear all
load CAPMuniverse
%% Importing Returns Data
Data1 = readtable("Returns Data.xlsx");
AAPL_R = Data1.AAPL;
JPM_R = Data1.JPM;
PFE_R = Data1.PFE;
TSLA_R = Data1.TSLA;
CVX_R = Data1.CVX;
DAL_R = Data1.DAL;
p = Portfolio;
p = estimateAssetMoments(p, Data1(:,1:6));
p = setDefaultConstraints(p);
weigths = estimateFrontier(p);
plotFrontier(p);
%%
M = [AAPL_R, JPM_R, PFE_R, TSLA_R, CVX_R, DAL_R];
correlation_matrix = corrcoef(M);
%% Importing Stock Prices
%Data2 = readtable("Stock Data.xlsx");
%AAPL_S = Data2.AAPL;
%JPM_S = Data2.JPM;
%PFE_S = Data2.PFE;
%TSLA_S = Data2.TSLA;
%CVX_S = Data2.CVX;
%DAL_S = Data2.DAL;
%%
%AAPL_C = 130;
%JPM_C = 150;
%PFE_C = 34;
%TSLA_C = 670;
%CVX_C = 100;
%DAL_C = 45;
%%
%f = -[AAPL_C JPM_C PFE_C TSLA_C CVX_C DAL_C];
%A = [AAPL_R JPM_R PFE_R TSLA_R CVX_R DAL_R]';
%b = 50000;
%lb = [0,0,0,0,0,0];
%[x, fval]= linprog(f, A, b, [], [],lb, []);
%%