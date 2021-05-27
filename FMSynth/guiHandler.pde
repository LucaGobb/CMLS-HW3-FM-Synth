//GUI init

float subOscLevel;
float cutoff=15000;
float[] harmonicity_richness = {3, 3}; 
float[] daje = {8,5};
float lfoRate;
float lfoDepth;

//Note ADSR
float noteAttack; //0.05
float noteDecay; //0.15
float noteRelease; //0.4
float noteSustain; //0.7



//Mod ADSR
float modAttack; //0.06
float modDecay; //0.1
float modRelease; //0.2
float modSustain; //0.4




//////////////
public void guiInit() {

  cp5 = new ControlP5(this);
  import oscP5.*;
//A network library for processing which supports UDP, TCP and Multicast. (should come with oscP5)
  import netP5.*;

  subOSCLevelValue = 0.3;
  


  

  



  

  

  PFont pfont = createFont("Baskerville", 10, false); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont, 14);
  
  //Title
  title = cp5.addTextarea("Title")
    .setPosition(50, 25)
    .setSize(800, 70)
    .setFont(createFont("Courier new", 60))
    .setLineHeight(14)
    .setColor(myBlack)
    //.setColorBackground(color(255,100))
    //.setColorForeground(color(255,100));
    ;
  title.setText("FM Synthesizer" );  
  
  
  LFOTitle = cp5.addTextarea("LFOLabel")
    .setPosition(700, 17)
    .setSize(100, 70)
    .setFont(createFont("Baskerville", 27))
    .setLineHeight(14)
    .setColor(myBlack)
    .setText("LFO" );
    
  masterTitle = cp5.addTextarea("MasterLabel")
    .setPosition(1200, 570)
    .setSize(220, 80)
    .setFont(createFont("Baskerville", 27))
    .setLineHeight(14)
    .setColor(myBlack)
    .setText("Master Controls" );
    

  levels = cp5.addTextarea("LevelsLabel")
    .setPosition(700, 70)
    .setSize(400, 70)
    .setFont(createFont("Baskerville", 27))
    .setLineHeight(14)
    .setColor(myBlack)
    .setText("Levels" );  
    
//Labels

    
  
    //For Carrier
    carrierLabel = cp5.addTextarea("carrierLabel.")
    .setPosition(170, 150)
    .setSize(400, 70)
    .setFont(createFont("Baskerville", 30))
    .setLineHeight(14)
    .setColor(myBlack)
    .setText("Carrier Signal" );

    //For First Modulator
    firstModLabel = cp5.addTextarea("Modulator Label.")
    .setPosition(850, 150)
    .setSize(400, 70)
    .setFont(createFont("Baskerville", 30))
    .setLineHeight(14)
    .setColor(myBlack)
    .setText("Modulators Parameters" );
    
   

// Waveform Selectors
  
  //-Carrier
    carrierWaveFormSelector = cp5.addListBox("Carrier Waveform")
    .setCaptionLabel("Waveform")
    .setPosition(15, 250)
    .setSize(100, 100)
    .setItemHeight(30)
    .setBarHeight(20)
    .setColorBackground(transparent)
    .setColorActive(myBlack)
    .setColorForeground(opaqueTransparent)
    .setFont(createFont("Baskerville", 12))
    .setHeight(140) 
    .setWidth(110)
    .addItem("Sine", 1)
    .addItem("Square", 2)
    .addItem("Triangle", 3)
    .addItem("Saw", 4);
    
  cp5.getController("Carrier Waveform")
    .getCaptionLabel()
    .setFont(font)
    .setColor(myBlack)    
    .toUpperCase(false)
    .setSize(17);
    
   //-First Modulator
  firstModWaveFormSelector = cp5.addListBox("First Mod Waveform")
    .setCaptionLabel("Waveform")
    .setPosition(700, 250)
    .setSize(100, 100)
    .setItemHeight(30)
    .setBarHeight(20)
    .setColorBackground(transparent)
    .setColorActive(myBlack)
    .setColorForeground(opaqueTransparent)
    .setFont(createFont("Baskerville", 12))
    .setHeight(140) 
    .setWidth(110)
    .addItem("Sine", 1)
    .addItem("Square", 2)
    .addItem("Triangle", 3)
    .addItem("Saw", 4);
        
    
    cp5.getController("First Mod Waveform")
    .getCaptionLabel()
    .setFont(font)
    .toUpperCase(false)
    .setColor(myBlack)   
    .setSize(17);

    

    
    

  
