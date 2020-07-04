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

% Objective 1 (basic model): the overall cost of the allocation
var int: cost = sum(i in 1..n_weeks, j in VEHICLE)
                   (sum(s in allocation[i, j])
                       (salary[s]));

% Objective 2 (Part 2.3): the overall competence of the allocation
var int: overall_competence;

% 2.3: the overall competence of the allocation
constraint overall_competence = sum(w in 1..n_weeks, v in VEHICLE)
                                   (sum(i in allocation[w, v], s in SKILL)
                                       (competence[i, s]));

% Overall objective
var int: objective;

% The cost is simply the sum over the salaries of each allocated staff member, per vehicle and week.
constraint objective = 10 * cost - 1 * overall_competence;

% 2.1
% For each skill, the combined competence of the crew in that skill is at least as much as is
% required.
constraint forall(i in 1..n_weeks, j in VEHICLE, k in SKILL)
              (sum(s in allocation[i, j])
                  (competence[s, k]) >= required_competence[i, j, k]);

% 2.1
% Each staff member can be allocated to at most one vehicle per week.
% element in allocation for different vehicles can not be the same 
constraint forall(i in 1..n_weeks, j, k in VEHICLE where j < k)
               ((allocation[i, j] intersect allocation[i, k]) = {});

% 2.2: Method 1
% If max together=0,, it means that there is no constraint
% constraint if max_together > 0 
%            then 
%                 forall(i, j in STAFF,w in 1..n_weeks, v in VEHICLE where i < j)
%                     (if
%                          % if any two staff members work together in (max_together - 1) weeks
%                          forall(k in 1..max_together - 1)
%                              ({i, j} subset allocation[((w + k - 1) mod n_weeks) + 1, v])
%                      then
%                          % then next week they will not work together
%                          ({i, j} intersect allocation[((w + max_together - 1) mod n_weeks) + 1, v] != {i, j} )
%                      endif) 
%            endif;  
           
% %%If max consecutive=0, it means that there is no constraint
% constraint if max_consecutive > 0 
%            then 
%                 forall(i in STAFF,w in 1..n_weeks)
%                     (if
%                          % if any staff member has worked for (max_consecutive - 1) weeks
%                          forall(k in 1..max_consecutive - 1)
%                              (sum(v in VEHICLE)
%                                  (card({i} intersect allocation[((w + k - 1) mod n_weeks) + 1, v])) >= 1)
%                      then
%                          % then he need to take a week off
%                          sum(v in VEHICLE)
%                              (card({i} intersect allocation[((w + max_consecutive - 1) mod n_weeks) + 1, v])) = 0 
%                      endif) 
%            endif;

% 2.2 Method 2
include "globals.mzn";
set of int: WEEKST = 1..2*n_weeks;
predicate together(var STAFF: s1, var STAFF: s2)=
    let{
        array[WEEKS] of var 0..1: together =
            [sum(v in VEHICLE)
                (s1 in allocation[w,v] /\ s2 in allocation[w,v]) | w in WEEKS];
        % Make sure that togetherc won't access out of boundary in the last few days
        array[WEEKST] of var 0..1: togetherc = 
            together ++ together;}
    in 
        % in each sequence togetherc[i]..togetherc[i+max_together] 
        % the sum of value belongs to the interval [0, max_together]
        sliding_sum(0, max_together, max_together+1, togetherc);
           
constraint if 
               max_together != 0
           then 
               forall(s1, s2 in STAFF where s1 < s2)(together(s1, s2))
           endif;
    
predicate consecutive(var STAFF: s) =  
    let
       {array[WEEKS] of var 0..1: consecutive = 
           [sum(v in VEHICLE)(s in allocation[w, v]) | w in WEEKS];
        array[WEEKST] of var 0..1: consecutivec = 
            consecutive ++ consecutive;}
    in 
        sliding_sum(0, max_consecutive, max_consecutive+1, consecutivec);

constraint if 
               max_consecutive > 0
           then 
               forall(s in STAFF)(consecutive(s))
           endif;
           
solve minimize objective;

% Output
% USE EXACTLY THIS OUTPUT FORMAT FOR THE ONLINE SUBMISSION

output ["allocation = array2d(WEEKS,VEHICLE,\(allocation));\n",
        "objective = \(objective);\n",
        "cost = \(cost);\n",
        "overall_competence = \(overall_competence);\n"];
