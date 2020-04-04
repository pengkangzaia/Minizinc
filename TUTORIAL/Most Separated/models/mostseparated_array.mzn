int: n;                % number of points
set of int: P = 1..n;  % points 
array[P,P] of int: d;  % distance matrix
array[P] of int: v;    % value matrix
int: k;                % size limit for chosen set 
int: l;                % average distance lower bound 


set of int: P0 = 0..n;
array[1..k] of var P0 : Sx;

function var int : m() = sum(i in 1..k)((Sx[i]!=0));
constraint (sum(i in 1..k-1, j in i+1..k 
                  where (Sx[i] != 0 /\ Sx[j] != 0) )
                      ( d[Sx[i],Sx[j]] * 2) ) >= m() * (m() - 1) * l;
constraint forall(i in 1..k-1)( ((Sx[i]!=0) + Sx[i+1]) <= Sx[i]);
var int : value;
constraint value = sum(i in 1..k where Sx[i]!=0)(v[Sx[i]]);
solve maximize value;