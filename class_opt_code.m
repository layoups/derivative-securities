%% Covered call probabilistic analysis
 
%% Get all prices and future prices
stock_price = 20;
stock_prices_future = [40 20 12]';
bond_price = 90;
bond_prices_future = [100 100 100]';
option1_price = 10;
option2_price = 6;
option1_prices_future = [25 5 0]'; %strike 15
option2_prices_future = [20 0 0]'; %strike 20
 
%% get returns
stock_returns = (stock_prices_future - stock_price)/stock_price;
option1_returns =(option1_prices_future - option1_price)/option1_price;
option2_returns =(option2_prices_future - option2_price)/option2_price;
 
 
 
%% expected profits
 
expected_profit_stock = mean(stock_prices_future - stock_price);
expected_profit_bond = 10;
expected_profit_option1 = mean(option1_prices_future - option1_price);
expected_profit_option2 = mean(option2_prices_future - option2_price);
 
%% expected returns
expected_stock_return = mean(stock_returns);
expected_option1_return = mean(option1_returns);
expected_option2_return = mean(option2_returns);
 
%% define the function to maximize
 
f = -[expected_profit_stock expected_profit_bond...
    expected_profit_option1 expected_profit_option2];
 
%% constraints 
%% Budget constraint
A = [20 90 10 6];
b = 50000;
lb = [ 0,0 , -6000, -6000];
%ub = [ inf,inf , 5000, 5000];
 
%% solve linear program maximizing expected profit
 
[x fval]= linprog(f, A, b, [], [],lb, []);
 
%% what is expected profit?
expected_profit =  - f *x;
 
%% compute cost of portfolio
cost = x' * [stock_price; bond_price; option1_price; ...
    option2_price];
 
 
%% computation of Risk
 
Q = [stock_prices_future ...
    bond_prices_future ...
    option1_prices_future ...
    option2_prices_future]';

portfolio_prices_future = x' * [stock_prices_future ...
    bond_prices_future ...
    option1_prices_future ...
    option2_prices_future]';
 
portfolio_returns = (portfolio_prices_future - cost)/cost;
mu = mean(portfolio_returns);
sigma = std(portfolio_returns);
 
%% calculate sharpe!
sharpe = mu/sigma;
