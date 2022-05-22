/*
2022, deeg / @deeg_deeg_deeg
*/

Engine_NoizeOp : CroneEngine {

	var <synths;


	*new { arg context, doneCallback;

		^super.new(context, doneCallback);
	}

	alloc {

		synths = {

			arg out = 0,
	    	freq01=20, freq02=20, freq03=20, freq04=20, mul01=1, mul02=1, mul03=1, mul04=1, a_mod_01=1, a_mod_02=1, a_mod_03=1, a_mod_04=1, a_mod_05=1, a_mod_06=1, a_vol_01=1, a_vol_02=1, a_vol_03=1, a_vol_04=1, a_vol_05=1, a_vol_06=1, ffreq01=20000, ffreq02=20000, ffreq03 = 20000, q01=1, q02=1, q03=1;

    	
	    var osc01, osc02, osc03, osc04, algo01, algo02, algo03, algo04, algo05, algo06, combo, signal, signal2, signal3;
		
		  osc01= SinOsc.ar(freq01, 0, mul01, 0);
			osc02= SinOsc.ar(freq02, 0, mul02, 0);
			osc03= SinOsc.ar(freq03, 0, mul03, 0);
			osc04= SinOsc.ar(freq04, 0, mul04, 0);

			algo01 = ((osc01*osc02)/(osc03*osc04))/a_mod_01;
			algo02 = ((osc02*osc04)/(osc03-osc01))/a_mod_02; 
			algo03 = ((osc01+osc02)-(osc03+osc04)).trunc(a_mod_03); 
			algo04 = (algo01*algo02*algo03).sqrt/a_mod_04;
			algo05 = (hypot(osc01,osc02) + hypot(osc03,osc04))*a_mod_05;
			algo06 = (osc01**2+osc02**2+osc03**2+osc04**2)*a_mod_06;

			combo = (algo01*a_vol_01)+(algo02*a_vol_02)+(algo03*a_vol_03)+(algo04*a_vol_04)+(algo05*a_vol_05)+(algo06*a_vol_06);

			signal = BLowPass4.ar(BHiPass4.ar(combo, ffreq01, q01, 1 , 0), ffreq02, q02,1,0);
			
			signal2 = Resonz.ar(in: signal, freq: ffreq03, bwr: q03, mul: 1.0, add: 0.0);

      signal3 = Pan2.ar(signal2,0);

		    Out.ar(out, signal3);

			}.play(args: [\out, context.out_b], target: context.xg);


	  	this.addCommand("freq01", "f", { arg msg;
			synths.set(\freq01, msg[1]);
		});

	  	this.addCommand("freq02", "f", { arg msg;
			synths.set(\freq02, msg[1]);
		});

		this.addCommand("freq03", "f", { arg msg;
			synths.set(\freq03, msg[1]);
		});			

	  	this.addCommand("freq04", "f", { arg msg;
			synths.set(\freq04, msg[1]);
		});

	  	this.addCommand("mul01", "f", { arg msg;
			synths.set(\mul01, msg[1]);
		});

	  	this.addCommand("mul02", "f", { arg msg;
			synths.set(\mul02, msg[1]);
		});

	  	this.addCommand("mul03", "f", { arg msg;
			synths.set(\mul03, msg[1]);
		});

	  	this.addCommand("mul04", "f", { arg msg;
			synths.set(\mul04, msg[1]);
		});



	  	this.addCommand("a_mod_01", "f", { arg msg;
			synths.set(\a_mod_01, msg[1]);
		});

	  	this.addCommand("a_mod_02", "f", { arg msg;
			synths.set(\a_mod_02, msg[1]);
		});

	  	this.addCommand("a_mod_03", "f", { arg msg;
			synths.set(\a_mod_03, msg[1]);
		});

	  	this.addCommand("a_mod_04", "f", { arg msg;
			synths.set(\a_mod_04, msg[1]);
		});

	  	this.addCommand("a_mod_05", "f", { arg msg;
			synths.set(\a_mod_05, msg[1]);
		});

	  	this.addCommand("a_mod_06", "f", { arg msg;
			synths.set(\a_mod_06, msg[1]);
		});



	  	this.addCommand("a_vol_01", "f", { arg msg;
			synths.set(\a_vol_01, msg[1]);
		});

	  	this.addCommand("a_vol_02", "f", { arg msg;
			synths.set(\a_vol_02, msg[1]);
		});

	  	this.addCommand("a_vol_03", "f", { arg msg;
			synths.set(\a_vol_03, msg[1]);
		});

	  	this.addCommand("a_vol_04", "f", { arg msg;
			synths.set(\a_vol_04, msg[1]);
		});

	  	this.addCommand("a_vol_05", "f", { arg msg;
			synths.set(\a_vol_05, msg[1]);
		});

	  	this.addCommand("a_vol_06", "f", { arg msg;
			synths.set(\a_vol_06, msg[1]);
		});


	  	this.addCommand("ffreq01", "f", { arg msg;
			synths.set(\ffreq01, msg[1]);
		});

	  	this.addCommand("ffreq02", "f", { arg msg;
			synths.set(\ffreq02, msg[1]);
		});
		
	  	this.addCommand("ffreq03", "f", { arg msg;
			synths.set(\ffreq03, msg[1]);
		});		

	  	this.addCommand("q01", "f", { arg msg;
			synths.set(\q01, msg[1]);
		});

	  	this.addCommand("q02", "f", { arg msg;
			synths.set(\q02, msg[1]);
		});
		
		this.addCommand("q03", "f", { arg msg;
			synths.set(\q03, msg[1]);
		});

}
	
	// define a function that is called when the synth is shut down
	free {
		synths.free;
	}
}

