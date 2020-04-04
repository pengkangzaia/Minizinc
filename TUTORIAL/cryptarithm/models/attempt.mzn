var 1..9:P;
var 0..9:L;
var 0..9:E;
var 0..9:A;
var 1..9:S;
var 0..9:O;
var 0..9:V;
var 0..9:U;
int : Z = 7;
int : Q = 7;

constraint              100000 * P + 10000 * L + 1000 * E + 100 * A + 10 * S + E
            +                        10000 * S + 1000 * O + 100 * L + 10 * V + E
            +           100000 * P + 10000 * U + 1000 * Z + 100 * Z + 10 * L + E
            =           100000 * Q + 10000 * Q + 1000 * Q + 100 * Q + 10 * Q + Q; 

include "alldifferent.mzn";
constraint alldifferent([P,L,E,A,S,O,V,U]);