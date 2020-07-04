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
% leaving - arrival time = staying in the port
array[SHIP] of var int: total_time = [ship_leave_time[i] - arrival[i] | i in SHIP];
var int: obj = sum(total_time);
solve minimize obj;


output 
["westx  = array1d(CARGO,\(westx));\n"] ++
["eastx  = array1d(CARGO,\(eastx));\n"] ++
["build  = array1d(CARGO,\(build));\n"] ++
["endbuild  = array1d(CARGO,\(endbuild));\n"] ++
["load  = array1d(CARGO,\(load));\n"] ++
["finish  = array1d(CARGO,\(finish));\n"] ++
["which  = array1d(CARGO,\(which));\n"] 
;

% include "../viz/cargo_viz.mzn";
% output [cargo_viz(westx,eastx,build,endbuild,load,finish,which,obj)];
