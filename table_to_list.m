function list = table_to_list(table_name, index)
table = readtable(table_name);
if index == 0
    list = [table.AAPL table.JPM table.PFE table.TSLA table.CVX table.DAL];
else
    list = [table.AAPL(index) table.JPM(index) table.PFE(index) ... 
        table.TSLA(index) table.CVX(index) table.DAL(index)];
end
    