include "globals.mzn";

enum VACCINE;

enum AGE = { BABY, CHILD, YOUTH, ADULT, SENIOR, AGED, ANCIENT };
enum GENDER = { FEMALE, MALE, OTHER };
enum HEALTH = { GOOD, POOR, COMPROMISED };
enum EXPOSURE = { LOW, AVERAGE, HIGH, EXTREME };

int: m; % number of groups
set of int: GROUP = 1..m;
array[GROUP] of AGE: age;           % age of the group
array[GROUP] of GENDER: gender;     % gender of the group
array[GROUP] of HEALTH: health;     % underlying health of the group
array[GROUP] of EXPOSURE: exposure; % exposure for the group
array[GROUP] of int: size;          % number of people in the group

int: minsize;                       % min number of people is a group/vaccine trial
array[AGE] of int: age_group_min;   % min number of groups for each age
array[AGE] of int: age_group_max;   % max number of groups for each age
int: max_people_diff;               % max diff in total people trial on diff vaccines
int: max_share_vaccines;            % max number of shared vaccines by groups

array[HEALTH] of int: health_information;      % value of information by health
array[EXPOSURE] of int: exposure_information;  % value of information by exposre

array[GROUP] of var set of VACCINE: x;
% array[VACCINE] of var set of GROUP: y;
% constraint inverse(x, y);

constraint forall(i in GROUP)(
               card(x[i]) * minsize <= size[i]);

constraint forall(i in VACCINE, j in AGE)(
               sum(k in GROUP where i in x[k])(age[k] = j) <= age_group_max[j] 
            /\ sum(k in GROUP where i in x[k])(age[k] = j) >= age_group_min[j]);

constraint forall(i,j in VACCINE where i < j)
               (
                   abs(sum(k in GROUP where i in x[k])(size[k] div card(x[k]))
                     - sum(k in GROUP where j in x[k])(size[k] div card(x[k]))) 
                     <= max_people_diff
                );
constraint forall(i,j in VACCINE, k in GENDER where i < j)(
               sum(l in GROUP where i in x[l])(gender[l] = k) 
             = sum(l in GROUP where j in x[l])(gender[l] = k));
             
constraint forall(i,j in GROUP where i < j)(
               card(x[i] intersect x[j]) <= max_share_vaccines);

array[VACCINE,HEALTH,EXPOSURE] of var int : info_dup;

constraint forall(i in VACCINE, j in HEALTH, k in EXPOSURE)(
               info_dup[i,j,k] = 
                   sum(m in GROUP where i in x[m])(
                       health[m] = j /\ exposure[m] = k));

array[VACCINE] of var int: info;
% constraint forall(i in VACCINE)(info[i] = sum(j in GROUP where i in x[j])( health_information[health[j]]*exposure_information[exposure[j]]));
% solve maximize min(info);
constraint forall(i in VACCINE)(
               info[i]=
                   sum(j in HEALTH, k in EXPOSURE)(
                       if info_dup[i,j,k]=1 
                           then health_information[j]*exposure_information[k] 
                       elseif info_dup[i,j,k]>1 
                           then health_information[j]*exposure_information[k] + info_dup[i,j,k] - 1 
                       else 0 
                       endif));
                       
solve maximize min(info);

output ["x = array1d(GROUP,\(x));\n"];
