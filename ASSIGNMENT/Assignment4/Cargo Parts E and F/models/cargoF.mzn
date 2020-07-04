int: NL; % number of loaders
         % number of rails = NL for parts A-E
         % number of rails = (NL + 1) div 2 for part F
opt bool: partF; % are we solving stage F
set of int: LOADER = 1..NL;

enum CARGO; 
array[CARGO] of int: size; % size in 10000 tonne units

int: makespan; % maximum time considered.
set of int: TIME = 0..makespan;

enum SHIP; % set of ships
array[CARGO] of SHIP: ship; % which ship takes stockpile
array[SHIP] of TIME: arrival;  % when ship arrives

int: len; % length of pad
set of int: POS = 0..len; 

int: build_time; % time to build 1 unit (10000 tonnnes)
int: load_time; % time to load 1 unit
int: load_speed; % time for loader to move 1 unit

array[CARGO] of var POS: westx;
array[CARGO] of var POS: eastx;
array[CARGO] of var TIME: build;
array[CARGO] of var TIME: endbuild;
array[CARGO] of var TIME: load;
array[CARGO] of var TIME: finish;
array[CARGO] of var LOADER: which;

% Part A: Packing the Pad
% cost_time: the time that one cargo on the pad
array[CARGO] of var TIME: cost_time = [ finish[i] - build[i] | i in CARGO ];
constraint eastx = [ westx[i] + size[i] | i in CARGO ];
constraint endbuild = [ build[i] + build_time * size[i] | i in CARGO ];
constraint finish = [ load[i] + load_time * size[i] | i in CARGO ];
% building must be finished before loading begins
constraint forall( i in CARGO )( load[i] >= endbuild[i] );
% No two cargoes can overlap in both time and position
include "diffn.mzn";
constraint diffn( westx, build, size, cost_time );

% Part B: Loader Assignment
% if cargo(i) and cargo(j) take the same loader, 
% then they should not be on the pad at the same time

% Part D: Loader Movement
% The intervel of loading two cargo by single loader 
% is larger than the cost time of moving loader
constraint forall(j, k in CARGO where j != k /\ which[j] == which[k])(finish[j] + load_speed * abs(eastx[j] - westx[k]) <= load[k] \/ finish[k] + load_speed * abs(eastx[k] - westx[j]) <= load[j]);

% Part C: Ship Constraints
% No cargo destined for a ship sh can be loaded before ship sh arrives in port
constraint forall(i in CARGO)(load[i] >= arrival[ship[i]]);
% No two cargoes can be loaded onto the same ship at the same time
constraint forall(i, j in CARGO where i != j /\ ship[i] == ship[j])(finish[i] <= load[j] \/ finish[j] <= load[i]);

% Part E: Objective
% Auxiliary array: ship_leave_time(when the ship leaving)
array[SHIP] of var TIME: ship_leave_time;
constraint forall(i in SHIP)(ship_leave_time[i] = max(j in CARGO where ship[j] == i)(finish[j]));
% No two cargoes can be loaded onto the same ship at the same time
array[SHIP] of var int: total_time = [ship_leave_time[i] - arrival[i] | i in SHIP];
var int: obj = sum(total_time);
solve minimize obj;

% Part F: Rail Constraints
% For two loaders of the same rail, loader1 (left, loading cargo1,2,3) and loader2 (right, loading cargo4,5,6) If there is a time overlap between cargo1 in the cargo set {1,2,3} and cargo5 in the cargo set{4,5,6}, then the eastx of cargo1 cannot be greater than the westx of cargo5

% Simplified version
% Check if two cargos that overlap in time belong to different loaders of the same rail,
% If yes, the eastx of the cargo belonging to the left loader cannot be greater than the westx of the cargo belonging to the right loader
predicate time_overlap(var CARGO: cargo0, var CARGO: cargo1) =
    finish[cargo0] >= load[cargo1] \/ finish[cargo1] >= load[cargo0];
  
predicate same_rail_diff_loader(var CARGO: cargo0, var CARGO: cargo1) = 
    ((which[cargo0]+1) div 2) == ((which[cargo1]+1) div 2) /\ which[cargo0] != which[cargo1];

constraint forall(i, j in CARGO 
    where i != j /\ time_overlap(i, j) /\ same_rail_diff_loader(i, j))
        (if which[i] < which[j] 
            then eastx[i] <= westx[j] 
         else eastx[j] <= westx[i] 
         endif);
         
%===================================================================================%
%======================codes for three loaders on the same rail======================%
%===================================================================================%     
% predicate same_rail_diff3_loader(var CARGO: cargo0, var CARGO: cargo1, var CARGO: cargo2) = 
%   ((which[cargo0]+1) div 3) == ((which[cargo1]+1) div 3) 
%   /\ ((which[cargo0]+1) div 3) == ((which[cargo2]+1) div 3) 
%   /\ which[cargo0] != which[cargo1] 
%   /\ which[cargo0] != which[cargo2] 
%   /\ which[cargo1] != which[cargo2];  
% constraint forall(i, j, k in CARGO 
%     where i != j /\ i != k /\ j != k 
%     /\ time_overlap(i, j) /\ time_overlap(i, k) /\ time_overlap(j, k)
%     /\ same_rail_diff3_loader(i, j, k))
%         (if which[i] < which[j] /\ which[j] < which[k] 
%             then eastx[i] <= westx[j] /\ eastx[j] <= westx[k]
%          elseif which[i] < which[k] /\ which[k] < which[j] 
%              then eastx[i] <= westx[k] /\ eastx[k] <= westx[j]
%          elseif which[j] < which[i] /\ which[i] < which[k] 
%              then eastx[j] <= westx[i] /\ eastx[i] <= westx[k]
%          elseif which[j] < which[k] /\ which[k] < which[i] 
%              then eastx[j] <= westx[k] /\ eastx[k] <= westx[i]
%          elseif which[k] < which[i] /\ which[i] < which[j] 
%              then eastx[k] <= westx[i] /\ eastx[i] <= westx[j]
%          else eastx[k] <= westx[j] /\ eastx[j] <= westx[i]
%          endif);
%===================================================================================%


output 
["westx  = array1d(CARGO,\(westx));\n"] ++
["eastx  = array1d(CARGO,\(eastx));\n"] ++
["build  = array1d(CARGO,\(build));\n"] ++
["endbuild  = array1d(CARGO,\(endbuild));\n"] ++
["load  = array1d(CARGO,\(load));\n"] ++
["finish  = array1d(CARGO,\(finish));\n"] ++
["which  = array1d(CARGO,\(which));\n"] 
;

% include "viz/cargo_viz.mzn";
% output [cargo_viz(westx,eastx,build,endbuild,load,finish,which,obj)];
include "../viz/cargo_viz.mzn";
output [cargo_viz(westx,eastx,build,endbuild,load,finish,which,obj)];
