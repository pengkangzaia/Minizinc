
enum PLAYER = {Ant, Bee, Chu, Deb, Eve, Fin, Ged, Hel, Ila, Jan, Kim};

enum CAPTAIN = {Xavier, Yuri, Zena};

set of PLAYER : goalie = {Ant, Bee};
set of PLAYER : defence = {Chu, Deb, Eve, Fin};
set of PLAYER : offence = {Ged, Hel, Ila, Jan, Kim};


array[CAPTAIN,PLAYER] of int: value = 
   [| 2, 5, 6, 8, 9, 5, 8, 7, 7, 4, 6
    | 9, 8, 4, 7, 6, 4, 5, 3, 5, 5, 7
    | 8, 4, 3, 3, 6, 2, 5, 5, 3, 2, 5 |];

var set of PLAYER: xavier;
var set of PLAYER: yuri;
var set of PLAYER: zena;


constraint card(xavier intersect yuri) <= 2;
constraint card(xavier intersect zena) <= 2;

% six members in the team
int : size = 6; 
constraint card(xavier) = size;
constraint card(yuri) = size;
constraint card(zena) = size;

constraint card(xavier intersect goalie) >= 1;
constraint card(xavier intersect defence) >= 2;
constraint card(xavier intersect offence) >= 2;

constraint card(yuri intersect goalie) >= 1;
constraint card(yuri intersect defence) >= 2;
constraint card(yuri intersect offence) >= 2;

constraint card(zena intersect goalie) >= 1;
constraint card(zena intersect defence) >= 2;
constraint card(zena intersect offence) >= 2;

%var int  : MaxValue = sum(i in xavier)(value[Xavier,i])+sum(i in yuri)(value[Yuri,i])+sum(i in zena)(value[Zena,i]);

solve maximize sum(i in xavier)(value[Xavier,i])+
sum(i in yuri)(value[Yuri,i])+
sum(i in zena)(value[Zena,i]);


output ["xavier = \(xavier);\nyuri = \(yuri);\nzena = \(zena);\n"];

