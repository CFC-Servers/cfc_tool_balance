# CFC Tool Balance
A collection of scripts to balance garrysmod tools. 

## Adding new scripts
Scripts should be added to `lua/tool_balance/tools/<category>/scriptname.lua` e.g. `lua/tool_balance/tools/wire/turret.lua`

# Dependencies
[CFC Waiter](https://github.com/CFC-Servers/cfc_waiter)

# Helper functions in util.lua
- ##### cfcToolBalance.clampFunction( func, min_max_values )

  Takes a function and a list of min max values, returning a new function that when called clamps each argument before calling the original function.
  If a table with no min and max keys is used the argument will not be clamped. 
  
  example: 
  
    `cfcToolBalance.clampFunction( func, { {min=0, max=10}, {}, {min=10, max=20} })`
  
- ##### cfcToolBalance.clampMethod( func, min_max_values )

  Does the same thing as clampFunction but ignores the first argument. Used to ignore self in methods
  
- ##### cfcToolBalance.callAfter( func, afterFunc )
  returns a new function that calls `afterFunc` after callin `func` the new function will return  the value returned by `func`
  
## Balanced tools
###### wire/explosive
clamps the damage blastradius and reloadtime on the `gmod_wire_explosive`

###### wire/turret
Clamps the damage, firerate, spread, force and number of bullets on the `gmod_wire_turret`

###### simfphys/geareditor
clamps the `numgears` value on the simfphys gear editor. Using a high number of gears would crash the server.

###### base/emitter.lua
Clamps the delay between emitter activates

###### base/turret
Clamps the damage, firerate, spread, force and number of bullets on the `gmod_turret`
