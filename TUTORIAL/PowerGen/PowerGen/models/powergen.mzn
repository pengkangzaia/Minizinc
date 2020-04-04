% power generation
int: T;                 % decades
array[1..T] of int: e;  % expected requirements
array[1..T] of int: a;  % current production

array[1..T] of var 0..infinity: N; % number of nuclear power plants built each decade
array[1..T] of var 0..infinity: C; % number of coal power plants built each decade
array[1..T] of var 0..infinity: S; % number of solar power plants built each decade
%infinity 


% First month
% the energy available in each decade must meet the expected demand
constraint 4*N[1]+C[1]+S[1]+a[1]>=e[1];
% no more than 40% of all energy can be nuclear in any decade
constraint 4*N[1]<=0.4*(4*N[1]+C[1]+S[1]+a[1]);
% no less than 20% of all energy can be solar in each decade
constraint S[1]>=0.2*(4*N[1]+C[1]+S[1]+a[1]);

% Second month
% the energy available in each decade must meet the expected demand
constraint 4*(N[1]+N[2])+C[2]+C[1]+S[2]+S[1]+a[2]>=e[2];
% no more than 40% of all energy can be nuclear in any decade
constraint 4*(N[1]+N[2])<=0.4*(4*(N[1]+N[2])+C[2]+C[1]+S[2]+S[1]+a[2]);
% no less than 20% of all energy can be solar in each decade
constraint S[1]+S[2]>=0.2*(4*(N[1]+N[2])+C[2]+C[1]+S[2]+S[1]+a[2]);

% 3
% the energy available in each decade must meet the expected demand
constraint 4*(N[1]+N[2]+N[3])+C[3]+C[2]+S[3]+S[2]+S[1]+a[3]>=e[3];
% no more than 40% of all energy can be nuclear in any decade
constraint 4*(N[1]+N[2]+N[3])<=0.4*(4*(N[1]+N[2]+N[3])+C[3]+C[2]+S[3]+S[2]+S[1]+a[3]);
% no less than 20% of all energy can be solar in each decade
constraint S[3]+S[2]+S[1]>=0.2*(4*(N[1]+N[2]+N[3])+C[3]+C[2]+S[3]+S[2]+S[1]+a[3]);

% 4
% the energy available in each decade must meet the expected demand
constraint 4*(N[1]+N[2]+N[3]+N[4])+C[4]+C[3]+S[4]+S[3]+S[2]+a[4]>=e[4];
% no more than 40% of all energy can be nuclear in any decade
constraint 4*(N[1]+N[2]+N[3]+N[4])<=0.4*(4*(N[1]+N[2]+N[3]+N[4])+C[4]+C[3]+S[4]+S[3]+S[2]+a[4]);
% no less than 20% of all energy can be solar in each decade
constraint S[4]+S[3]+S[2]>=0.2*(4*(N[1]+N[2]+N[3]+N[4])+C[4]+C[3]+S[4]+S[3]+S[2]+a[4]);

% 5
% the energy available in each decade must meet the expected demand
constraint 4*(N[1]+N[2]+N[3]+N[4]+N[5])+C[5]+C[4]+S[5]+S[4]+S[3]+a[5]>=e[5];
% no more than 40% of all energy can be nuclear in any decade
constraint 4*(N[1]+N[2]+N[3]+N[4]+N[5])<=0.4*(4*(N[1]+N[2]+N[3]+N[4]+N[5])+C[5]+C[4]+S[5]+S[4]+S[3]+a[5]);
% no less than 20% of all energy can be solar in each decade
constraint S[5]+S[4]+S[3]>=0.2*(4*(N[1]+N[2]+N[3]+N[4]+N[5])+C[5]+C[4]+S[5]+S[4]+S[3]+a[5]);


% 6
% the energy available in each decade must meet the expected demand
constraint forall(i in 6..T)(4*(N[i-5]+N[i-4]+N[i-3]+N[i-2]+N[i-1]+N[i])+C[i]+C[i-1]+S[i]+S[i-1]+S[i-2]+a[i]>=e[i]);
% no more than 40% of all energy can be nuclear in any decade
constraint forall(i in 6..T)(4*(N[i-5]+N[i-4]+N[i-3]+N[i-2]+N[i-1]+N[i])<=0.4*(4*(N[i-5]+N[i-4]+N[i-3]+N[i-2]+N[i-1]+N[i])+C[i]+C[i-1]+S[i]+S[i-1]+S[i-2]+a[i]));
% no less than 20% of all energy can be solar in each decade
constraint forall(i in 6..T)(S[i]+S[i-1]+S[i-2]>=0.2*(4*(N[i-5]+N[i-4]+N[i-3]+N[i-2]+N[i-1]+N[i])+C[i]+C[i-1]+S[i]+S[i-1]+S[i-2]+a[i]));

constraint (sum(i in 1..T)(C[i]*2))-C[T]<=10;

var 0..infinity: cost = sum(i in 1..T)(N[i]*10+C[i]+S[i]*2);  % costs of building all new power plants

solve minimize cost;
output ["cost:\(cost)\n",        "N:\(N)\n",        "C:\(C)\n",        "S:\(S)\n"];

                           
