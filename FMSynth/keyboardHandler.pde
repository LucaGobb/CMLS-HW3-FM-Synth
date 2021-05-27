

public void keyboardInit() {

  keys = new ArrayList();

  int width_black = 19; // width 
  int width_white = 38; // width


  // Defining all keys  

  // white Rect
  for (int i = 0; i < 29; i++) { 
    keys.add ( new Key (30-(i*width_white), 110, width_white, 186, whiteKeysMidiNote[28-i], color(255), color(0), new PVector(1103, 300) ));
  }

  //black Rect
  int j = 0;
  for (int x = 0; x < 29; x++) {   

    if (blackRect[x] == 1) {
      keys.add ( new Key (30-(2 * x * width_black), 110, width_black, 140, blackKeysMidiNote[19-j], color(0), -1, new PVector(1094, 300) )); // -1 is for noStroke();
      j++;
    }
  }
}


public void keyboardUpdate() {

  //Red color for the pressed keys 
  if (!tempNotes.isEmpty()) {
    for (Key k : keys) {
      Boolean keyIsPressed = false;
      for (int i = 0; i < tempNotes.size(); i++) {
        if (k.getMidiNote() == tempNotes.get(i).getPitch()) {
          keyIsPressed = true;
        }
      }
      if (keyIsPressed) {
        k.setColFill(color(255, 192, 203));
      } else {
        k.setColFill(k.getColKey());
      }
    }
  } else {
    for (Key k : keys) {
      k.setColFill(k.getColKey());
    }
  }

  //Display keys
  for (Key k : keys) {
    k.display();
  }
}
