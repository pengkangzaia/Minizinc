% Building a good fence
int: W; % width of area
set of int: COL  = 1..W;
int: H; % height of area
set of int: ROW  = 1..H;

array[ROW,COL] of int: cost;   % cost to build fence in spot
array[ROW,COL] of int: reward; % reward for build fence here

int: budget;  
int: length; % max length of fence;

%拓展坐标的取值范围
array[1..length] of var 0..W : x;
array[1..length] of var 0..H : y;
var int : profit;

constraint profit = (sum(i in 1..length where x[i]!=0 /\ reward[y[i],x[i]] > 0)( reward[y[i],x[i]] )) - (sum(i in 1..length where x[i]!=0)( cost[y[i],x[i]] ));

function var int : m() = sum(i in 1..length)(x[i]!=0); 

constraint forall(i in 1..length-1 where i<m())(
           ( ( abs( x[i] - x[i+1] ) + abs(y[i] - y[i+1] ) = 1) ) );
constraint ( ( abs( x[1] - x[m()] ) + abs(y[1] - y[m()] ) = 1) );

constraint forall(i in 1..length-1,j in i+1..length where i<=m())( ( x[i]!=x[j] ) \/ ( y[i]!=y[j] ) );

constraint forall(index in 1..length,j in 1..H,i in 1..W where reward[j,i] < 0 /\ index<=m())(y[index]!=j \/ x[index]!=i);

constraint sum(i in 1..length where i<=m() )( cost[y[i],x[i]] ) <= budget;

constraint forall(i in 1..length)(if i > m() then x[i]=0 endif);
constraint forall(i in 1..length)(if i > m() then y[i]=0 endif);

solve maximize profit;
%% make sure you use this output statement
output ["x = \(x);\ny = \(y);\nprofit = \(profit);\n"] ;



