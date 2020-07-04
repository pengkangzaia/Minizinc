% hidato puzzle

int: n; % no of ROWS
set of int: ROW = 1..n;
int: m; % no of COLS
set of int: COL = 1..m;

set of int: CLUE = 0..m*n;
array[ROW,COL] of CLUE: clue;

set of int: NUM = 1..m*n;
array[ROW,COL] of var NUM: x;
  
  
% 根据clue得到x
constraint forall(i in ROW, j in COL where clue[i, j] != 0)(x[i, j] = clue[i, j]);
% 两两数字必须相邻
set of int: POS = 1..m*n;
array[NUM] of var POS: y;
set of int: dis = {1,m,m+1,m-1};
constraint forall(i in 1..m*n-1 where y[i] mod m != 1 /\ y[i] mod m != 0)(abs(y[i]-y[i+1]) in dis);

% % 第一行
% constraint forall(i in 1..m*n-1 where y[i] div m = 0)(y[i]-y[i+1] in {1,-1,-m,-m+1,-m-1});
% % 最后一行
% constraint forall(i in 1..m*n-1 where y[i] div m = n-1)(y[i]-y[i+1] in {1,-1,m,m+1,m-1});
% % 第一列
% constraint forall(i in 1..m*n-1 where y[i] mod m = 1)(y[i]-y[i+1] in {-1,-m,m,-m+1,m+1});
% % 最后一列
% constraint forall(i in 1..m*n-1 where y[i] mod m = 0)(y[i]-y[i+1] in {1,-m,m,m-1,-m-1});

% constraint forall(i in 1..m*n-1 where y[i]!=1 /\ y[i]!=m /\ y[i]!=(n-1)*m+1 /\ y[i]!=n*m)(abs(y[i]-y[i+1]) in dis);
% constraint forall(i in 1..m*n-1 where not (y[i]/m=0) /\ not (y[i]/m=n-1) /\ not (y[i]-m*((y[i]-1)/m)=0) /\ not (y[i]-m*(y[i]/m)=0))(abs(y[i]-y[i+1]) in dis);

% constraint forall(i in 1..m*n-1 where y[i]=1 \/ y[i]=n*m)(abs(y[i]-y[i+1]) in {1,m,m+1});
% constraint forall(i in 1..m*n-1 where y[i]=m \/ y[i]=(n-1)*m+1)(abs(y[i]-y[i+1]) in {1,m,m-1});

constraint abs(x[1,1]-x[1,2])=1 \/ abs(x[1,1]-x[2,1])=1 \/ abs(x[1,1]-x[2,2])=1;
constraint abs(x[n,1]-x[n,2])=1 \/ abs(x[n,1]-x[n-1,1])=1 \/ abs(x[n,1]-x[n-1,2])=1;
constraint abs(x[1,m]-x[1,m-1])=1 \/ abs(x[1,1]-x[2,m])=1 \/ abs(x[1,1]-x[2,m-1])=1;
constraint abs(x[n,m]-x[n,m-1])=1 \/ abs(x[1,1]-x[n-1,m])=1 \/ abs(x[1,1]-x[n-1,m-1])=1;

% constraint forall(j in COL where j!=1 /\ j!=m)(abs(x[1,j]-x[1,j-1])=1\/abs(x[1,j]-x[1,j+1])=1\/abs(x[1,j]-x[1+1,j-1])=1\/abs(x[1,j]-x[1+1,j])=1\/abs(x[1,j]-x[1+1,j+1])=1);
% constraint forall(j in COL where j!=1 /\ j!=m)(abs(x[n,j]-x[n,j-1])=1\/abs(x[n,j]-x[n,j+1])=1\/abs(x[n,j]-x[n-1,j-1])=1\/abs(x[n,j]-x[n-1,j])=1\/abs(x[n,j]-x[n-1,j+1])=1);
% constraint forall(i in ROW where i!=1 /\ i!=n)(abs(x[i,1]-x[i-1,1])=1\/abs(x[i,1]-x[i+1,1])=1\/abs(x[i,1]-
% x[i,1+1])=1\/abs(x[i,1]-x[i-1,1+1])=1\/abs(x[i,1]-x[i+1,1+1])=1);
% constraint forall(i in ROW where i!=1 /\ i!=n)(abs(x[i,m]-x[i-1,m])=1\/abs(x[i,m]-x[i+1,m])=1\/abs(x[i,m]-x[i-1,m-1])=1\/abs(x[i,m]-x[i,m-1])=1\/abs(x[i,m]-x[i+1,m-1])=1);
  
