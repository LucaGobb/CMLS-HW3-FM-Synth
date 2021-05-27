
//Midi init
public void midiInit() {
  tempNotes = new ArrayList<Note>();
  alreadyInTempChord = false;
  maxNumVoices = 8;
}

//Note ON
public void noteOn(int midiNote) {

  Note newNote = new Note(midiNote);

  for (int i = 0; i<tempNotes.size(); i++) {
    if (tempNotes.get(i).getPitch() == newNote.getPitch()) {
      alreadyInTempChord = true;
      break;
    }
  }

  if (maxNumVoices - tempNotes.size()>0) {
    if (alreadyInTempChord) {
      alreadyInTempChord =false;
    } else {
      tempNotes.add(newNote);
    }
  } else {
    if (alreadyInTempChord) {      
      alreadyInTempChord = false;
    } else {
      tempNotes.remove(tempNotes.size()-1); // Removing the most recent     
      tempNotes.add(newNote);
    }
  }

  //print
  println("tempNotes: ");
  for (int i = 0; i < tempNotes.size(); i++) {
    println(tempNotes.get(i).getPitch());
  }
}

//Note OFF
public void noteOff(int midiNote) {

  for (int c = 0; c < tempNotes.size(); c -= -1) {
    if (tempNotes.get(c).getPitch() == midiNote) {
      tempNotes.remove(c);
    }
  }

  //print
  println("tempNotes: ");
  for (int i = 0; i < tempNotes.size(); i++) {
    println(tempNotes.get(i).getPitch());
  }
}
