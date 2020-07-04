% lineup problem: make sure all adjacent people in the lineup are compatible
enum PERSON;
enum GENDER = { Male, Female, Other};
array[PERSON] of int: age;
array[PERSON] of int: height;
array[PERSON] of GENDER: gender;

set of int: POS = 1..card(PERSON);
array[POS] of var PERSON: person;

% each person appears in exactly one position
include "alldifferent.mzn";
constraint alldifferent(person);

% each two adjacent people are compatible
constraint forall(i in 1..card(PERSON)-1)
                 (compatible(person[i],person[i+1]));
           
% Two people are compatible if
%     + their ages differ by at least 10
%     + their genders are different, or
%     + their heights differ by at least 10     
predicate compatible(var PERSON: p1, var PERSON: p2) = abs(age[p1] - age[p2]) >= 10 \/ gender[p1] != gender[p2] \/ abs(height[p1] - height[p2]) >= 10;
                      