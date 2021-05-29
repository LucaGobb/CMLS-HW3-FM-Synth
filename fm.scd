s.reboot;

Server.killAll;
s.boot;

s.scope;
s.meter;
FreqScope.new;




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////                   SYNTH                                      /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
(
SynthDef(\fm, {
	// information of input midi
	arg midi_num = 60, midi_val = 1.0, gate = 1,


	// for the choice of the wave
	carrier_sin = 1, carrier_square = 0, carrier_triangle = 0, carrier_saw = 0,  // type of carry wave
	mod_sin = 1, mod_triangle = 0,	mod_saw = 0, // type of first modulator wave
	mod2_sin = 1, mod2_triangle = 0, mod2_saw = 0,	 // type of first modulator wave





	// main parameters of modulator

	coarse1 = 2,
	coarse2 = 6,

	fine1 = 1,
	fine2 = 1,

	modLevel1 = 0.5,
	modLevel2 = 0.5,


	subOsc_amp   = 0.3,  // the level of the real sub oscillator




	// envelope of modulator
	attack_mod   = 0.06,
	decay_mod    = 0.6,
	sustain_mod  = 0.6,
	release_mod  = 0.6,

	// envelope of note
	attack_note  = 0.05,
	decay_note   = 0.15,
	sustain_note = 0.4,
	release_note = 0.7,

	// lfo to modulate the fundamental frequency and modulator
	freq_lfo = 10.0,
	depth_lfo = 3.0,

	// bus imformation
	freq_cutoff = 15000.0,
	outputVolume = 0.4,
	pan = 0.0;

	var env_mod = EnvGen.kr(Env.adsr(
		attackTime: attack_mod,
		decayTime: decay_mod,
		sustainLevel: sustain_mod,
		releaseTime: release_mod ,
		curve: 'lin'
	));//[-4, 2, -9]

    var env_note = EnvGen.kr(Env.adsr(
		attackTime: attack_note,
		decayTime: decay_note,
		sustainLevel: sustain_note,
		releaseTime: release_note,),
	gate: gate,
	doneAction: 2);

	var control_lfo = SinOsc.ar(
		freq: freq_lfo,
		mul: depth_lfo);


	//We have 4 signals with frequencies :
	   //1
	var fundamental_freq = midi_num.midicps ; //From MIDI to Frequency
	   //2
	var freq1 = fundamental_freq * coarse1 * fine1;
	   //3
	var freq2 = fundamental_freq * coarse2 * fine2;
	   //4
	var freq3 = fundamental_freq /2;

	//the third signal (second modulator) modulates the frequency of the second (first modulator), which in turn modulates the frequency of the first one, called carrier. The fourth signal is a Sub OScillator

		//Modulation Amplitude
	var modAmp1 = fundamental_freq * modLevel1;
	var modAmp2 = fundamental_freq * modLevel2;



	//second modulator frequency
	var control_mod2_freq = freq2;

	// signal (2nd modulator )
	var control_mod2 = env_mod *
	(
	 	(mod2_sin * SinOsc.ar(freq: control_mod2_freq)) +
		(mod2_triangle * LFTri.ar(freq: control_mod2_freq)) +
		(mod2_saw * LFSaw.ar(freq: control_mod2_freq))

	);



	//modulated frequency (first modulator frequency modulated by the second modulator)
	var control_mod_freq = freq1 + (modAmp2 * (control_mod2)) + control_lfo;

	// signal (2nd modulator )
	var control_mod =  env_mod *
	(
		(mod_sin * SinOsc.ar(freq:control_mod_freq)) +
		(mod_triangle * LFTri.ar(freq:control_mod_freq)) +
		(mod_saw * LFSaw.ar(freq:control_mod_freq))

	);


	//modulated frequency (carrier frequency modulated by first modulator, whose frequency is modulated by the second modulator)
	var modulated_signal_freq = fundamental_freq + ( modAmp1  * (control_mod ) );

	//modulated Signal
	var modulated_signal = env_note  *
	(
		(carrier_sin * SinOsc.ar(freq:modulated_signal_freq )!2) +
		(carrier_square* LFPulse.ar(freq:modulated_signal_freq , width: 0.5)!2) +
		(carrier_triangle* LFTri.ar(freq:modulated_signal_freq )!2) +
		(carrier_saw * LFSaw.ar(freq:modulated_signal_freq )!2)

	);


	var subOscFreq = fundamental_freq / 2;


	var signal_subOsc = subOsc_amp * env_note *
	(
		(carrier_sin * SinOsc.ar(freq:subOscFreq)) +
		(carrier_square* LFPulse.ar(freq:subOscFreq, width: 0.5)) +
		(carrier_triangle* LFTri.ar(freq:subOscFreq)) +
		(carrier_saw * LFSaw.ar(freq:subOscFreq))

	);

	var signal_master = Pan2.ar(
		in: midi_val * (modulated_signal + signal_subOsc),
		pos: pan,
		level: outputVolume);



    Out.ar(
		bus: 0,
		channelsArray: LPF.ar(signal_master, freq_cutoff));

}).add;
)

