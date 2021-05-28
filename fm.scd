s.reboot;

Server.killAll;
s.boot;

s.scope;
s.meter;
FreqScope.new;



MIDIClient.init;
MIDIIn.connectAll;




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////                   SYNTH                                      /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
(
SynthDef(\fm, {
	// information of input midi
	arg midi_num = 60, midi_val = 1.0, gate = 1,


	coarse1 = 1,
	coarse2 = 1,

	fine1 = 1,
	fine2 = 1,

	modLevel1 = 0.5,

	modLevel2 = 0.5,

	carrierWaveform = 0,
	firstModWaveform = 0,
	secondModWaveform = 0,


	// main parameters of modulator
	harmonic_mod = 2.0,    // order of harmonic sequence
	richness_mod = 1.0,  // richness of harmonic

	harmonic_mod2 = 3.0,
	richness_mod2 = 5.0,

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
		releaseTime: release_mod,
		curve: [-4, 2, -9]));

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

	var fundamental_freq = midi_num.midicps ;

	var freq1 = fundamental_freq * coarse1 * fine1; //fine1 va da 1 a 2
	var freq2 = fundamental_freq * coarse2 * fine2;





	var modAmp1 = fundamental_freq * modLevel1;
	var modAmp2= fundamental_freq * modLevel2;





	//var harmonic_total = harmonic_mod + inharmonicity1;
	//var harmonic_total2 = harmonic_mod2 + inharmonicity2;


	var control_mod2 = env_mod * modAmp2 * SinOsc.ar(
		freq: freq2 + control_lfo);
		/*,mul:  fundamental_freq * env_mod*/


	var control_mod = env_mod * modAmp1 * SinOsc.ar(
		freq: freq1 + control_mod2 + control_lfo  );/*,
		mul:  (fundamental_freq ) * env_mod*/


	var signal_modulated_twice = env_note * SinOsc.ar(
		freq: fundamental_freq + control_mod); /*,
		mul: env_note */



	var signal_subOsc = SinOsc.ar(
		freq: fundamental_freq / 2.0,
		mul: subOsc_amp * env_note);

	var signal_master = Pan2.ar(
		in: midi_val * (signal_modulated_twice + signal_subOsc),
		pos: pan,
		level: outputVolume);



    Out.ar(
		bus: 0,
		channelsArray: LPF.ar(signal_master, freq_cutoff));

}).add;
)

x = Synth(\fm, [\midi_num , 60, \richness_mod ,10 , \harmonic_mod, 5, \richness_mod2 ,5 , \harmonic_mod2, 2.5]);
x.set(\gate, 0);
x.free;










//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////                   OSC                                       /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

NetAddr("127.0.0.1", 57120);

~processingOut = NetAddr("127.0.0.1", 12000);
// todo: remove : test
// ~processingOut.sendMsg("/from_SC", 23);
// ~processingOut.sendMsg("/harmonicity", 3);
// ~processingOut.sendMsg("/richness", 5.0);

(
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

		i = msg[14];
		o = msg[15];
		a = msg[16];


		m = msg[17];
		n = msg[18];

		f = round(msg[19] * 100) /100;
		b = round(msg[20] * 100) /100;

		z = msg[21] * 100;
		k = msg[22] * 100;


		postln("SubOscLevel: "+x);
		postln("CutOff: "+y);
		//postln("Harmonicity: "+z);
		//postln("Richness: "+k);

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

		postln("carrierWaveform: "+i);
		postln("firstModWaveform: "+o);
		postln("secondModWaveform: "+a);


		postln("coarse1: "+m);
		postln("coarse2: "+n);

		postln("fine1: "+f);
		postln("fine2: "+b);

		postln("ModLevel1: "+z);
		postln("ModLevel2: "+k);




	},
	"/fromProcessing");
);


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////                   MIDI                                       /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

		//\carrierWaveform, i,
		\firstModWaveform,o,
		\secondModWaveform, a,
		\coarse1, m,
		\coarse2, n,
		\fine1, f,
		\fine2, b,
		\modLevel1, z,
		\modLevel2, k





		]
);

};);


MIDIdef.noteOff(\noteOffTest, {
	arg vel , noteNum;
	[vel,noteNum].postln;
	~processingOut.sendMsg("\noteOff",noteNum);
	~notes[noteNum].set(\gate, 0);
	~notes[noteNum] = nil;
}

);
)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////                ARDUINO                                       /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
(
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
				~val1 = ~charArray.collect(_.digit).convertDigits /360;
				~charArray= [ ];
				// ~val1.postln();
				// x.set(\depth_lfo, 0 + ~val1);
				for ( 0, ~notes.size, { //update currently playing notes
					arg i;
					~notes[i].set(\depth_lfo, 0 + ~val1);
					// if(~notes[i]!=nil,{i.postln()}) // print active notes
					});
				// todo: remove: lag test on a single note
				// ~notes[75].set(\depth_lfo, 0 + ~val1);
				~processingOut.sendMsg("/harmonicity", ~val1);
				// x.set(\midi_num, ~var1);
		});
		if(ascii== $r, // roll
			{
				~val2= ~charArray.collect(_.digit).convertDigits /360;
				~charArray= [ ];
				// ~val2.post();
				for ( 0, ~notes.size, { //update currently playing notes
					arg i;
					~notes[i].set(\depth_lfo, 0 + ~val1);
					// if(~notes[i]!=nil,{i.postln()}) // print active notes
					});
				~processingOut.sendMsg("/richness", ~val2);
				// x.set(\freq_lfo, 2 + ~val2);
		});
		if(ascii== $y, //yaw
			{
				~val3= ~charArray.collect(_.digit).convertDigits;
				~charArray= [ ];
				// (~val3/360).postln();
				// (~val3).postln();
				// x.set(\pan, 1.0 - (~val3/360.0*4).postln());
		});
	}.loop;
}
).play;
)

/////////////////// testing /////
// todo: remove
for ( 0, ~notes.size,
	{
		arg i;
		~notes[i].set(\depth_lfo, 0 + ~val1);
		~notes[i].set(\gate, 0);
		// if(~notes[i]!=nil,{i.postln()}) // print active notes
});