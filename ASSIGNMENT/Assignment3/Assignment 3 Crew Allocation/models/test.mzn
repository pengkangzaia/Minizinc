%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIT5216
%
% Assignment 3: Crew allocation problem
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The available staff
enum STAFF;

% The weekly salary of each staff member
array[STAFF] of int: salary;

% The set of skills
enum SKILL;

% The competence level of each staff member for each skill
array[STAFF,SKILL] of int: competence;

% The set of vehicles
enum VEHICLE;

% The number of weeks to schedule
int: n_weeks;
set of int: WEEKS = 1..n_weeks;

% The competence level required for each skill, vehicle and week
array[WEEKS,VEHICLE,SKILL] of int: required_competence;

% The maximum number of consecutive weeks a staff member may work
% 0 means there is no limit
int: max_consecutive;

% The maximum number of weeks in a row that two staff members can be allocated
% to the same vehicle
% 0 means there is no limit
int: max_together;

% Decision variables: the crew allocated to each vehicle per week
array[WEEKS,VEHICLE] of var set of STAFF: allocation;
array[WEEKS,STAFF] of var 0..1: work_c;

% Objective 1 (basic model): the overall cost of the allocation
var int: cost = sum(w in WEEKS, v in VEHICLE, a in allocation[w, v]) (salary[a]);

% Objective 2 (Part 2.3): the overall competence of the allocation
var int: overall_competence = sum(w in WEEKS, v in VEHICLE, a in allocation[w, v], s in SKILL) (competence[a, s]);

% !!! Remove for Part 2.3 !!!
% constraint overall_competence = 0; %% <<== Remove this constraint for Part 2.3

% My constraints
% 1. For each skill, the combined competence of the crew in that skill is at least as much as is required. 
constraint forall(w in WEEKS, v in VEHICLE, s in SKILL) (
    sum(a in allocation[w, v]) (competence[a, s]) >= required_competence[w, v, s]);

% 2. Each sta member can be allocated to at most one vehicle per week.
constraint forall(w in WEEKS, v1,v2 in VEHICLE where v2>v1) (
    allocation[w, v1] intersect allocation[w, v2] = {});
    
% 3. Any two sta members are only working together on the same vehicle at most max together weeks in a row.
% constraint forall(v in VEHICLE, w1,w2 in 1..n_weeks where w2>w1) (
%     card(allocation[w1, v] intersect allocation[w2, v]) <= max_together);
include "globals.mzn";
set of int: WEEKSC = 1..2*n_weeks;
predicate together(var STAFF: s1, var STAFF: s2)=
    let{array[WEEKS] of var 0..1: together=[sum(v in VEHICLE)
    (s1 in allocation[w,v] /\ s2 in allocation[w,v])|w in WEEKS];
    array[WEEKSC] of var 0..1: togetherc = together ++ together;}
    in sliding_sum(0, max_together, max_together+1, togetherc);
           
constraint forall(s1, s2 in STAFF where s1<s2) (
    if max_together != 0 /\ length(SKILL) <= 6
    then together(s1, s2)
    endif);

% 4. Any sta member only works for at most max consecutive weeks in a row.
predicate consecutive(var STAFF: s) =  
    let{array[WEEKS] of var 0..1: consecutive = [sum(v in VEHICLE) 
    (s in allocation[w, v])|w in WEEKS];
    array[WEEKSC] of var 0..1: consecutivec = consecutive ++ consecutive;}
    in sliding_sum(0, max_consecutive, max_consecutive+1, consecutivec);

constraint forall(s in STAFF) (
    if max_consecutive != 0
    then consecutive(s)
    endif);

% Overall objective
var int: objective;

% !!! Replace this constraint with your own definition of the objective !!!
constraint objective = 10*cost - overall_competence; %% <<== Replace

solve minimize objective;

% Output
% USE EXACTLY THIS OUTPUT FORMAT FOR THE ONLINE SUBMISSION

output ["allocation = array2d(WEEKS,VEHICLE,\(allocation));\n",
        "objective = \(objective);\n",
        "cost = \(cost);\n",
        "overall_competence = \(overall_competence);\n"];