x = Synth(\fm, [\midi_num , 60, \richness_mod ,10 , \harmonic_mod, 5, \richness_mod2 ,5 , \harmonic_mod2, 2.5]);
x = Synth(\fm, [\midi_num , 60, \carrier_sin , 1, \subOsc_amp, 0]);
x = Synth(\fm, [\midi_num , 60]);
x.set(\gate, 0);
x.free;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////                   OSC                                       /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
(
NetAddr("127.0.0.1", 57120);

~processingOut = NetAddr("127.0.0.1", 12000);
)
// todo: remove : test
// ~processingOut.sendMsg("/from_SC", 23);
// ~processingOut.sendMsg("/harmonicity", 3);
// ~processingOut.sendMsg("/richness", 5.0);

(
var carrierWaveformArray;
var firstModWaveformArray;
var secondModWaveformArray;

(
OSCdef('OSCreceiver',
	{
		arg msg;

		x = msg[1]; //todo: rename with global variables
		y = msg[2];
		d = msg[3];
		g = msg[4];

		h = msg[5];
		p = msg[6];
		j = msg[7];
		l = msg[8];


		q = msg[9];
		w = msg[10];
		e = msg[11];
		r = msg[12];

		v = msg[13];


		carrierWaveformArray = Array.fill(4, { arg i; 0 * i});
		carrierWaveformArray[msg[14]] = 1;


		firstModWaveformArray = Array.fill(3, { arg i; 0 * i});
		firstModWaveformArray[msg[15]] = 1;

		secondModWaveformArray = Array.fill(3, { arg i; 0 * i});
		secondModWaveformArray[msg[16]] = 1;


		m = msg[17];
		n = msg[18];

		f = (round(msg[19] * 100) /100) +1 ;
		b = (round(msg[20] * 100) /100) +1;

		z = msg[21] * 10; // multiply by 1000 because ModLevel is just from 0 to 1
		k = msg[22]  * 10 ;


		postln("SubOscLevel: "+x);
		postln("CutOff: "+y);

		postln("lFORate: "+d);
		postln("lfoDepth: "+g);

		postln("noteAttack: "+h);
		postln("noteDecay: "+p);
		postln("noteRelease: "+j);
		postln("noteSustain: "+l);


		postln("modAttack: "+q);
		postln("modDecay: "+w);
		postln("modRelease: "+e);
		postln("modSustain: "+r);


		postln("volume: "+v);



		postln("coarse1: "+m);
		postln("coarse2: "+n);

		postln("fine1: "+f);
		postln("fine2: "+b);

		postln("ModLevel1: "+ z);
		postln("ModLevel2: "+ k);

	},
	"/fromProcessing");
)


//////////////////////////// remove
OSCdef.freeAll
//todo remove: test
"\\release_note".postln()
~attack_note.value(5);
~attack_note_(5);
~attack_note.value()
~attack_note = 3;
~globalParametersVariables[0].set(2)
~globalParametersVariables[0].asRef.set(2)
~globalParametersVariables;
(
~globalParametersVariables= [ // todo: those variables gets overwritten with the actual values
	~attack_note,  ~decay_note, ~sustain_note, ~release_note,
	~attack_mod,   ~decay_mod,  ~sustain_mod,  ~release_mod,
	~freq_lfo,     ~depth_lfo,
    ~subOsc_amp,   ~freq_cutoff,
	~modLevel1, ~fine1, ~coarse1,
	~modLevel2, ~fine2, ~coarse2
];
)
// ~globalParametersVariables= [ // todo: those variables gets overwritten with the actual values
// 	0.5,  0.5, 0.5, 0.5,
// 	0.5,   0.5,  0.5,  0.5,
// 	10,     10,
// 	1,   15000,
// 	1, 1, 1,
// 	1, 1, 1
// ];
///////////////////////////////// remove

(
OSCdef.freeAll;
//names of the Synth parameters
~parametersName = [ //parameters starting with r are symbol to avoid cofusion with \r = "a capo"
	'\attack_note',  '\decay_note', '\sustain_note', '\release_note',
	'\attack_mod',   '\decay_mod',  '\sustain_mod',  '\release_mod',
	'\freq_lfo',     '\depth_lfo',
	'\subOsc_amp',   '\freq_cutoff',
	'\modLevel1', '\fine1', '\coarse1',
	'\modLevel2', '\fine2', '\coarse2',
	'\volume'
];
// todo
// volume, firstModWaveform, secondModWaveform, carrierModWaveform,
~setGlobalVariable = {
	|index, val|
	switch(index,
		0,{~attack_note = val},
		1,{~decay_note = val},
		2,{~sustain_note = val},
		3,{~release_note = val},
		4,{~attack_mod = val},
		5,{~decay_mod = val},
		6,{~sustain_mod = val},
		7,{~release_mod = val},
		8,{~freq_lfo = val},
		9,{~depth_lfo = val},
		10,{~subOsc_amp = val},
		11,{~freq_cutoff = val},
		12,{~modLevel1 = val},
		13,{~fine1 = val},
		14,{~coarse1 = val},
		15,{~modLevel2 = val},
		16,{~fine2 = val},
		17,{~coarse2 = val},
		18,{~volume = val}
	);
};


// array with path of the incoming osc Messages
[   "noteAttack","noteDecay","noteSustain","noteRelease",
	"modAttack","modDecay","modSustain","modRelease",
	"lfoRate","lfoDepth",
	"subOscLevel","cutoff",
	"modLevel1", "fine",  "coarse1",
	"modLevel2", "fine2", "coarse2",
	"volume"
].do({
	arg param, num;
	OSCdef(param ++ 'OSCReceiver',{
		|msg|
		~notes.do({arg item, number; // update current playing notes
			if(item != nil, {
				~notes[number].set(~parametersName[num], msg[1]);
			});
		});
		~parametersName[num].post();
		msg.postln();

		~setGlobalVariable.set(num, msg[1]); // update global variables
		// ~globalParametersVariables.at(num).value(msg[1]);
		// ~globalParametersVariables[num] = msg[1];
		// ~globalParametersVariables.postln();
	}, "/fromProcessing/" ++ param);
	// ~parametersName[num].postln();
});
)

// todo: testing: remove
~notes.do({arg item, number;
	if(item != nil, {
		~notes[number].set(~parametersName[12], 5);
	});
});
~globalParametersVariables[11]


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////                   MIDI                                       /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
(
MIDIClient.init;
MIDIIn.connectAll;
)
MIDIdef.freeAll;

(
~notes = Array.newClear(128);

MIDIdef.noteOn(\noteOnTest, {
	arg vel, noteNum, chan, srcID;
	[vel, noteNum].postln;
	~processingOut.sendMsg("\noteOn",noteNum);
	~notes[noteNum] = Synth.new(
		\fm,
		[
		\midi_num, noteNum,
		\gate, 1,
			// \outputVolume, 1,
			\outputVolume, ~volume.value() * vel/(127.0),
			\subOsc_amp, ~subOsc_amp.value(),
		\freq_cutoff, ~freq_cutoff,

		\freq_lfo, ~freq_lfo,
		\depth_lfo, ~depth_lfo,

		\attack_note,  ~attack_note ,
		\decay_note ,  ~decay_note ,
		\sustain_note ,~sustain_note,
		\release_note ,~release_note,

		\attack_mod,  ~attack_mod,
		\decay_mod ,  ~decay_mod,
		\sustain_mod, ~sustain_mod,
		\release_mod, ~release_mod,

		//\firstModWaveform,o,
		//\secondModWaveform, a,
		\coarse1, ~coarse1,
		\coarse2, ~coarse2,
		\fine1, ~fine1,
		\fine2, ~fine2,
		\modLevel1, ~modLevel1,
		\modLevel2, ~modLevel2
		]
		/*[
		\midi_num, noteNum,
		\gate, 1,
		\outputVolume, v * vel/(127.0 * 1.5),
		\subOsc_amp, x,
		\freq_cutoff, y,

		\freq_lfo, d,
		\depth_lfo, g,

		\attack_note, h,
		\decay_note ,  p,
		\sustain_note , j,
		\release_note , l,

		\attack_mod, q,
		\decay_mod ,  w,
		\sustain_mod,  e,
		\release_mod,  r,

		\coarse1, m,
		\coarse2, n,
		\fine1, f,
		\fine2, b,
		\modLevel1, z,
		\modLevel2, k,

		\carrier_sin,carrierWaveformArray[0],
		\carrier_square,carrierWaveformArray[1],
		\carrier_triangle,carrierWaveformArray[2],
		\carrier_saw, carrierWaveformArray[3],

		\mod_sin,firstModWaveformArray[0],
		\mod_triangle,firstModWaveformArray[1],
		\mod_saw, firstModWaveformArray[2],

		\mod2_sin,secondModWaveformArray[0],
		\mod2_triangle,secondModWaveformArray[1],
		\mod2_saw, secondModWaveformArray[2]
		]*/
	);
});

MIDIdef.noteOff(\noteOffTest, {
	arg vel , noteNum;
	[vel,noteNum].postln;
	~processingOut.sendMsg("\noteOff",noteNum);
	~notes[noteNum].set(\gate, 0);
	~notes[noteNum].release;

	~notes[noteNum] = nil;
	~notes[noteNum].free;
});
)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////                ARDUINO                                       /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
SerialPort.cleanupAll
SerialPort.listDevices

(
~port = SerialPort(
    "COM9",
    baudrate: 115200
);
)

(
~port = SerialPort(
    "COM9",
    baudrate: 115200
);
~getValues.stop;
~charArray= [ ];
~getValues= Routine.new({
	var ascii;
	{
		ascii= ~port.read.asAscii;
		/*if(ascii==Char.binaryOpCharacters[5],{ //minus sign
			~charArray= ~charArray.add(ascii)
			});*/
		if(ascii.isDecDigit,{
			~charArray= ~charArray.add(ascii)
			});
		if(ascii== $p, // pitch
			{
				~val1 = (~charArray.collect(_.digit).convertDigits /360*2  *10).asInteger();
				~charArray= [ ];
				// ~val1.post();
				// "-".post();
				// x.set(\depth_lfo, 0 + ~val1);
				~notes.do({arg item, number; // update current playing notes
					if(item != nil, {
						~notes[number].set(\harmonic_mod, 0 + ~val1);
					});
				});
				~processingOut.sendMsg("/harmonicity1", ~val1);
				~globalParametersVariables[13] = ~val1;
				~globalParametersVariables[13].postln();

				// todo: remove: lag test on a single note
				// ~notes[75].set(\depth_lfo, 0 + ~val1);
				// x.set(\midi_num, ~var1);
		});
		if(ascii== $r, // roll
			{
				~val2= (~charArray.collect(_.digit).convertDigits /360 *2    *10).asInteger();
				~charArray= [ ];
				// ~val2.post();
				~notes.do({arg item, number; // update current playing notes
					if(item != nil, {
						~notes[number].set(\richness_mod, 0 + ~val2);
					});
				});
				~processingOut.sendMsg("/richness1", ~val2.asInteger());
				// ~globalParametersVariables[12] = ~val1.asInteger();
				// x.set(\freq_lfo, 2 + ~val2);
		});
		if(ascii== $y, //yaw
			{
				~val3= ~charArray.collect(_.digit).convertDigits/360+0.5;
				~charArray= [ ];
				// (~val3/360).postln();
				// ~val3.postln();
				// x.set(\pan, 1.0 - (~val3/360.0*4).postln());
		});
	}.loop;
}
).play;
)

/////////////////// testing /////
// todo: remove
(
for ( 0, ~notes.size,
	{
		arg i;
		~notes[i].set(\subOsc_amp, 0.5);
		// ~notes[i].set(\gate, 0);
		// if(~notes[i]!=nil,{i.postln()}) // print active notes
});
)
