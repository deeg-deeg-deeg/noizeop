-- NOIZE OPERATOR! v1.0
-- Noise Synth
-- by deeg
--
-- @deeg_deeg_deeg
--
-- https://github.com/deeg-deeg-deeg
--
-- be aware!: may produce very
-- loud noises!!!
--
-- ENC 2: choose parameter
-- ENC 3: change selected 
--        parameter
-- ENC 1: change the amount 
--        parameters will be
--        changed
--
-- KEY 2&3: select which oscillator
--          will receive incoming
--          midi notes
--
--

engine.name = 'NoizeOp' 

Noize = include('noizeop/lib/noizeop_engine')
m = midi.connect(2)

para_names = {"freq01", "freq02", "freq03", "freq04", "mul01", "mul02", "mul03", "mul04", "a_vol_01", "a_vol_02", "a_vol_03", "a_vol_04", "a_vol_05", "a_vol_06", "a_mod_01", "a_mod_02", "a_mod_03", "a_mod_04", "a_mod_05", "a_mod_06", "ffreq01", "q01", "ffreq02", "q02", "ffreq03", "q03",
"rnd_freq","rnd_fil_freq", "lfo_val01", "lfo_val02","lfo_target", "lfo_delta", "lfo_off_delta", "rnd_speed", "possy", "poss_lim", "lowBord", "highBord", "midi_onoff"}


screen_names ={"OSC 1 FREQ","OSC 2 FREQ","OSC 3 FREQ","OSC 4 FREQ",
               "OSC 1 VOLUME", "OSC 2 VOLUME", "OSC 3 VOLUME", "OSC 4 VOLUME",
               "ALGO 1 VOLUME", "ALGO 2 VOLUME", "ALGO 3 VOLUME", "ALGO 4 VOLUME", "ALGO 5 VOLUME", "ALGO 6 VOLUME",
               "MODULATOR 1", "MODULATOR 2", "MODULATOR 3", "MODULATOR 4", "MODULATOR 5", "MODULATOR 6", 
               "FILTER 1 CUTOFF", "FILTER 1 Q", "FILTER 2 CUTOFF", "FILTER 2 Q","RESOFILTER CUTOFF", "RESOFILTER Q",
               "RND FREQ", "LFO ON/OFF","LFO VALUE 01", "LFO VALUE 02", "LFO TARGET", "LFO DELTA", "OFFSET DELTA","RANDOM SPEED", "POSSIBILITY", "POSSY LIMIT", "BORDER LOW", "BORDER HIGH", "MIDI NOTE TRIGGER"}

icons = {".-","o",".-","::",".:",":.","_."}

icons_fix = {"::", ".-", ".-", "_.", "_.", ":.", ".-", ".:",
             ".-", "::", ":.", ".:", ":.", "_.", "::", "::",
             ":.", "_.", ".:", ":.", ".-", "_.", "._", ".:",
             ".-", ".:", "::", "::", ".-", "_.", ":.", ".-",
             "-.", "_.", ".-", ":-", ".:", "::", ".:", "-."
}

padar ={"",".",":",".:","::","::.",":::", ":::.","::::"}

algoson = {".",":",".:","::","::.",":::"}

deltas = {"0.01","0.1","1","10","100"}
deltaval = 3
midi_target = 0
selections = 39

activepad = 0
padcount = 0

rnd_init = 0
freqval = 0

pb_mul = 1

lfo_offset01 = math.random(-100,100)
lfo_offset02 = math.random(-100,100)
lfo_offset03 = math.random(-100,100)
lfo_offset04 = math.random(-100,100)


whereamI = 1
x = 1
y = 1

function intro()

