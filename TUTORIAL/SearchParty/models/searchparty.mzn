enum DIRN = {n,e,s,w};

var DIRN: A;
var DIRN: B;
var DIRN: C;
var DIRN: D;
var DIRN: E;
var DIRN: F;

var set of DIRN : POINT = {A,B,C,D,E,F};

% Each direction must have at least 1 searcher.
constraint sum(i in POINT)(i = n) >= 1;
constraint sum(i in POINT)(i = e) >= 1;
constraint sum(i in POINT)(i = s) >= 1;
constraint sum(i in POINT)(i = w) >= 1;

% If A searches n or s then B cannot search n or s.
constraint if A = n \/ A = s then B != s /\ B != n endif;

% C and D must search in opposite directions.
constraint (C = n /\ D = s) \/ (C = s /\ D = n)
        \/ (C = e /\ D = w) \/ (C = w /\ D = e);

% If either E or F go w then no one else can search that direction.
constraint (E = w \/ F = w -> forall(i in POINT where i != E \/ i != F)(i != w));
     
% The pairs (A,E), (B,F), (C,E) can't search the same direction.
constraint A != E /\ B != F /\ C != E;