//ADSRs
  //For Carrier
  Group carrierADSR = cp5.addGroup("carrierADSR")
                .setPosition(250, 266)
                .setWidth(100)
                .activateEvent(true)
                .setBackgroundColor(transparent)
                .setBackgroundHeight(100)
                .setLabel("ADSR")
                .setColorBackground(transparent) 
                .setBarHeight(18) 
                .setColorForeground(opaqueTransparent)
                .setFont(createFont("Baskerville", 12))
                .setColorLabel(myBlack) 
                .setColorValue(myBlack);
                
                

                
    cp5.addSlider("noteAttack")
    .setCaptionLabel("note Attack")
    .setRange(0.01, 1.5)
    .setValue(0.05)
     .setPosition(-70,10)
     .setSize(180,9)
     .setGroup(carrierADSR)
     .setColorBackground(opaqueTransparent)
     //.setSliderMode(Slider.FLEXIBLE)
     .setColorActive(myBlack)
     .setColorTickMark(myBlack) 
     .setColorForeground(myBlack)
     .setHeight(20)
     .setFont(createFont("Baskerville", 12))
     .getCaptionLabel()
    .setFont(font)
    .toUpperCase(false)
    .setColor(myBlack)   
    .setSize(17);
     ;
     

     

     
  cp5.addSlider("noteDecay")
     .setCaptionLabel("note Decay")
     .setRange(0.01, 1.5)
     .setValue(0.15)
     .setPosition(-70,30)
     .setSize(180,9)
     .setGroup(carrierADSR)
     .setColorBackground(opaqueTransparent)
     //.setSliderMode(Slider.FLEXIBLE)
     .setColorActive(myBlack)
     .setColorTickMark(myBlack) 
     .setColorForeground(myBlack)
     .setHeight(20)
     .setFont(createFont("Baskerville", 12))
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     .setColor(myBlack)   
     .setSize(17);
     ;
   cp5.addSlider("noteSustain")
     .setCaptionLabel("note Sustain")
     .setRange(0.01, 1.5)
     .setValue(0.4)
     .setPosition(-70,50)
     .setSize(180,9)
     .setGroup(carrierADSR)
     .setColorBackground(opaqueTransparent)
    // .setSliderMode(Slider.FLEXIBLE)
     .setColorActive(myBlack)
     .setColorTickMark(myBlack) 
     .setColorForeground(myBlack)
     .setHeight(20)
     .setFont(createFont("Baskerville", 12))
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     .setColor(myBlack)   
     .setSize(17);
     ;
  cp5.addSlider("noteRelease")
     .setCaptionLabel("note Release")
     .setRange(0, 3)
     .setValue(0.7)
     .setPosition(-70,70)
     .setSize(180,9)
     .setGroup(carrierADSR)
     .setColorBackground(opaqueTransparent)
     //.setSliderMode(Slider.FLEXIBLE)
     .setColorActive(myBlack)
     .setColorTickMark(myBlack) 
     .setColorForeground(myBlack)
     .setHeight(20)
     .setFont(createFont("Baskerville", 12))
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     .setColor(myBlack)   
     .setSize(17);
     ;
     
                
   //For First Modulator
     Group firstModADSR = cp5.addGroup("firstModADSR")
                .setPosition(940, 260)
                .setWidth(100)
                .activateEvent(true)
                .setBackgroundColor(transparent)
                .setBackgroundHeight(100)
                .setLabel("ADSR")
                .setColorBackground(transparent) 
                .setBarHeight(18) 
                .setColorForeground(opaqueTransparent)
                .setFont(createFont("Baskerville", 12))
                .setColorLabel(myBlack);
                
  cp5.addSlider("modAttack")
     .setCaptionLabel("mod Attack")
     .setRange(0.01, 1.5)
     .setValue(0.06)
     .setPosition(-70,10)
     .setSize(180,9)
     .setGroup(firstModADSR)
     .setColorBackground(opaqueTransparent)
     //.setSliderMode(Slider.FLEXIBLE)
     .setColorActive(myBlack)
     .setColorTickMark(myBlack) 
     .setColorForeground(myBlack)
     .setHeight(20)
     .setFont(createFont("Baskerville", 12))
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     .setColor(myBlack)   
     .setSize(17);
     ;
     

     
  cp5.addSlider("modDecay")
     .setCaptionLabel("mod Decay")
     .setRange(0.01, 1.5)
     .setValue(0.1)
     .setPosition(-70,30)
     .setSize(180,9)
     .setGroup(firstModADSR)
     .setColorBackground(opaqueTransparent)
     //.setSliderMode(Slider.FLEXIBLE)
     .setColorActive(myBlack)
     .setColorTickMark(myBlack) 
     .setColorForeground(myBlack)
     .setHeight(20)
     .setFont(createFont("Baskerville", 12))
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     .setColor(myBlack)   
     .setSize(17);
     
     
     ;
  cp5.addSlider("modSustain")
     .setCaptionLabel("mod Sustain")
     .setRange(0.01, 1.5)
     .setValue(0.2)
     .setPosition(-70,50)
     .setSize(180,9)
     .setGroup(firstModADSR)
     .setColorBackground(opaqueTransparent)
     //.setSliderMode(Slider.FLEXIBLE)
     .setColorActive(myBlack)
     .setColorTickMark(myBlack) 
     .setColorForeground(myBlack)
     .setHeight(20)
     .setFont(createFont("Baskerville", 12))
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     .setColor(myBlack)   
     .setSize(17);
     ;
  cp5.addSlider("modRelease")
     .setCaptionLabel("mod Release")
     .setRange(0.01, 1.5)
     .setValue(0.4)
     .setPosition(-70,70)
     .setSize(180,9)
     .setGroup(firstModADSR)
     .setColorBackground(opaqueTransparent)
     //.setSliderMode(Slider.FLEXIBLE)
     .setColorActive(myBlack)
     .setColorTickMark(myBlack) 
     .setColorForeground(myBlack)
     .setHeight(20)
     .setFont(createFont("Baskerville", 12))
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     .setColor(myBlack)   
     .setSize(17);
     ;
     
     
