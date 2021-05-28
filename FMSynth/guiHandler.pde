//GUI init
ListBox firstModWaveformSelector ;
int firstModWaveform;

Slider inharmonicitySlider1;
float inharmonicity1 = 0.0;

Slider inharmonicitySlider2;
float inharmonicity2 = 0.0;


ListBox secondModWaveFormSelector;
int secondModWaveform;

ListBox carrierWaveFormSelector ;
int carrierModWaveform;

Slider carrierLevelSlider;
float carrierLevel = 0.8;

Slider subOscLevelSlider;
float subOscLevel=  0.5;

Slider cutoffSlider;
float cutoff = 15000;

Slider2D harmRichness1;
float[] harmonicity_richness1 = {2,3};

Slider2D harmRichness2;
float[] harmonicity_richness2 = {3,2};

Slider LFORateSlider;
float lfoRate = 10;

Slider LFODepthSlider;
float lfoDepth = 3;

Slider volumeSlider;
float volume = 0.5;


//Note ADSR
float noteAttack = 0.05;
float noteDecay = 0.15;
float noteRelease = 0.4;
float noteSustain = 0.7;



//Mod ADSR
float modAttack = 0.06; 
float modDecay = 0.1;
float modRelease = 0.2;
float modSustain = 0.4;




//////////////
public void guiInit() {

  cp5 = new ControlP5(this);
  import oscP5.*;
//A network library for processing which supports UDP, TCP and Multicast. (should come with oscP5)
  import netP5.*;

  


  

  



  

  

  PFont pfont = createFont("Baskerville", 10, false); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont, 14);
  
  //Title
  title = cp5.addTextarea("Title")
    .setPosition(50, 25)
    .setSize(800, 70)
    .setFont(createFont("Courier new", 60))
    .setLineHeight(14)
    .setColor(myBlack)
    ;
  title.setText("FM Synthesizer" );  
  
  
  LFOTitle = cp5.addTextarea("LFOLabel")
    .setPosition(20, 550)
    .setSize(100, 70)
    .setFont(createFont("Baskerville", 27))
    .setLineHeight(14)
    .setColor(myBlack)
    .setText("LFO" );
    
  masterTitle = cp5.addTextarea("MasterLabel")
    .setPosition(700, 550)
    .setSize(220, 80)
    .setFont(createFont("Baskerville", 27))
    .setLineHeight(14)
    .setColor(myBlack)
    .setText("Master Controls" );
    

  subOscTitle = cp5.addTextarea("SubOscLabel")
    .setPosition(170, 430) 
    .setSize(400, 70)
    .setFont(createFont("Baskerville", 27))
    .setLineHeight(14)
    .setColor(myBlack)
    .setText("Sub Oscillator" );  
    
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
    firstModLabel = cp5.addTextarea("First Modulator Label.")
    .setPosition(690, 10)
    .setSize(400, 70)
    .setFont(createFont("Baskerville", 30))
    .setLineHeight(14)
    .setColor(myBlack)
    .setText("First Modulator" );
    
    secondModLabel = cp5.addTextarea("Second Modulator Label.")
    .setPosition(1150, 10)
    .setSize(400, 70)
    .setFont(createFont("Baskerville", 30))
    .setLineHeight(14)
    .setColor(myBlack)
    .setText("Second Modulator" );
    
   

