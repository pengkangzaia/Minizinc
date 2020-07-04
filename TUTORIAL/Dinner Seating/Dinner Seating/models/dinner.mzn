enum PERSON;
array[int,1..2] of PERSON: couple;
array[int,1..2] of PERSON: rivals;

int: n = card(PERSON);
set of int: SEAT = 1..n;
array[SEAT] of var PERSON: person;
array[PERSON] of var SEAT: pos;

include "globals.mzn";
constraint alldifferent(person);
constraint inverse(person, pos);

% constraint： Each couple must be either seated adjacent or far apart.
predicate adjacent(PERSON: x, PERSON: y) = abs(pos[x] - pos[y]) = 1 \/ abs(pos[x] - pos[y]) = n - 1 \/ (abs(pos[y]-pos[x]) > (n div 3) /\ n - abs(pos[y]-pos[x]) > (n div 3));
% predicate farApart(var int: x, var int: y) = abs(y-x) >= (n div 3) + 1 /\ n - abs(y-x) >= (n div 3) + 1;

constraint forall(i in index_set_1of2(couple))((adjacent(couple[i, 1], couple[i, 2])));

solve maximize sum(i in index_set_1of2(rivals))(adjacent(rivals[i, 1], rivals[i, 2]));

output ["person = \(person)"];
