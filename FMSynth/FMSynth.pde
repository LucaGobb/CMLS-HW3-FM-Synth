int Y_AXIS = 1;
int X_AXIS = 2;
color myBlack, cobalto, black, white, transparent , opaqueTransparent, primo, rosa;






void setup() {
  
  size(1400, 620);
   
   // Define colors

  cobalto = color(141, 175, 181);
  black = color(0);
  white = color(255, 255, 255);
  transparent = color(0, 0, 0, 1);
  opaqueTransparent = color(0, 0, 0, 50);
  primo = color(109, 137, 140);
  myBlack = color(33, 42, 43);
  rosa = color(255, 128, 176);




 oscInit();
  guiInit();
  midiInit();

}


void draw() {

   // Background
  setGradient(0, 0, width, height, primo, cobalto, X_AXIS);

}
