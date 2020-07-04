% voucher problem
%
% pizzas to order
%    12 25 17 12 9
% vouchers
%    1+1  2+1
% you pay for the most expensive pizzas when using a voucher.

int: n; % number of pizzas
set of int: PIZZA = 1..n;
array[PIZZA] of int: price;   % price of each pizza

int: m; % number of vouchers
set of int: VOUCHER = 1..m;
array[VOUCHER] of int: buy;   % buy this many to use voucher
array[VOUCHER] of int: free;  % get this many free

set of int: ASSIGN = -m .. m; % -i pizza is assigned to buy of voucher i
                              %  i pizza is assigned to free of voucher i
                              %  0 no voucher used on pizza

array[PIZZA] of var ASSIGN: how;
array[VOUCHER] of var bool: used;

array[VOUCHER] of var 0..n: sump;
array[VOUCHER] of var 0..n: sumn;

constraint forall(v in VOUCHER)(sump[v] = (sum(p in PIZZA)(how[p] = v)));
constraint forall(v in VOUCHER)(sumn[v] = (sum(p in PIZZA)(how[p] = -v)));

constraint forall(v in VOUCHER)(if sump[v] > 0 then used[v] = 1 endif);
% assign right number of pizzas to buy order
constraint forall(v in VOUCHER)(if used[v] then sumn[v] = buy[v] else sumn[v] = 0 endif);
% assign not too many pizzas to free order
constraint forall(v in VOUCHER)(if used[v] then sump[v] <= free[v] endif);
constraint forall(v in VOUCHER)(if used[v] then sump[v] <= sumn[v] endif);
% pizzas assigned to free are no more expensive than pizzas assigned to buy
constraint forall(p1, p2 in PIZZA where how[p2] < 0)(if (how[p1] + how[p2] = 0) then (price[p2] >= price[p1]) endif);

var int: cost;

constraint cost = sum(p in PIZZA where how[p] <= 0)(price[p]);

solve minimize cost;

output  ["price = \(price);\nbuy = \(buy);\nfree = \(free);\nhow = \(how);\ncost = \(cost);\n"];