for i=1,150 do
  screen.clear()
  
  for i=1,84 do
    screen.font_face(1)
    screen.font_size(8)
    x = x+1
    
    if i == 1 then 
      x = 1 
      y = 1
    end
    
    if x == 18 then 
      y = y + 1 
      x = 1
    end
    
    ypos = y*12-1
    
    screen.level((4))
    screen.move(x*8-7,ypos)
    screen.text(icons[math.random(3,7)])
    
    --wait(0.01)
  end

    screen.font_face(1)
    screen.font_size(25)
    screen.level(math.random(10,15))
    screen.move(27,30)
    screen.text("NOIZE")
    screen.move(12,50)
    screen.font_size(20)
    screen.text("OPERATOR!")
    screen.update()
    wait(0.01)

end
  screen.clear()
  screen.update()
  

  wait(0.5)


end


function init()

  Noize.add_params()
  speed = 1000

  randomFreq = false
  rndFilter = false
  omute = false
  
  intro()
  
  
    
  sequence = clock.run(
    function()
      while true do
        speed = params:get("rnd_speed")
        possy = params:get("possy")
        poslimit = params:get("poss_lim")
        
        lowBord = params:get("lowBord")
        highBord = params:get("highBord")
        
        
        clock.sync(1/speed)
        
        if randomFreq then
             decider=math.random(0,math.floor(poslimit))
            if decider <=math.floor(possy) then
                
                if highBord <= lowBord then highBord=lowBord+10 end
                lowVal=math.random(0,math.floor(lowBord))
                highVal=math.random(math.floor(lowBord),math.floor(highBord))
                
                synced_rnd = math.random(lowVal,highVal)
                
                engine.ffreq01(math.random(lowVal,highVal))
                engine.ffreq02(math.random(lowVal,highVal))


            end

        end
        

        
        
        if rndFilter then
          
          lfo_target = params:get("lfo_target")
          lfo_delta = params:get("lfo_delta")
          
          if rnd_init == 0 then
            if lfo_target == 1 then
              freqval = params:get("freq01")
            elseif lfo_target == 2 then
              freqval = params:get("freq02")
            elseif lfo_target == 3 then
              freqval = params:get("freq03")
            elseif lfo_target == 4 then
              freqval = params:get("freq04")
            elseif lfo_target == 5 then
              freqval = params:get("freq01")
              freqval = params:get("freq02")
              freqval = params:get("freq03")
              freqval = params:get("freq04")
            end
            
            rnd_init = 1
          end
          
          lfo_val01 = params:get("lfo_val01")
          lfo_val02 = params:get("lfo_val02")
          
          sinus = freqval + lfo_val01 * math.sin(math.rad(lfo_val02*clock.get_beats())) + lfo_delta
          if sinus < 0 then sinus = sinus *-1 end
          
          offset_delta = params:get("lfo_off_delta")
          
          if lfo_target == 1 then
            params:set("freq01",sinus)
          elseif lfo_target == 2 then
            params:set("freq02",sinus)
          elseif lfo_target == 3 then
            params:set("freq03",sinus)
          elseif lfo_target == 4 then
            params:set("freq04",sinus)
          elseif lfo_target == 5 then
            params:set("freq01",sinus+(lfo_offset01*offset_delta))
            params:set("freq02",sinus+(lfo_offset02*offset_delta))
            params:set("freq03",sinus+(lfo_offset03*offset_delta))
            params:set("freq04",sinus+(lfo_offset04*offset_delta))
          end
          
          
        end

      end
    end
  )
  
  

end
  
function enc(n,d)
  
  if n == 1 then
  -- set delta  
  
    deltaval = util.clamp(deltaval + d, 1, 5)
    
  
  elseif n == 2 then
  
  -- select option
    whereamI = util.clamp(whereamI + d, 1, selections)
    
  
  elseif n == 3 then
  
  -- change current value
    change = params:get(para_names[whereamI]) + d*deltas[deltaval]
    params:set(para_names[whereamI], change)
    
    if whereamI == 27 then
      checko = params:get(para_names[whereamI])
      
      if checko == 1 then
        randomFreq = true
        else
        randomFreq = false
      end
    end
    
        
    if whereamI == 28 then
      checko = params:get(para_names[whereamI])
      
      if checko == 1 then
        rndFilter = true
        else
        rndFilter = false
        rdn_init = 0
      end
        
    
    end
    
    
    
    
  end
  redraw()
