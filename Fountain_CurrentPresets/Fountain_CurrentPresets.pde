//Palette Yout sister the moon by shkabibble
//http://www.colourlovers.com/palette/34202/your_sister_the_moon
//#B8B7CD,#CEC1D1,#D7D1E0,#DADFF2,#EBF5FF,#B8B7CD,#CEC1D1,#D7D1E0  

import oscP5.*;
import netP5.*;

int numRows = 6;
int numCols = 6;

int changePresetEvery = 15000;
int lastPresetChange = -changePresetEvery;

String[] presets;
int presetPointer = 0;

OscP5 oscP5;
NetAddress oscServer;


void setup() {

  size(600, 600);
  frameRate(30);

  oscP5 = new OscP5(this, 12000);
  oscServer = new NetAddress("169.254.105.78", 12000);
  
  presets = loadStrings("presets.txt");

}

void draw() {

  if (millis()-lastPresetChange > changePresetEvery) {
    presetPointer++;
    if (presetPointer >= presets.length) {
      presetPointer = 0;
    }

    sendPreset(presets[presetPointer]);
    lastPresetChange = millis();
  }
  
  drawGrid();
  drawPreset(presets[presetPointer]);
  
  
}



void sendPreset(String preset) {

  OscMessage presetMessage = new OscMessage("/plf");
  presetMessage.add(new String(preset)); 
  oscP5.send(presetMessage, oscServer);
}


void drawGrid() {
  background(#B8B7CD);
  stroke(#DADFF2);

  for (int y=0; y<=numRows; y++) {    
    line(0, y*(height-1)/numRows, width, y*(height-1)/numRows);
  }
  for (int x=0; x<=numCols; x++) {    
    line(x*(width-1)/numCols, 0, x*(width-1)/numCols, height);
  }
}


void drawPreset(String stringPreset) {
  
  char[] preset = stringPreset.toCharArray();
  
  noStroke();
  for (int f=0; f<numRows*numCols; f++) {

    int px = f % numCols;
    int py = f / numCols;
    int chorro = (preset[f]-48) * 10;

    if (preset[f]=='a') {
      fill(#EBF5FF, 90);
      chorro = 7 * 10;
    } else {
      fill(#EBF5FF, 255);
    }

    if (preset[f]!='0') {
      ellipse((px+0.5)*(width-1)/numCols, (py+0.5)*(height-1)/numRows, chorro, chorro);
    }
  }

  if (preset[numRows*numCols]=='a') {
    fill(#EBF5FF, 90);
    ellipse(width/2, height/2, 10 * 10, 10 * 10);
  }
}


/*
void oscEvent(OscMessage theOscMessage) {
 println("OSC addrpattern: "+theOscMessage.addrPattern());
 println("OSC     typetag: "+theOscMessage.typetag());
 }
 */