//SLIDERS
LFODepthSlider = cp5.addSlider("lfoDepth")
    .setValue(3)
    .setRange(0, 500)
    .setPosition(865, 25)
    .setSize(100, 20)
    .setFont(createFont("Baskerville", 10))
    .setColorBackground(opaqueTransparent) 
    .setColorActive(myBlack) 
    .setColorCaptionLabel(myBlack) 
    .setRange(0, 200)
    .setColorForeground(myBlack)
    .setCaptionLabel("Depth");


LFORateSlider = cp5.addSlider("lfoRate")
    .setValue(0.5)
    .setRange(0, 12)
    .setPosition(1080, 25)
    .setSize(100, 20)
    .setFont(createFont("Baskerville", 10))
    .setColorBackground(opaqueTransparent) 
    .setColorActive(myBlack) 
    .setColorCaptionLabel(myBlack) 
    .setColorForeground(myBlack)
    .setCaptionLabel("Rate");
    


volume = cp5.addSlider("volume")
    .setPosition(1200, 490)
    .setSize(140, 20)
    .setFont(createFont("Baskerville", 10))
    .setColorBackground(opaqueTransparent) 
    .setColorActive(myBlack) 
    .setColorCaptionLabel(myBlack) 
    
    .setColorForeground(myBlack)
;
cutoffSlider = cp5.addSlider("cutoff")
    .setRange(100, 20000)
    .setDefaultValue(15000)
    .setPosition(1200, 520)
    .setValue(15000)
    .setSize(140, 20)
    .setFont(createFont("Baskerville", 10))
    .setColorBackground(opaqueTransparent) 
    .setColorActive(myBlack) 
    .setColorCaptionLabel(myBlack) 
    .setRange(100, 20000)
    .setColorForeground(myBlack)
    