end

function key(n,z)
  if n == 3 and z == 1 then
  -- select wave +1
     midi_target = util.clamp(midi_target + 1, 0, 6)
    redraw()
  end
  
  if n == 2 and z == 1 then
      midi_target = util.clamp(midi_target - 1, 0, 6)
  
    redraw()
  end
end

function padcheck()
  
  if mess.cc >= 101 and mess.cc <= 108 then

    local p = mess.cc - 100

    if activepad == p and padcount == 3 then
      activepad = 0

    elseif activepad ~= p then
        activepad = p
        padcount = 0
        padcount = padcount+1
    elseif activepad == p and padcount < 3 then
        padcount = padcount+1
    end
    
    
    
      print(activepad)
      print(padcount)
    
  end

end

function knobcheck()
  
  if activepad ~= 0 then
    for i=1,8 do

      if mess.cc == 15+i then 
        whereamI = ((activepad-1) * 8) + i

        if whereamI > selections then
          whereamI = selections

        end
        
        redraw()
      end
    end
  end
  
  
  
  
end

function padzero()

    if mess.cc == 16 then
    
      whereamI = util.clamp(whereamI + midi_delta, 1, selections)
    
    elseif mess.cc == 17 then
  
      change = params:get(para_names[whereamI]) + midi_delta*deltas[deltaval]
      params:set(para_names[whereamI], change)
  
    elseif mess.cc == 18 then
    
      deltaval = util.clamp(deltaval + midi_delta, 1, 5)
  
    elseif mess.cc == 19 then
    
      pb_mul = util.clamp(pb_mul + midi_delta, 1, 100)
  
    elseif mess.cc == 20 then
    
      midi_target = util.clamp(midi_target + midi_delta, 0, 6)
  
    elseif mess.cc == 21 then
    
      cval = params:get("ffreq01")
      params:set("ffreq01", cval + midi_delta*50)
  
    elseif mess.cc == 22 then
    
      cval = params:get("ffreq02")
      params:set("ffreq02", cval + midi_delta*50)
  
    elseif mess.cc == 23 then
    
      cval = params:get("ffreq03")
      params:set("ffreq03", cval + midi_delta*50)
  
    end         
end


function valupdate()
  
      change = params:get(para_names[whereamI]) + midi_delta*deltas[deltaval]
      params:set(para_names[whereamI], change)
      
end
      

m.event = function(data) 
 
  mess = midi.to_msg(data)
  midi_delta = 0
  midi_onoff = params:get("midi_onoff")
  
  -- print(mess.val)
  
  if mess.type == "cc" then

    if mess.val == 127 then
      midi_delta = -1
    elseif mess.val == 1 then
      midi_delta = 1
    end
  
  padcheck()
  knobcheck()
  
  if activepad == 0 then
    padzero()
  else
    change = params:get(para_names[whereamI]) + midi_delta*deltas[deltaval]
    params:set(para_names[whereamI], change)
  end

  redraw()
    
  end
  

  if mess.type == "note_on" then
    hz = midi_to_hz(mess.note)
   
      if midi_target ~= 6 then
        params:set(para_names[midi_target-1],hz)
        if midi_onoff == 1 then
          params:set(para_names[midi_target-1],0.5)
        end
      elseif midi_target == 6 then
        params:set(para_names[midi_target-2],hz)
        params:set(para_names[midi_target-3],hz)
        params:set(para_names[midi_target-4],hz)
        params:set(para_names[midi_target-5],hz)
        if midi_onoff == 1 then
          params:set(para_names[midi_target-2],0.5)
          params:set(para_names[midi_target-3],0.5)
          params:set(para_names[midi_target-4],0.5)
          params:set(para_names[midi_target-5],0.5)
        end
      end

      redraw();
  end
  
  if mess.type == "note_off" and midi_onoff == 1 then

          params:set(para_names[1],0)
  end
  
  if mess.type == "pitchbend" then
  
    if midi_target ~= 0 and midi_target ~= 6 then
      pitch_delta = (mess.val -8912)/8912*pb_mul
      cur_pit = params:get(para_names[midi_target-1])
      newpitch = cur_pit + pitch_delta
      params:set(para_names[midi_target-1],newpitch)
      redraw()
      
    elseif midi_target == 6 then
      pitch_delta = (mess.val -8912)/8912*pb_mul

      for i=2,5 do
        cur_pit = params:get(para_names[midi_target-i])
        newpitch = cur_pit + pitch_delta
        params:set(para_names[midi_target-i],newpitch)
      end
      
      redraw()
    end
  end
  
  
  
  
