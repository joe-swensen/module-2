s.waitForBoot { //Waits for server to boot to begin
	//creating synth, this specific synth is modified from a previous project of mine
	SynthDef(\phatboi, {|out = 0 freq = 100 amp = 0.2 gate=1 cutoff=2500 resonance=0.1 voices=8 detune=0.01 sub=0|
		var osc, subosc, env, filter, filterenv, noiseosc, subby;

		osc = Mix.fill(5, {|i| [Saw.ar(freq * (1 + (detune * (i - 3)))),Saw.ar(freq * (1 + (detune * 2 * (i - 3))))]});

		subosc = Mix.fill(4, {|i| [Saw.ar((freq / 2)* (1 + (detune * i))),Saw.ar((freq / 2) * (1 + (detune * 2 * i)))]});

		noiseosc = WhiteNoise.ar();

		subby = Mix.new([Pulse.ar(freq  , 0.5,(sub)),Pulse.ar(freq / 2 , 0.5,(sub))]);

		filter = RLPF.ar(((osc * 0.6) + subosc + (noiseosc * 0.3) + subby) * 0.5,cutoff,resonance);


		Out.ar(out, amp * filter * gate);

	}).add;

	s.sync; //syncs server to confirm that synth has been added & everything is set up correctly before beginning

	x = Synth.new(\phatboi); //create instance of synth

	//open serial port to ESP32
	p = SerialPort.new("/dev/ttyUSB0");
	//get information and execute through routine r
	r= Routine({
		var byte, str, res, xVal, yVal, bState, dState, sState, cut, det, freqq;
		xVal = 0;
		yVal = 0;
		sState = 0;
		freqq = 100;
		loop {
			if(p.read==10) {
				str = "";
				while({byte = p.read; byte !=13 }) {
					str= str++byte.asAscii;
				};
				switch(str[0])
				{$x}{xVal = str.split($x)[1].asInteger}
				{$y}{yVal = str.split($y)[1].asInteger}
				{$d}{dState = str.split($d)[1].asInteger}
				{$s}{sState = str.split($s)[1].asInteger}
				{$b}{bState = str.split($b)[1].asInteger};
				cut = 500 + xVal;
				det = 0.01 + (((yVal - 2048) / 4096) + 0.5) * 0.04;
				if(bState == 1) {
					freqq = freqq * 0.995;
				} {
					freqq = 100;
				};
				x.set(\cutoff,cut,\gate,dState,\detune,det,\freq,freqq,\sub,sState);
			};
		};
	}).play;

}


/*
 Commented for the sake of runnability of the program; this can be used to stop the program efficiently when testing
(
x.free;
r.stop;
p.close;
) */