int: planks;
set of int: PLANK = 1..planks;
array[PLANK] of int: plank_width;
int: pillars;
set of int: PILLAR = 1..pillars;
array[PILLAR] of int: pillar_height;
array[PILLAR] of int: pillar_width;

int: available_width;
int: available_height;
set of int: WIDTH = 0..available_width-1;
set of int: HEIGHT = 0..available_height-1; 

array[PLANK] of var WIDTH: xk;
array[PLANK] of var HEIGHT: yk;
array[PILLAR] of var WIDTH: xr;
array[PILLAR] of var HEIGHT: yr;
var 0..available_height: height = max(plank_maxy, pillar_maxy);
var 0..available_height: plank_maxy = max(k in PLANK)(yk[k] + plank_height[k]);
var 0..available_height: pillar_maxy = max(r in PILLAR)(yr[r] + pillar_height[r]);
var 0..available_width: plank_maxx = max(k in PLANK)(xk[k] + plank_width[k]);
var 0..available_width: pillar_maxx = max(r in PILLAR)(xr[r] + pillar_width[r]);
constraint max(plank_maxx, pillar_maxx) <= available_width;

array[PLANK] of var int: plank_height;
constraint forall(k in PLANK)(plank_height[k] = 1);
include "globals.mzn";
constraint diffn(xk ++ xr, yk ++ yr, plank_width ++ pillar_width, plank_height ++ pillar_height);
constraint cumulative(xk ++ xr, plank_width ++ pillar_width, plank_height ++ pillar_height, available_height);
constraint cumulative(yk ++ yr, plank_height ++ pillar_height, plank_width ++ pillar_width, available_width);

predicate plank_stability(var PLANK: k) = 
  exists(r1,r2 in PILLAR)(xk[k] >= xr[r1] /\ xk[k] < xr[r1] + pillar_width[r1] 
  /\ xk[k] + plank_width[k] > xr[r2] /\ xk[k] + plank_width[k] <= xr[r2] + pillar_width[r2] 
  /\ yk[k] = yr[r1] + pillar_height[r1] /\ yk[k] = yr[r2] + pillar_height[r2]);
constraint forall(k in PLANK)(plank_stability(k));

predicate pillar_stability(var PILLAR: r) = yr[r] = 0 \/
  exists(k in PLANK)(xk[k] <= xr[r] /\ xk[k] + plank_width[k] >= xr[r] + pillar_width[r] /\ yk[k] + plank_height[k] = yr[r]);
constraint forall(r in PILLAR)(pillar_stability(r));
solve minimize height;
%%%% output for grader   
output ["height = \(height);\n"];          
output ["xk = \(xk);\nyk = \(yk);\nxr = \(xr);\nyr = \(yr);\n"];             
                                          

                              
                                                                        
                  
                  