end



function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

function wait(seconds)
    local start = os.clock()
    repeat until os.clock() > start + seconds
end


function redraw()
  screen.clear()
  
  screen.font_face(1)
  screen.font_size(8)
  

  local i = 1
    
  for y=1,5 do
    for x = 1,8 do
       
      ypos = y*12-1
    
      screen.level((i == whereamI) and 15 or 3)
      if i > selections then screen.level(0) end
      screen.move(x*7-7,ypos)
      if i == whereamI then
          
        screen.text(icons[2])
    
      else
        screen.text(icons_fix[i])
      end   
      i=i+1
      
      screen.level(3)
      
      if i == midi_target and i ~= 6 then
        screen.move(x*7-7, ypos-5)
        screen.text("*")
      elseif i == 6 and i == midi_target then
        screen.move(1, 6)
        screen.text("* * * * ")
      end
      
      
      
    end
  end
    
    
  

  
-- if i == whereamI then
--    screen.move(x*8-7, ypos+4)
--    screen.line_rel(4,0)
--    screen.stroke()
--  end
  
  
  screen.level(12)
  screen.move(70,20)
  screen.font_size(18)
  
  if whereamI == 27 then
    was = params:get(para_names[whereamI])
    if was == 1 then textwrite = "ON"

    elseif was == 2 then textwrite = "OFF" 
      end
    screen.text(textwrite)
    
  elseif whereamI == 28 then
    
    was = params:get(para_names[whereamI])
    if was == 1 then textwrite = "ON"

    elseif was == 2 then textwrite = "OFF" 
      end
    screen.text(textwrite)
    
  elseif whereamI == 39 then
    
    was = params:get(para_names[whereamI])
    if was == 1 then textwrite = "ON"

    elseif was == 2 then textwrite = "OFF" 
      end
    screen.text(textwrite)
    
  
  else
    
    screen.text(params:get(para_names[whereamI]))
    
  end
      

  
  screen.font_size(8)
  screen.level(5)
  screen.move(70,40)
  screen.text(screen_names[whereamI])
  
  screen.level(1)
  screen.move(70,60)
  screen.text("▲"..deltas[deltaval])
  
  screen.font_size(8)
  
  for p=1,6 do
      
      screen.move(59,8*p+1)
      
    if params:get("a_vol_0"..p) > 0 then
      screen.level(8)
      screen.text(algoson[p])
    else
      screen.level(1)
      screen.text("..")
    end
  end
  
  screen.level(3)
  screen.move(120,6)
  screen.font_size(8)
  screen.text(padar[activepad+1])
  
  screen.level(1)
  screen.move(92,60)
  screen.font_size(8)
  screen.text("o" .. math.abs(pb_mul))
  
--  screen.level(1)
--  for i=1,8 do
--  screen.move(60,8*i)
--  screen.text("o")
--  end
  
    
--  for k = 1,7 do
      
--    ypos = 5*12-1
--    screen.level(1)
--    screen.move(k*8-7,ypos)
--    screen.text(icons[1])
          
--  end
    

  

  screen.update()
  screen.ping ()
end
