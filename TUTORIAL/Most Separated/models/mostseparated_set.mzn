int: n;                % number of points
set of int: P = 1..n;  % points 
array[P,P] of int: d;  % distance matrix
array[P] of int: v;    % value matrix
int: k;                % size limit for chosen set 
int: l;                % average distance lower bound 
                                 
var set of P: S;       % chosen set S

var int: value;        % objective value of chosen set
constraint  value = sum(i in S)(v[i]);
% constraint sum(i,j in S where i!=j)(d[i,j])/card(S)/(card(S)-1)>=l;
constraint sum(i,j in S where i<j)(d[i,j]*2)/card(S)/(card(S)-1) >= l;
constraint card(S) <= k;

solve maximize value;

         
