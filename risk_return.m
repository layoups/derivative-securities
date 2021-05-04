%Get stock price, bond price and future prices
stock_price = 20;
stock_prices_future = [40 20 12]';
bond_price = 90;
bond_face_value = 100;
bond_price_future = [100 100 100]';
%% Get expected Profits
expected_stock_profit = mean(stock_prices_future-stock_price);
expected_bond_profit = bond_face_value - bond_price;
%% get the function on which maximize is applied
f = - [expected_stock_profit expected_bond_profit]; %negative sign to get maximize since matlab by default minimizes this
%%constraints
A = [20, 90];   
b = 50000;
lb=[0 0];

%% linear program solving
[x, expected_profit] = linprog(f,A,b,[],[],lb); % x is no. matrix

%% compute risk: sigma
cost = x'* [stock_price; bond_price];
portfolio_prices_future = x' * [stock_prices_future bond_price_future]';
portfolio_returns = (portfolio_prices_future - cost)/cost;

mu = mean(portfolio_returns);
sigma = std(portfolio_returns);
%% calculate sharpe
sharpe = mu/sigma;