// Waveform Selectors
  
  //-Carrier
    carrierWaveFormSelector = cp5.addListBox("carrierModWaveform")
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
    
  cp5.getController("carrierModWaveform")
    .getCaptionLabel()
    .setFont(font)
    .setColor(myBlack)    
    .toUpperCase(false)
    .setSize(17);
    
   //-First Modulator
  firstModWaveformSelector = cp5.addListBox("firstModWaveform")
    .setCaptionLabel("Waveform")
    .setPosition(700, 60)
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
        
    
    cp5.getController("firstModWaveform")
    .getCaptionLabel()
    .setFont(font)
    .toUpperCase(false)
    .setColor(myBlack)   
    .setSize(17);
    
    
      secondModWaveFormSelector = cp5.addListBox("secondModWaveform")
    .setCaptionLabel("Waveform")
    .setPosition(1200, 60)
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
        
    
    cp5.getController("secondModWaveform")
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
                .setLabel("Note Env")
                .setColorBackground(transparent) 
                .setBarHeight(18) 
                .setColorForeground(opaqueTransparent)
                .setFont(createFont("Baskerville", 12))
                .setColorLabel(myBlack) 
                .setColorValue(myBlack);
                
                

                
    cp5.addSlider("noteAttack")
    .setCaptionLabel("A")
    .setRange(0.004, 1.5)
    .setValue(noteAttack)
     .setPosition(-70,10)
     .setSize(180,9)
     .setGroup(carrierADSR)
     .setColorBackground(opaqueTransparent)
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
     .setCaptionLabel("D")
     .setRange(0.01, 1.5)
     .setValue(noteDecay)
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
     .setCaptionLabel("S")
     .setRange(0.01, 1.5)
     .setValue(noteSustain)
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
     .setCaptionLabel("R")
     .setRange(0, 3)
     .setValue(noteRelease)
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
                .setPosition(995, 80)
                .setWidth(100)
                .activateEvent(true)
                .setBackgroundColor(transparent)
                .setBackgroundHeight(100)
                .setLabel("Mod Env")
                .setColorBackground(transparent) 
                .setBarHeight(18) 
                .setColorForeground(opaqueTransparent)
                .setFont(createFont("Baskerville", 12))
                .setColorLabel(myBlack);
                
  cp5.addSlider("modAttack")
     .setCaptionLabel("A")
     .setRange(0.0, 1.5)
     .setValue(modAttack)
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
     .setCaptionLabel("D")
     .setRange(0.0, 1.5)
     .setValue(modDecay)
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
     .setCaptionLabel("S")
     .setRange(0.0, 1.5)
     .setValue(modSustain)
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
     .setCaptionLabel("R")
     .setRange(0.0, 1.5)
     .setValue(modRelease)
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
    .setValue(lfoDepth)
    .setRange(0, 500)
    .setPosition(185, 558)
    .setSize(100, 20)
    .setFont(createFont("Baskerville", 10))
    .setColorBackground(opaqueTransparent) 
    .setColorActive(myBlack) 
    .setColorCaptionLabel(myBlack) 
    .setRange(0, 200)
    .setColorForeground(myBlack)
    .setCaptionLabel("Depth");


LFORateSlider = cp5.addSlider("lfoRate")
    .setValue(lfoRate)
    .setRange(0, 20)
    .setPosition(400, 558)
    .setSize(100, 20)
    .setFont(createFont("Baskerville", 10))
    .setColorBackground(opaqueTransparent) 
    .setColorActive(myBlack) 
    .setColorCaptionLabel(myBlack) 
    .setColorForeground(myBlack)
    .setCaptionLabel("Rate");
    


volumeSlider = cp5.addSlider("volume")
    .setValue(volume)
    .setPosition(950, 558)
    .setSize(100, 20)
    .setFont(createFont("Baskerville", 10))
    .setColorBackground(opaqueTransparent) 
    .setColorActive(myBlack) 
    .setColorCaptionLabel(myBlack) 
    .setRange(0,1)
    .setColorForeground(myBlack)
;
cutoffSlider = cp5.addSlider("cutoff")
    .setRange(100, 20000)
    .setDefaultValue(15000)
    .setPosition(1150, 558)
    .setValue(15000)
    .setSize(100, 20)
    .setFont(createFont("Baskerville", 10))
    .setColorBackground(opaqueTransparent) 
    .setColorActive(myBlack) 
    .setColorCaptionLabel(myBlack) 
    .setRange(100, 20000)
    .setColorForeground(myBlack)
    
;



                 
//KNOBS 
  
  //CarrierKnob
  

  
  
  subOscLevelSlider = cp5.addSlider("subOscLevel")
    .setValue(subOscLevel)
    .setRange(0, 1)
    .setPosition(10, 440) //10, 160
    .setSize(100, 20)
    .setFont(createFont("Baskerville", 10))
    .setColorBackground(opaqueTransparent) 
    .setColorActive(myBlack) 
    .setColorCaptionLabel(myBlack) 
    
    .setColorForeground(myBlack)
    .setCaptionLabel("Level");
    

  
  

