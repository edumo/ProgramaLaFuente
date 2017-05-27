//Palette Yout sister the moon by shkabibble
//http://www.colourlovers.com/palette/34202/your_sister_the_moon
//#B8B7CD,#CEC1D1,#D7D1E0,#DADFF2,#EBF5FF,#B8B7CD,#CEC1D1,#D7D1E0  

import oscP5.*;
import netP5.*;

int numRows = 6;
int numCols = 6;

int changePresetEvery = 7500;
int lastPresetChange = -changePresetEvery;
char[] preset = new char[numRows*numCols+1];

OscP5 oscP5;
NetAddress oscServer;

ChildSystem cs;

void setup() {

  size(600, 600);
  frameRate(30);

  oscP5 = new OscP5(this, 12000);
  oscServer = new NetAddress("169.254.105.78", 12000);
  
  cs = new ChildSystem();
  for(int f=0; f<5; f++){
    cs.addChild();
  }
}

void draw() {

  if (millis()-lastPresetChange > changePresetEvery) {
    preset = generatePreset();
    println(new String(preset));
    sendPreset(preset);
    lastPresetChange = millis();
  }
  
  drawGrid();
  drawPreset(preset);
  
  cs.run();
  
}


char[] generatePreset() {

  char[] preset = new char[numRows*numCols+1];
  for (int f=0; f<(numRows/2)*(numCols/2); f++) {

    int px = f % (numCols/2);
    int py = f / (numCols/2);

    char state = '0';

    if (random(1)>0.6) {
      if (px+py<3) {
        state = char(48+(int)random(1, 10));
      } else {
        if (random(1)>0.5) {
          state = 'a';
        } else {
          state = char(48+(int)random(1, 10));
        }
      }
    }
    preset[py*numCols+px] = state;
    preset[py*numCols+numCols-1-px] = state;
    preset[(numCols-1-py)*numCols+px] = state;
    preset[(numCols-1-py)*numCols+numCols-1-px] = state;
  }

  if (random(1)>0.5) {
    preset[numRows*numCols] = 'a';
  } else {
    preset[numRows*numCols] = '0';
  }


  return preset;
}


void sendPreset(char[] preset) {

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


void drawPreset(char[] preset) {
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