;



                 
//KNOBS 
  
  //CarrierKnob
  
  
  carrierLevelKnob = cp5.addKnob("carrierLevel")
    .setCaptionLabel("Carrier Level")
    .setRange(0, 1)
    .setValue(0.8)
    .setPosition(800, 60)
    .setRadius(28)
    .setDragDirection(Knob.VERTICAL)
    .setFont(font)
    .setColorForeground(black)
    .setColorBackground(cobalto)
    .setColorActive(myBlack-30)
    .setColorValueLabel(myBlack)
    ;

  cp5.getController("carrierLevel")
    .getCaptionLabel()
    .setFont(createFont("Baskerville", 5))
    .setColor(myBlack)
    .toUpperCase(false)
    .setSize(16);
    
//modLevelKnob
  
  
  modLevelKnob = cp5.addKnob("modLevel")
    .setCaptionLabel("Mod Level")
    .setRange(0, 1)
    .setValue(0.8)
    .setPosition(1000, 60)
    .setRadius(28)
    .setDragDirection(Knob.VERTICAL)
    .setFont(font)
    .setColorForeground(black)
    .setColorBackground(cobalto)
    .setColorActive(myBlack-30)
    .setColorValueLabel(myBlack)
    ;

  cp5.getController("modLevel")
    .getCaptionLabel()
    .setFont(createFont("Baskerville", 5))
    .setColor(myBlack)
    .toUpperCase(false)
    .setSize(16);
    

  
                
                
//subOscKnob
  
  
  subOscLevelKnob = cp5.addKnob("subOscLevel")
    .setCaptionLabel("Sub Osc Level")
    .setRange(0, 1)
    .setValue(0.8)
    .setPosition(1200, 60)
    .setRadius(28)
    .setDragDirection(Knob.VERTICAL)
    .setFont(font)
    .setColorForeground(black)
    .setColorBackground(cobalto)
    .setColorActive(myBlack-30)
    .setColorValueLabel(myBlack);
    

  cp5.getController("subOscLevel")
    .getCaptionLabel()
    .setFont(createFont("Baskerville", 5))
    .setColor(myBlack)    
    .toUpperCase(false)
    .setSize(16);
    
harmRichness = cp5.addSlider2D("harmonicity_richness")
         .setPosition(1180,200)
         .setSize(200,180)
         
         .setArrayValue(daje)
         .setColorBackground(opaqueTransparent) 
         .setColorForeground(cobalto)
         .setColorActive(myBlack)   
         .setMaxX(10)
         .setMaxY(10)
         .setMinX(0.5)
         .setMinY(0.5)
         
         ;
         
         


    
harmRichness
.getCaptionLabel()
.setFont(createFont("Baskerville", 5))
.setColor(myBlack)
.toUpperCase(false)
.setSize(19);
    
    
}

void controlEvent(ControlEvent theEvent) {
  println(theEvent);
  println(theEvent.getName());
  if(theEvent.getName() != "harmonicity_richness"){ // todo: make the condition "if value is a single float"
    sendOSCMessaggeKnob("/fromProcessing/" + theEvent.getName(), theEvent.value());
  }else{
    sendOSCMessaggeKnob("/fromProcessing/harmonicity", theEvent.getArrayValue(1));
    sendOSCMessaggeKnob("/fromProcessing/richness", theEvent.getArrayValue(0));
  };
  
  
  //OscMessage myMessage = new OscMessage("/fromProcessing"); //Rate & Depth
  //myMessage.add(subOscLevel);
  //myMessage.add(cutoff);
  //myMessage.add(harmonicity_richness);
  //myMessage.add(lfoRate);
  //myMessage.add(lfoDepth);
  //myMessage.add(noteAttack); 
  //myMessage.add(noteDecay);
  //myMessage.add(noteRelease);
  //myMessage.add(noteSustain);
  //myMessage.add(modAttack);
  //myMessage.add(modDecay);
  //myMessage.add(modRelease);
  //myMessage.add(modSustain);
  //osc.send(myMessage, supercollider); 
  //myMessage.print(); 
}


//Volume knob event
/*void subOscLevel(float value) {
  subOSCLevelValue = map(value, 0, 1, 0, 1.0);
  sendOSCMessaggeKnob("/subOscLevel", subOSCLevelValue);
  println("a knob event: " + subOSCLevelValue);
}

//LFODepth slider event
void Depth(float value) {
  LFODepthValue = map(value, 0, 1, 0, 10);
  sendOSCMessaggeKnob("/LFODepth", LFODepthValue);
  println("a knob event: " + LFODepthValue);
}
  */ 
