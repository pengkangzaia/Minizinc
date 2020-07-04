set of int: POS = 1..4;
enum REINDEER = { Lancer, Quentin, Ezekiel, Rudy };
array[POS] of var REINDEER: y;

% Lancer cant be next to Ezekiel
constraint forall(i in 1..card(POS) - 1 where y[i] = Lancer)(y[i+1] != Ezekiel);
constraint forall(i in 2..card(POS) where y[i] = Lancer)(y[i-1] != Ezekiel);
% Rudy has to be ahead of Quentin or ahead of Lancer
constraint forall(i, j in POS where i > j /\ y[i] = Rudy)(y[j] != Quentin /\ y[j] != Lancer);

include "globals.mzn";
constraint alldifferent(y);


output ["y = \(y);\n"];
