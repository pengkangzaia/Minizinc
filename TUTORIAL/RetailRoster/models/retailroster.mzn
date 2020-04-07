enum SHIFT = { opening, morning, lunch, afternoon, closing };
enum DAY = { MON, TUE, WED, THU, FRI, SAT, SUN };
enum PERSON;
array[PERSON,DAY,SHIFT] of int: pref;

array[PERSON,DAY] of var set of SHIFT: r;

array[PERSON, DAY] of var int : ope;
array[PERSON, DAY] of var int : mor;
array[PERSON, DAY] of var int : lun;
array[PERSON, DAY] of var int : aft;
array[PERSON, DAY] of var int : clo;

ope = array2d(PERSON, DAY, [sum(m in r[i ,j])(m = opening) | i in PERSON, j in DAY]);
mor = array2d(PERSON, DAY, [sum(m in r[i ,j])(m = morning) | i in PERSON, j in DAY]);
lun = array2d(PERSON, DAY, [sum(m in r[i ,j])(m = lunch) | i in PERSON, j in DAY]);
aft = array2d(PERSON, DAY, [sum(m in r[i ,j])(m = afternoon) | i in PERSON, j in DAY]);
clo = array2d(PERSON, DAY, [sum(m in r[i ,j])(m = closing) | i in PERSON, j in DAY]);

% Each person can take at most two shifts a day
constraint forall(i in PERSON, j in DAY)(card(r[i,j]) <= 2);

% A person who is closing cannot be on afternoon.     
% A person who is on morning cant be on opening.             
% A person who is on closing cant be on opening.
constraint forall(i in PERSON, j in DAY where clo[i, j] = 1)(aft[i, j] != 1);
constraint forall(i in PERSON, j in DAY where mor[i, j] = 1)(ope[i, j] != 1);
constraint forall(i in PERSON, j in DAY where clo[i, j] = 1)(ope[i, j] != 1);

% There needs to be at exactly one person on opening and closing, at least 2 people on
% morning and lunch and at least 3 people on afternoon.
constraint forall(j in DAY)(sum(i in PERSON)(ope[i, j]) = 1);
constraint forall(j in DAY)(sum(i in PERSON)(clo[i, j]) = 1);
constraint forall(j in DAY)(sum(i in PERSON)(mor[i, j]) >= 2);
constraint forall(j in DAY)(sum(i in PERSON)(lun[i, j]) >= 2);
constraint forall(j in DAY)(sum(i in PERSON)(aft[i, j]) >= 3);

% There needs to be at least 8 people in total assigned to opening, morning and lunch.
% There needs to be at least 8 people in total assigned to lunch, afternoon and closing.
constraint forall(j in DAY)(sum(i in PERSON)(ope[i, j]) + sum(i in PERSON)(mor[i, j]) + sum(i in PERSON)(lun[i, j]) >= 8);
constraint forall(j in DAY)(sum(i in PERSON)(lun[i, j]) + sum(i in PERSON)(aft[i, j]) + sum(i in PERSON)(clo[i, j]) >= 8);

% No person can be assigned a shift ofn a day when their preference for that shift is 0.
constraint forall(i in PERSON, j in DAY, k in SHIFT where pref[i, j, k] = 0)(forall(m in r[i, j])(m != k));

output ["r = array2d(PERSON,DAY,\(r));\n"];                                      
