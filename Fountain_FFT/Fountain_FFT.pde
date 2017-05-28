//Palette Yout sister the moon by shkabibble
//http://www.colourlovers.com/palette/34202/your_sister_the_moon
//#B8B7CD,#CEC1D1,#D7D1E0,#DADFF2,#EBF5FF,#B8B7CD,#CEC1D1,#D7D1E0  
import processing.sound.*;
import oscP5.*;
import netP5.*;

int numRows = 6;
int numCols = 6;

int changePresetEvery = 150;
int lastPresetChange = -changePresetEvery;
char[] preset = new char[numRows*numCols+1];

float weightedAmp = 0, currentAmp;
float weight = 0.4;

OscP5 oscP5;
NetAddress oscServer;

Amplitude amp;
AudioIn in;

void setup() {

  size(600, 600);
  frameRate(30);

  oscP5 = new OscP5(this, 12000);
  oscServer = new NetAddress("169.254.105.78", 12000);

  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
}


void draw() {

  currentAmp = amp.analyze();
  weightedAmp = weightedAmp * (1-weight) + currentAmp * weight;

  if (millis()-lastPresetChange > changePresetEvery) {
    preset = generatePreset(weightedAmp);
    sendPreset(preset);
    lastPresetChange = millis();
  }

  drawGrid();
  drawPreset(preset);
}


char[] generatePreset(float weightedAmp) {

  char[] preset = new char[numRows*numCols+1];

  int value = 0;
  if (weightedAmp>0.8) {
    value = 1;
  } else if (weightedAmp>0.2) {
    value = (int)map(weightedAmp, 0.2, 0.8, 1, 9);
  }

  for (int f=0; f<numRows*numCols; f++) {
    preset[f] = char(48+value);
  }
  preset[numRows*numCols] = '0';
  
  println(preset[0] + " " + weightedAmp);

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