s.reboot;

Server.killAll;
s.boot;

s.scope;
s.meter;
FreqScope.new;

(
SynthDef(\fm, {
	arg midi_num = 60, midi_val = 1.0, gate = 1,
	mod_ratio = 10.0,
	//--------------------------------------
	attack_mod   = 0.1,
	decay_mod    = 0.4,
	sustain_mod  = 0.15,
	release_mod  = 0.2,
	//--------------------------------------
	attack_note  = 0.005,
	decay_note   = 0.15,
	sustain_note = 0.4,
	release_note = 0.7;

	var carrier_freq = midi_num.midicps;

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

	var mod = SinOsc.ar(
		freq: carrier_freq * 2.0, // 2.0 for creating even-order harmonic
		mul:  carrier_freq * mod_ratio * env_mod); // richness of harmonic

	var signal = SinOsc.ar(
		freq: carrier_freq + mod,
		mul: env_note);

	signal = Pan2.ar(
		in: signal,
		pos: 0.0,
		level: midi_val);

    Out.ar(
		bus: 0,
		channelsArray: signal);

}).add;
)

x = Synth(\fm, [midi_num: 55, midi_val: 1.0, mod_ratio: 15]);
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

	node = Synth.tail(nil, \fm, [midi_num: num, midi_val: val / (127.0)]);
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