include "globals.mzn";
constraint inverse(y,[x[i,j]|i in ROW,j in COL]);
  
%output for debugging                
int: d = ceil(log10(m*n+1));
output [ show_int(d,x[r,c]) ++ " " ++ if c = m then "\n" else "" endif
       | r in ROW, c in COL ];      
           

% % output for grading
% output ["x = array2d(ROW,COL,\(x));\n"];



% The aim is to fill a grid with consecutive numbers 
% that connect horizontally, vertically or diagonally.
% each number appears exactly once, and any adjacent numbers k and k + 1
% must appear adjacent in the grid, 
% which means either horizontally, vertically or diagonally.
% set of int: POS = 1..m*n;
% array[NUM] of var POS: y;
% array[NUM] of bool: z = (i in [ j | j in COL ]);
%                /\ (i in [ (n-1)*m+j | j in COL ])
%               /\ (i in [ j*m+1 | j in 0..n-1 ])
%               /\ (i in [ j*m+m | j in 0..n-1 ])
%/\ (i in [ j | j in COL ])

% constraint forall(i in NUM where i in {1..m,(n-1)*m+1..(n-1)*m+m})
%                   (abs(y[i+1] - y[i]) in 
%                       {i+1,i-1,i-m+1,i-m,i-m+1,i+m-1,i+m,i+m+1});
% include "globals.mzn";
% constraint inverse(y, [x[i,j]|i in ROW, j in COL]);
% constraint forall(i in ROW, j in COL where i != 1 /\ i != n /\ j != 1 /\ j != m)(abs(x[i,j]-x[i,j-1])=1\/abs(x[i,j]-x[i,j+1])=1\/abs(x[i,j]-x[i-1,j-1])=1\/abs(x[i,j]-x[i-1,j])=1\/abs(x[i,j]-x[i-1,j+1])=1\/abs(x[i,j]-x[i+1,j-1])=1\/abs(x[i,j]-x[i+1,j])=1\/abs(x[i,j]-x[i+1,j+1])=1);

% constraint forall(j in COL where j!=1 /\ j!=m)(abs(x[1,j]-x[1,j-1])=1\/abs(x[1,j]-x[1,j+1])=1\/abs(x[1,j]-x[1+1,j-1])=1\/abs(x[1,j]-x[1+1,j])=1\/abs(x[1,j]-x[1+1,j+1])=1);
% constraint forall(j in COL where j!=1 /\ j!=m)(abs(x[n,j]-x[n,j-1])=1\/abs(x[n,j]-x[n,j+1])=1\/abs(x[n,j]-x[n-1,j-1])=1\/abs(x[n,j]-x[n-1,j])=1\/abs(x[n,j]-x[n-1,j+1])=1);
% constraint forall(i in ROW where i!=1 /\ i!=n)(abs(x[i,1]-x[i-1,1])=1\/abs(x[i,1]-x[i+1,1])=1\/abs(x[i,1]-x[i+1,1+1])=1\/abs(x[i,1]-x[i,1+1])=1\/abs(x[i,1]-x[i-1,1+1])=1);
% constraint forall(i in ROW where i!=1 /\ i!=n)(abs(x[i,m]-x[i-1,m])=1\/abs(x[i,m]-x[i+1,m])=1\/abs(x[i,m]-x[i-1,m-1])=1\/abs(x[i,m]-x[i,m-1])=1\/abs(x[i,m]-x[i+1,m-1])=1);