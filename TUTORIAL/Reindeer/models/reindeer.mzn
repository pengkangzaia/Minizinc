set of int: POS = 1..4;
enum REINDEER = { Lancer, Quentin, Ezekiel, Rudy };
array[REINDEER] of var POS: x;

% Lancer cant be next to Ezekiel
constraint abs(x[Lancer] - x[Ezekiel]) > 1;

% Rudy has to be ahead of Quentin or ahead of Lancer
constraint x[Rudy] < x[Quentin];
constraint x[Rudy] < x[Lancer];

% POS can't be the same
include "globals.mzn";
constraint alldifferent(x);

output ["x = array1d(REINDEER,\(x));\n"];