inharmonicitySlider1 = cp5.addSlider("inharmonicity1")
    .setValue(inharmonicity1)
    .setRange(0, 1)
    .setPosition(700,450) //10, 160
    .setSize(100, 20)
    .setFont(createFont("Baskerville", 10))
    .setColorBackground(opaqueTransparent) 
    .setColorActive(myBlack) 
    .setColorCaptionLabel(myBlack) 
    .setColorForeground(myBlack)
    .setCaptionLabel("InHarmonicity");
    
inharmonicitySlider2 = cp5.addSlider("inharmonicity2")
    .setValue(inharmonicity2)
    .setRange(0, 1)
    .setPosition(1160,450) //10, 160
    .setSize(100, 20)
    .setFont(createFont("Baskerville", 10))
    .setColorBackground(opaqueTransparent) 
    .setColorActive(myBlack) 
    .setColorCaptionLabel(myBlack) 
    .setColorForeground(myBlack)
    .setCaptionLabel("InHarmonicity");

  
                
                

    


    
harmRichness1 = cp5.addSlider2D("harmonicity_richness1")
         .setMaxX(10)
         .setMaxY(10)
         .setPosition(700,215)
         .setSize(200,180)
         .setArrayValue(harmonicity_richness1) //new float[] {2,5}
         .setColorBackground(opaqueTransparent) 
         .setColorForeground(cobalto)
         .setColorActive(myBlack)   
         ;
         
harmonicity_richness1 = harmRichness1.getArrayValue();

harmRichness1
.getCaptionLabel()
.setFont(createFont("Baskerville", 5))
.setColor(myBlack)
.toUpperCase(false)
.setSize(19);

harmRichness2 = cp5.addSlider2D("harmonicity_richness2")
         .setMaxX(10)
         .setMaxY(10)
         .setPosition(1160,215)
         .setSize(200,180)
         .setArrayValue(harmonicity_richness2) //new float[] {2,5}
         .setColorBackground(opaqueTransparent) 
         .setColorForeground(cobalto)
         .setColorActive(myBlack)   
         ;
         
harmonicity_richness2 = harmRichness2.getArrayValue();

harmRichness2
.getCaptionLabel()
.setFont(createFont("Baskerville", 5))
.setColor(myBlack)
.toUpperCase(false)
.setSize(19);
    
    
}

void controlEvent(ControlEvent theEvent) {
    println(theEvent);
    println(theEvent.getName());
    if(theEvent.getName() == "harmonicity_richness1"){ // todo: make the condition "if value is a single float"
        //sendOSCMessaggeKnob("/fromProcessing/harmonicity1", theEvent.getArrayValue(1));
        //sendOSCMessaggeKnob("/fromProcessing/richness1", theEvent.getArrayValue(0));
        println("sending messages");
    }else if(theEvent.getName() == "harmonicity_richness2"){
        sendOSCMessaggeKnob("/fromProcessing/harmonicity2", theEvent.getArrayValue(1));
        sendOSCMessaggeKnob("/fromProcessing/richness2", theEvent.getArrayValue(0));
    }else{
        sendOSCMessaggeKnob("/fromProcessing/" + theEvent.getName(), theEvent.value());
    };


  //OscMessage myMessage = new OscMessage("/fromProcessing"); //Rate & Depth
  //myMessage.add(subOscLevel);
  //myMessage.add(cutoff);
  //myMessage.add(harmonicity_richness1);
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


  //myMessage.add(harmonicity_richness2);
  //myMessage.add(volume);
  //myMessage.add(carrierModWaveform);
  //myMessage.add(firstModWaveform);
  //myMessage.add(secondModWaveform);
  //myMessage.add(inharmonicity1);
  //myMessage.add(inharmonicity2);
  

  //osc.send(myMessage, supercollider);
  //myMessage.print();

}
