s.reboot;

Server.killAll;
s.boot;

s.scope;
s.meter;
FreqScope.new;



MIDIClient.init;
MIDIIn.connectAll;

(
SynthDef(\fm, {
	// information of input midi
	arg midi_num = 60, midi_val = 1.0, gate = 1,

	// main parameters of modulator
	harmonic_mod = 2,    // order of harmonic sequence
	richness_mod = 1.0,  // richness of harmonic
	subOsc_amp   = 0.3,  // the level of sub oscillator

	// envelope of modulator
	attack_mod   = 0.06,
	decay_mod    = 0.1,
	sustain_mod  = 0.2,
	release_mod  = 0.4,

	// envelope of note
	attack_note  = 0.05,
	decay_note   = 0.15,
	sustain_note = 0.4,
	release_note = 0.7,

	// lfo to modulate the fundamental frequency and modulator
	freq_lfo = 10.0,
	depth_lfo = 4.0,

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

	var fundamental_freq = midi_num.midicps + control_lfo;

	var control_mod = richness_mod * SinOsc.ar(
		freq: fundamental_freq * harmonic_mod + control_lfo,
		mul:  fundamental_freq * env_mod + control_lfo.fold(1)); // add a little randomness

	var signal_modulated = SinOsc.ar(
		freq: fundamental_freq + control_mod,
		mul: env_note);

	var signal_subOsc = SinOsc.ar(
		freq: fundamental_freq / 2.0,
		mul: subOsc_amp * env_note);

	var signal_master = Pan2.ar(
		in: midi_val * (signal_modulated + signal_subOsc),
		pos: pan,
		level: outputVolume);

    Out.ar(
		bus: 0,
		channelsArray: LPF.ar(signal_master, freq_cutoff));

}).add;
)

~notes = Array.newClear(128);
(
NetAddr("127.0.0.1", 57120);
(
OSCdef('OSCreceiver',
	{
		arg msg;

		x = msg[1];
		y = msg[2];
		z = msg[3];
		k = msg[4];
		d = msg[5];
		g = msg[6];

		h = msg[7];
		p = msg[8];
		j = msg[9];
		l = msg[10];

		q = msg[11];
		w = msg[12];
		e = msg[13];
		r = msg[14];

		postln("SubOscLevel: "+x);
		postln("CutOff: "+y);
		postln("Harmonicity: "+z);
		postln("Richness: "+k);
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
	},
	"/diocane");
);
)

(
b = NetAddr.new("127.0.0.1", 12000);
MIDIdef.noteOn(\noteOnTest, {
	arg vel, noteNum, chan, srcID;
	[vel, noteNum].postln;
	b.sendMsg("\noteOn",noteNum);
	~notes[noteNum] = Synth.new(
		\fm,
		[
		\midi_num, noteNum,
		\gate, 1,
		\outputVolume, vel/(127.0 * 1.5),
		\subOsc_amp, x,
		\freq_cutoff, y,
		\richness_mod	,z ,
		\harmonic_mod, k,
		\freq_lfo, d,
		\depth_lfo, g,

		\attack_note, h,
		\decay_note ,  p,
		\sustain_note , j,
		\release_note , l,

		\attack_mod, q,
		\decay_mod ,  w,
		\sustain_mod,  e,
		\release_mod,  r
		]
	);
});

MIDIdef.noteOff(\noteOffTest, {
	arg vel , noteNum;
	[vel,noteNum].postln;
	b.sendMsg("\noteOff",noteNum);
	~notes[noteNum].set(\gate, 0);
	~notes[noteNum] = nil;
}
);
)








