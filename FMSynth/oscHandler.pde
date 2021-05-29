// OSC init
public void oscInit() {
  osc = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57120);
  OscMessage message = new OscMessage("/fromProcessing");

}

public void sendOSCMessaggeKnob(String addressPattern, float knobValue) {
  OscMessage msg = new OscMessage(addressPattern);
  msg.add(knobValue);
  osc.send(msg, supercollider);
}



//Listen Supercollider
void oscEvent(OscMessage theOscMessage) {

  // Print the address pattern, typetag and the first argument of the received OscMessage
  println("### received an osc message.");
  println(" addrpattern: " + theOscMessage.addrPattern());
  println(" typetag: " + theOscMessage.typetag());
  //println(" arg: " + theOscMessage.get(0).intValue());

  // Not ON/ Note OFF
  switch(theOscMessage.addrPattern()) {
      //case("/noteOn"):
        //noteOn(theOscMessage.get(0).intValue());
        //break;
      //case("/noteOff"):
        //noteOff(theOscMessage.get(0).intValue());
        //break;
      case("/modLevel1"):
        modLevelSlider1.setValue(theOscMessage.get(0).floatValue());
        break;
      case("/modLevel2"):
        modLevelSlider2.setValue(theOscMessage.get(0).floatValue());
        break;
      case("/cutoff"):
        cutoffSlider.setValue(theOscMessage.get(0).floatValue());
      break;
    default:
        println(" arg: " + theOscMessage.get(0).intValue());
      break;
  }
}
