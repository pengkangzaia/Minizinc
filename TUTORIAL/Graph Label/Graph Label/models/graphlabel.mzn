var 1..8:a;
var 1..8:b;
var 1..8:c;
var 1..8:d;
var 1..8:e;
var 1..8:f;
var 1..8:g;
var 1..8:h;

constraint (a-b)>=2 \/ (b-a)>=2;
constraint (a-c)>=2 \/ (c-a)>=2;
constraint (a-d)>=2 \/ (d-a)>=2;

constraint (b-c)>=2 \/ (c-b)>=2;
constraint (b-e)>=2 \/ (e-b)>=2;
constraint (b-f)>=2 \/ (f-b)>=2;

constraint (c-d)>=2 \/ (d-c)>=2;
constraint (c-e)>=2 \/ (e-c)>=2;
constraint (c-f)>=2 \/ (f-c)>=2;
constraint (c-g)>=2 \/ (g-c)>=2;

constraint (d-f)>=2 \/ (f-d)>=2;
constraint (d-g)>=2 \/ (g-d)>=2;

constraint (e-f)>=2 \/ (f-e)>=2;
constraint (e-h)>=2 \/ (h-e)>=2;

constraint (f-g)>=2 \/ (g-f)>=2;
constraint (f-h)>=2 \/ (h-f)>=2;

constraint (g-h)>=2 \/ (h-g)>=2;

include "alldifferent.mzn";
constraint alldifferent([a,b,c,d,e,f,g,h]);

