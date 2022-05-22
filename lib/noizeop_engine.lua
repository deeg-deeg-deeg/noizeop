local NoizeOp = {}
local Formatters = require 'formatters'


local specs = {
  
  ["freq01"] = controlspec.new(0, 20000, "lin", 0, 20, "Hz"),
  ["freq02"] = controlspec.new(0, 20000, "lin", 0, 20, "Hz"),
  ["freq03"] = controlspec.new(0, 20000, "lin", 0, 20, "Hz"),
  ["freq04"] = controlspec.new(0, 20000, "lin", 0, 20, "Hz"),

  ["mul01"] = controlspec.new(0.01, 10, "lin", 0, 1, ""),
  ["mul02"] = controlspec.new(0.01, 10, "lin", 0, 1, ""),
  ["mul03"] = controlspec.new(0.01, 10, "lin", 0, 1, ""),
  ["mul04"] = controlspec.new(0.01, 10, "lin", 0, 1, ""),

  ["a_mod_01"] = controlspec.new(0.1, 1000, "lin", 0, 1, ""),
  ["a_mod_02"] = controlspec.new(0.1, 1000, "lin", 0, 1, ""),
  ["a_mod_03"] = controlspec.new(0, 100, "lin", 0, 1, ""),
  ["a_mod_04"] = controlspec.new(0.1, 5, "lin", 0, 1, ""),
  ["a_mod_05"] = controlspec.new(1, 10, "lin", 0, 1, ""),
  ["a_mod_06"] = controlspec.new(1, 10, "lin", 0, 1, ""),

  ["a_vol_01"] = controlspec.new(0, 10, "lin", 0, 1, ""),
  ["a_vol_02"] = controlspec.new(0, 10, "lin", 0, 0, ""),
  ["a_vol_03"] = controlspec.new(0, 10, "lin", 0, 0, ""),
  ["a_vol_04"] = controlspec.new(0, 10, "lin", 0, 0, ""),
  ["a_vol_05"] = controlspec.new(0, 10, "lin", 0, 0, ""),
  ["a_vol_06"] = controlspec.new(0, 10, "lin", 0, 0, ""),

  ["ffreq01"] = controlspec.new(1, 20000, "lin", 0, 1, "Hz"),
  ["q01"] = controlspec.new(0.01, 5, 'lin', 0, 1, ""),
  ["ffreq02"] = controlspec.new(1, 20000, "lin", 0, 20000, "Hz"),
  ["q02"] = controlspec.new(0.01, 5, 'lin', 0, 1, ""),
  ["ffreq03"] = controlspec.new(1, 20000, "lin", 0, 20000, "Hz"),
  ["q03"] = controlspec.new(0.01, 5, 'lin', 0, 1, "")
  
  
}


local mnames = {
  

  ["freq01"] = "OSC 01 Frequency",
  ["freq02"] = "OSC 02 Frequency",
  ["freq03"] = "OSC 03 Frequency",
  ["freq04"] = "OSC 04 Frequency",

  ["mul01"] = "OSC 01 Volume",
  ["mul02"] = "OSC 02 Volume",
  ["mul03"] = "OSC 03 Volume",
  ["mul04"] = "OSC 04 Volume",

  ["a_mod_01"] = "Algo 01 Modultation",
  ["a_mod_02"] = "Algo 02 Modultation",
  ["a_mod_03"] = "Algo 03 Modultation",
  ["a_mod_04"] = "Algo 04 Modultation",
  ["a_mod_05"] = "Algo 05 Modultation",
  ["a_mod_06"] = "Algo 06 Modultation",

  ["a_vol_01"] = "Algo 01 Volume",
  ["a_vol_02"] = "Algo 02 Volume",
  ["a_vol_03"] = "Algo 03 Volume",
  ["a_vol_04"] = "Algo 04 Volume",
  ["a_vol_05"] = "Algo 05 Volume",
  ["a_vol_06"] = "Algo 06 Volume",

  ["ffreq01"] = "Filter01 Freq",
  ["q01"] = "Filter01 Q",
  ["ffreq02"] = "Filter02 Freq",
  ["q02"] = "Filter02 Q",
  ["ffreq03"] = "Filter02 Freq",
  ["q03"] = "Filter02 Q"
  
}
-- this table establishes an order for parameter initialization:
local param_names = {"freq01", "freq02", "freq03", "freq04", "mul01", "mul02", "mul03", "mul04", "a_mod_01", "a_mod_02", "a_mod_03", "a_mod_04", "a_mod_05", "a_mod_06", "a_vol_01", "a_vol_02", "a_vol_03", "a_vol_04", "a_vol_05", "a_vol_06", "ffreq01", "q01", "ffreq02", "q02", "ffreq03", "q03"}

-- initialize parameters:
function NoizeOp.add_params()
  params:add_separator("Noize Mod")

  for i = 1,26 do
    local p_name = param_names[i]
    local x_name = mnames[i]
    params:add{
      type = "control",
      id = p_name,
      name = mnames[p_name],
      controlspec = specs[p_name],
      formatter = p_name == "pan" and Formatters.bipolar_as_pan_widget or nil,
      -- every time a parameter changes, we'll send it to the SuperCollider engine:
      action = function(x) engine[p_name](x) end
    }
  end
  
  

  params:add_separator("Random Freq Settings")
  
  params:add_control("rnd_speed", "rnd speed", controlspec.new(1, 10000, "lin", 0, 1, ""))
  params:add_control("possy", "possibility", controlspec.new(1, 100, "lin", 0, 10, ""))
  params:add_control("poss_lim", "limit", controlspec.new(1, 10000, "lin", 0, 400, ""))
  params:add_control("lowBord", "lowBord", controlspec.new(1, 12000, "lin", 0, 400, ""))
  params:add_control("highBord", "highBord", controlspec.new(0, 20000, "lin", 0, 2000, ""))
  
  params:add_separator("Random Filter Settings")
  
  params:add_control("filter_min", "filter_min", controlspec.new(0, 20000, "lin", 0, 0, ""))
  params:add_control("filter_max", "filter_max", controlspec.new(0, 20000, "lin", 1, 20000, ""))
  
  params:add_option("rnd_freq","RND Freq",{"on", "off"},2)
  params:add_option("rnd_fil_freq","RND Filter Freq",{"on", "off"},2)
  params:add_option("midi_onoff","Midi Note_on",{"on", "off"},2)
  
  params:add_control("lfo_val01", "lfo_val01", controlspec.new(0, 1000, "lin", 0, 100, ""))
  params:add_control("lfo_val02", "lfo_val02", controlspec.new(0, 10000, "lin", 0, 10, ""))
  params:add_option("lfo_target","lfo_target",{"1", "2","3","4","ALL"},2)
  params:add_control("lfo_delta", "lfo_delta", controlspec.new(-1000, 1000, "lin", 0, 0, ""))
  params:add_control("lfo_off_delta", "lfo_off_delta", controlspec.new(-10,10, "lin", 0, 1, ""))
  
  
  params:bang()
end

-- a single-purpose triggering command fire a note
function NoizeOp.trig(hz)
  if hz ~= nil then
    engine.freq(hz)
  end
end

 -- we return these engine-specific Lua functions back to the host script:
return NoizeOp