s.reboot;

Server.killAll;
s.boot;

s.scope;
s.meter;
FreqScope.new;

(
SynthDef(\fm, {
	// information of input midi
	arg midi_num = 60, midi_val = 1.0, gate = 1,

	// main parameters of modulator
	carry_gate_sin = 1, carry_gate_tri = 0, carry_gate_saw = 0, carry_gate_squ = 0, // type of carry wave
	contr_gate_sin = 1, contr_gate_tri = 0,	contr_gate_saw = 0,	contr_gate_squ = 0, // type of modulate wave
	harmonic_mod = 2,    // order of harmonic sequence
	richness_mod = 5.0,  // richness of harmonic
	subOsc_amp   = 0.3,  // the level of sub oscillator

	// envelope of modulator
	attack_mod   = 0.01,
	decay_mod    = 0.1,
	sustain_mod  = 0.2,
	release_mod  = 0.4,

	// envelope of note
	attack_note  = 0.005,
	decay_note   = 0.15,
	sustain_note = 0.4,
	release_note = 0.7,

	// lfo to modulate the fundamental frequency and modulator
	freq_lfo = 60,
	depth_lfo = 2.0,

	// bus imformation
	freq_cutoff = 5000.0,
	output_volume = 0.5,
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

	var control_mod = richness_mod * (
		(contr_gate_sin * SinOsc.ar(freq: fundamental_freq * harmonic_mod + control_lfo, mul:fundamental_freq * env_mod)) +
		(contr_gate_tri * LFTri.ar (freq: fundamental_freq * harmonic_mod + control_lfo, mul:fundamental_freq * env_mod)) +
		(contr_gate_saw * LFSaw.ar (freq: fundamental_freq * harmonic_mod + control_lfo, mul:fundamental_freq * env_mod)) +
		(contr_gate_squ * LFSaw.ar (freq: fundamental_freq * harmonic_mod + control_lfo, mul:fundamental_freq * env_mod)));

	var signal_modulated = (
		(carry_gate_sin * SinOsc.ar (freq: fundamental_freq + control_mod, mul: env_note)) +
		(carry_gate_tri * LFTri.ar  (freq: fundamental_freq + control_mod, mul: env_note)) +
		(carry_gate_saw * LFSaw.ar  (freq: fundamental_freq + control_mod, mul: env_note)) +
		(carry_gate_squ * LFPulse.ar(freq: fundamental_freq + control_mod, width: 0.5, mul: env_note)));

	var signal_subOsc = SinOsc.ar(
		freq: fundamental_freq / 2.0,
		mul: subOsc_amp * env_note);

	var signal_master = Pan2.ar(
		in: midi_val * (signal_modulated + signal_subOsc),
		pos: pan,
		level: output_volume);

    Out.ar(
		bus: 0,
		channelsArray: LPF.ar(signal_master, freq_cutoff));

}).add;
)

x = Synth(\fm, [midi_num: 69, mod_ratio: 0]);
x.set(\gate, 0);
x.release;


MIDIClient.init;
MIDIIn.connectAll;

(
var keys;

keys = Array.newClear(128);

~noteOnFunc = {
	arg val, num, chan, src;
	var node = keys.at(num);

	if (node.notNil, {
		node.release;
		keys.put(num, nil);
	});

	node = Synth.tail(nil, \fm, [
		midi_num: num,
		midi_val: val / (127.0),
		carry_gate_sin: 0,
		carry_gate_tri: 1,
		carry_gate_saw: 0,
		carry_gate_squ: 0,
		contr_gate_sin: 0,
		contr_gate_tri: 0.7,
		contr_gate_saw: 0.2,
		contr_gate_squ: 0.1]);

	keys.put(num, node);
	[chan,num,val].postln;
};

~noteOffFunc = {
	arg val, num, chan, src;
	var node = keys.at(num);

	if (node.notNil, {
		node.set(\gate,0);
	    node.release;
		keys.put(num, nil);
	});
};

a = MIDIFunc.noteOn(func: ~noteOnFunc);
b = MIDIFunc.noteOff(func: ~noteOffFunc);

q = {a.free; b.free;};
)

q.value;
