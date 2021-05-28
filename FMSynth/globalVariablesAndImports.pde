//GUI
import controlP5.*;
ControlP5 cp5;


//Titles
Textarea title;

//Global Elements

Textarea masterTitle ;




//LFO Elements
Textarea LFOTitle;

Textarea subOscTitle;








//Levels Controls
Textarea filterTitle;





//Carrier Elements
Textarea carrierLabel;
Group carrierADRS;



//1rst Modulator Elements
Textarea firstModLabel;
Group firstModADRS;






Textarea secondModLabel;





// OSC Open Sound Control
import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress supercollider;

//MIDI
ArrayList<Note> tempNotes;
Boolean alreadyInTempChord;
int maxNumVoices;

//BG
float bgColor;

//Keyboard
ArrayList<Key> keys;
int[] blackRect = {0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0};
int[] whiteKeysMidiNote = {
  36, 38, 40, 41, 43, 45, 47, 
  48, 50, 52, 53, 55, 57, 59, 
  60, 62, 64, 65, 67, 69, 71, 
  72, 74, 76, 77, 79, 81, 83, 84};
int[] blackKeysMidiNote = {
  37, 39, 42, 44, 46, 
  49, 51, 54, 56, 58, 
  61, 63, 66, 68, 70, 
  73, 75, 78, 80, 82};
