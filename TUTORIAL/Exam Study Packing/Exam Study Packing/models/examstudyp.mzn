enum TOPIC;
int: n = card(TOPIC);
array[TOPIC] of int: hours;
int: m; % precedences
set of int: PREC = 1..m;
array[PREC] of TOPIC: before;
array[PREC] of TOPIC: after;
set of TOPIC: morning;
int: D; 
int: H;
constraint assert(H mod 2 = 0,"Hours per day H must be even\n");
set of int: DAY = 1..D;
set of DAY: HALF;

set of int: HOUR = 0..H-1;
array[TOPIC] of var DAY: day;
array[TOPIC] of var HOUR: hour;

% 每个topic只会出现在一天中，所以只要比较两个topic的开始时间就可以确定先后顺序（day之间不能等于）
constraint forall(i in PREC)(day[before[i]]<day[after[i]]);
% 每个topic必须在一天内完成,因此topic的day不一样。
include "globals.mzn";
constraint alldifferent(day);
% include "diffn.mzn";
% constraint diffn(hour,day,hours,hours);
% topic的开始时间加持续时间小于一天中hour的最大值
constraint forall(i in TOPIC)(hour[i]+hours[i]<=H);
% 有些topic必须在早上0时刻就开始
constraint forall(i in morning)(hour[i]==0);
% 有些days只允许在早上复习，而不能在下午复习（说明在这些天复习的topic必须在下午之前结束）
constraint forall(i in HALF,j in TOPIC where day[j]=i)(hour[j]+hours[j]-1<=((H-1) div 2));

array[TOPIC] of var 0..D*(H-1):start;
constraint start = [(day[i]-1)*H+hour[i]|i in TOPIC];
solve maximize min(start);




/*** debug output
array[1..20] of string: key = ["*","+","$","%","@","#","&","=","-",":","a","b","c","d","e","f","g","h","i","j"];
output [ "\(TOPIC[i]) \"" ++ key[i] ++ "\", " | i in 1..n ] ++ ["HALF \".\"\n"];
output [ if h = 0 then "day " ++ show_int(2,d) ++ " " else "" endif ++
         let { int: i = (d-1)*H + h; 
               int: j = arg_max([ fix(start[t]) <= i /\ fix(start[t]) + hours[t] > i | t in TOPIC ] ++ [ true]); } in
         if j <= n then key[j] 
         elseif d in HALF /\ h >= H div 2 then "."
         else " " endif ++
         if h = H-1 then "\n" else "" endif 
       | d in DAY, h in HOUR ];   
****/

%% output for grading       
output ["day = \(day);\nhour = \(hour);\n"];       
       
       