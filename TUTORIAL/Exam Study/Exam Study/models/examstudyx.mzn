enum TOPIC;
array[TOPIC] of int: hours;
int: m; % precedences
set of int: PREC = 1..m;
array[PREC] of TOPIC: before;
array[PREC] of TOPIC: after;
set of TOPIC: morning;
int: D; 
int: H;
set of int: DAY = 1..D;
set of DAY: HALF;

set of int: TIME = 0..D*H;
array[TOPIC] of var TIME: start;

constraint forall(i in PREC)(start[before[i]] + hours[before[i]] <= start[after[i]]);
constraint forall(i in morning)(start[i] mod H == 0);
constraint forall(i in HALF)(forall(j in TOPIC)(start[j]+hours[j]<=((i-1)*H+(H div 2)) \/ i*H<=start[j]));
constraint forall(i in TOPIC)(start[i]+hours[i]<=D*H);
constraint forall(i in TOPIC)(start[i]+hours[i]<=(start[i] div H)*H+H-1);

predicate nonoverlap(var int:s1, var int: d1, var int:s2,var int:d2)=
s1+d1<=s2\/s2+d2<=s1;
constraint forall(i,j in TOPIC where i != j)(nonoverlap(start[i],hours[i],start[j],hours[j]));

%var TIME : first = min(start);

solve maximize min(start); 



/*** debug output ***
array[1..20] of string: key = ["*","+","$","%","@","#","&","=","-",":","a","b","c","d","e","f","g","h","i","j"];
output [ "| day " ++ show_int(6-H,d) | d in DAY ] ++ ["|\n"]; 
output [ let { int: j = arg_max([ fix(start[t]) <= i /\ fix(start[t]) + hours[t] > i | t in TOPIC ] ++ [ true]); } in
         if j <= n then key[j] 
         elseif (i div H) + 1 in HALF /\ i mod H >= H div 2 then "."
         else " " endif
       | i in TIME ];  
*** end debug output ***/        
       
/*** grading output ***/       
output ["\nstart = \(start);\n"];     