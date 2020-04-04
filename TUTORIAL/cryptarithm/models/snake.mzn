var 1..9:S;
var 0..9:N;
var 0..9:A;
var 0..9:K;
var 0..9:E;
var 1..9:R;
var 0..9:T;
var 0..9:L;

constraint                10000*S+1000*N+100*A+10*K+E
                        + 10000*S+1000*N+100*A+10*K+E
               = 100000*R+10000*A+1000*T+100*T+10*L+E;
               
include "alldifferent.mzn";
constraint alldifferent([S,N,A,K,E,R,T,L]);