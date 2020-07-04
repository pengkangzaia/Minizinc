string: viz_cargo_file_path = file_path()++".html";

function string: cargo_viz(array[CARGO] of var int: westend,
  array[int] of var int:eastend,
  array[int] of var int:stack,
  array[int] of var int:endstack,
  array[int] of var int:load,
  array[int] of var int:finish,
  array[int] of var int:which) =
  "%%%mzn-json:"++viz_cargo_file_path++"\n"++
    "{\"load_speed\":\(load_speed), \"piles\":[" ++
    concat(
    [join(", \n",["{\"westend\":\(westend[i]), "++
     "\"eastend\":\(eastend[i]), "++
     "\"stack\":\(stack[i]), "++
     "\"endstack\":\(endstack[i]), "++
     "\"load\":\(load[i]), "++
     "\"finish\":\(finish[i]), "++
     "\"which\":\(which[i]), "++
     "\"shiparrival\":\(arrival[ship[i]]), "++
     "\"ship\":\(ship[i]+0)}" | i in index_set(westend)])])
    ++"]}\n%%%mzn-json-end\n";


function string: cargo_viz(array[CARGO] of var int: westend,
  array[int] of var int:eastend,
  array[int] of var int:stack,
  array[int] of var int:endstack,
  array[int] of var int:load,
  array[int] of var int:finish,
  array[int] of var int:which, var int: obj) =
  "%%%mzn-json:"++viz_cargo_file_path++"\n"++
    "{\"obj\":\(obj), \"load_speed\":\(load_speed), \"piles\":[" ++
    concat(
    [join(", \n",["{\"westend\":\(westend[i]), "++
     "\"eastend\":\(eastend[i]), "++
     "\"stack\":\(stack[i]), "++
     "\"endstack\":\(endstack[i]), "++
     "\"load\":\(load[i]), "++
     "\"finish\":\(finish[i]), "++
     "\"which\":\(which[i]), "++
     "\"shiparrival\":\(arrival[ship[i]]), "++
     "\"ship\":\(ship[i]+0)}" | i in index_set(westend)])])
    ++"]}\n%%%mzn-json-end\n";

