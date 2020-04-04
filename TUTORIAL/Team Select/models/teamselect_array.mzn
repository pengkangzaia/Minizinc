
enum PLAYER = {Ant, Bee, Chu, Deb, Eve, Fin, Ged, Hel, Ila, Jan, Kim};


enum CAPTAIN = {Xavier, Yuri, Zena};

array[CAPTAIN,PLAYER] of int: value = 
   [| 2, 5, 6, 8, 9, 5, 8, 7, 7, 4, 6
    | 9, 8, 4, 7, 6, 4, 5, 3, 5, 5, 7
    | 8, 4, 3, 3, 6, 2, 5, 5, 3, 2, 5 |];

set of int: POS = 1..6;


set of int : goalie = {1,2};
set of int : defence = {3,4,5,6};
set of int : offence = {7,8,9,10,11};
array[CAPTAIN,POS] of var PLAYER: team;
constraint sum(i in POS)(team[Xavier,i] in goalie)>=1;
constraint sum(i in POS)(team[Xavier,i] in defence)>=2;
constraint sum(i in POS)(team[Xavier,i] in offence)>=2;

constraint sum(i in POS)(team[Yuri,i] in goalie)>=1;
constraint sum(i in POS)(team[Yuri,i] in defence)>=2;
constraint sum(i in POS)(team[Yuri,i] in offence)>=2;

constraint sum(i in POS)(team[Zena,i] in goalie)>=1;
constraint sum(i in POS)(team[Zena,i] in defence)>=2;
constraint sum(i in POS)(team[Zena,i] in offence)>=2;

var set of int : xavier = {team[Xavier,1],team[Xavier,2],team[Xavier,3],team[Xavier,4],team[Xavier,5],team[Xavier,6]};
var set of int : yuri = {team[Yuri,1],team[Yuri,2],team[Yuri,3],team[Yuri,4],team[Yuri,5],team[Yuri,6]};
var set of int : zena = {team[Zena,1],team[Zena,2],team[Zena,3],team[Zena,4],team[Zena,5],team[Zena,6]};

constraint forall(i in CAPTAIN)(forall(j in 1..5)(team[i,j]<team[i,j+1]));

constraint card(xavier intersect yuri) <=2;
constraint card(xavier intersect zena) <=2;

solve maximize sum(i in CAPTAIN)(sum(j in POS)(value[i,team[i,j]]));

output ["team = array2d(CAPTAIN,POS,\(team));\n"];

