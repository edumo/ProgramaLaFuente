import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import remixlab.proscene.*; 
import java.util.*; 
import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FountainAnimation extends PApplet {




/** From: 
 * Animation.
 * by Jean Pierre Charalambos.
 * 
 * The animate() function illustrated by a water particle simulation.
 *
 * When an animation is activated (scene.startAnimation()), the
 * scene.animate() function is called in an infinite loop which is synced
 * with the drawing loop by proscene according to scene.animationPeriod().
 * 
 * You can tune the frequency of your animation (default is 60Hz) using
 * setAnimationPeriod(). The frame rate will then be fixed, provided that
 * your animation loop function is fast enough.
 *
 * Press 'm' to toggle (start/stop) animation.
 * Press 'x' to decrease the animation period (animation speeds up).
 * Press 'y' to increase the animation period (animation speeds down).
 * Press 'h' to display the key shortcuts and mouse bindings in the console.
 */






OscP5 oscP5;

MyScene scene;
float maxChorro = 2.0f;
List<Chorro> chorros = new ArrayList();

FountainModel fountainModel = new FountainModel();

public void setup() {
  
  oscP5 = new OscP5(this, 12000);
  // We instantiate our MyScene class defined below
  scene = new MyScene(this);
  for (int i = 0; i<6; i++) {
    for (int j = 0; j<6; j++) {
      Chorro chorro = new Chorro();
      chorro.init(i*40-100, j*40-100);
      chorros.add(chorro);
    }
  }
  Chorro chorro = new Chorro();
  chorro.init(0, 0);
  chorros.add(chorro);
  fountainModel = new FountainModel();
  fountainModel.init();

  fountainModel.setState("a12345012345012345012345012345012345a");
}

public void pushStateModel() {
  for (FountainCell cell : fountainModel.cells) {
    Chorro c = chorros.get((int)(cell.pos.x+cell.pos.y*6));
    if (cell.difusor) {
      c.isDifusor = true;
      c.setIsDifusor();
    } else {
      c.isDifusor = false;
      float val = (cell.chorro);
      println("speedsss"+val+" chorro"+cell.chorro);
      c.setChorro(val==0?0:map(val, 0.0f, 9.0f, .4f, .9f));
      c.setIsDifusor();
    }
  }
}

// Note that proscenium will be called at the end of draw
public void draw() {
  background(0);
}

/* incoming osc message are forwarded to the oscEvent method. */
public void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  String cad = theOscMessage.get(0).toString();
  println(cad);
  fountainModel.setState(cad);
  pushStateModel();
}

public void keyPressed() {
  if (key >= '0' && key <= '9') {
    StringBuilder cad = new StringBuilder("012345012345012345012345012345012345a");
    for (int i = 0; i<36; i++) {
      cad.setCharAt(i, '0');
    }
    cad.setCharAt(36, 'a');
    fountainModel.setState(cad.toString());
    pushStateModel();
  }

  if ((key == 'x') || (key == 'X')) {
    for (Chorro c : chorros) {
      float chorro = c.getChorro()+0.1f;
      if (chorro > maxChorro) {
        chorro = maxChorro;
      }
      c.setChorro(chorro);
    }
  }    
  if ((key == 'y') || (key == 'Y')) {
    for (Chorro c : chorros) {
      float chorro = c.getChorro()-0.1f;
      if (chorro < 0) {
        chorro = maxChorro;
      }
      c.setChorro(chorro);
    }
  }
  for (Chorro c : chorros) {
    print(c.getChorro()+"-difusor:"+c.isDifusor);
  }
}

class MyScene extends Scene {


  // We need to call super(p) to instantiate the base class
  public MyScene(PApplet p) {
    super(p);
  }

  // Initialization stuff could have also been performed at
  // setup(), once after the Scene object have been instantiated
  public void init() {

    setAxesVisualHint(false);
    camera().setPosition(0, 150, 150);
    camera().lookAt(0, 0, 0);
    setAnimationPeriod(40); // 25Hz
    startAnimation();
  }

  public void proscenium() {
    for (Chorro chorro : chorros) {
      chorro.draw(g);
    }
  }

  public void animate() {
    for (Chorro chorro : chorros) {
      chorro.animate();
    }
  }
}

class Chorro {
  int nbPart;
  Particle[] particle;
  float speedZ = 1.0f;
  PVector pos = new PVector();
  public boolean isDifusor = false;

  public void init(float x, float y) {
    nbPart = 200;
    pos.x = x;
    pos.y = y;
    particle = new Particle[nbPart];
    for (int i = 0; i < particle.length; i++)
      particle[i] = new Particle();
  }

  // Define here what is actually going to be drawn.
  public void draw(PGraphics canvas) {
    canvas.pushMatrix();
    canvas.translate(pos.x, pos.y, 0);
    canvas.pushStyle();
    canvas.strokeWeight(3); // Default
    canvas.beginShape(POINTS);
    for (int i = 0; i < nbPart; i++) {
      particle[i].draw(canvas);
    }
    canvas.endShape();
    canvas.popStyle();
    canvas.popMatrix();
  }

  public void setChorro(float speedZ) {
    this.speedZ = speedZ;

    for (int i = 0; i < nbPart; i++) {
      particle[i].setInitialSpeed(speedZ);
     
        
        println(" particle[i].gravity"+ particle[i].gravity);
    }
  }
  
  public void setIsDifusor() {
    
    for (int i = 0; i < nbPart; i++) {
      
      if (isDifusor){
        particle[i].gravity= -0.0f;
        
        particle[i].ageMax = 10 + (int) random(10);
        if(particle[i].age >particle[i].ageMax){
          particle[i].age = particle[i].ageMax-2;
        }
        particle[i].setInitialSpeed(0.2f);
      }else{
        particle[i].gravity= -0.5f;
        particle[i].ageMax = 50 + (int) random(100);
        if(particle[i].age >particle[i].ageMax){
          particle[i].age = particle[i].ageMax-2;
        }
        particle[i].setInitialSpeed(speedZ);
      }
        
        println(" particle[i].gravity"+ particle[i].gravity);
    }

    
  }

  public float getChorro() {
    return speedZ;
  }



  // Define here your animation.
  public void animate() {
    for (int i = 0; i < nbPart; i++)
      if (particle[i] != null)
        particle[i].animate();
  }
}

class FountainModel {

  ArrayList<FountainCell> cells = new ArrayList();
  HashMap<String, FountainCell> cellsByPos = new HashMap();

  public void init() {

    //a\u00f1adimos las celdas estandas
    for (int i = 0; i<6; i++) {
      for (int j = 0; j<6; j++) {
        FountainCell cell = new FountainCell(new PVector(j, i), 0, false, 0, 0); 
        cells.add(cell);
        cellsByPos.put(cell.pos.x+"-"+cell.pos.y, cell);
      }
    }
    
    FountainCell cell = new FountainCell(new PVector(6, 5), 0, false, 0, 0); 
    cells.add(cell);
    cellsByPos.put(cell.pos.x+"-"+cell.pos.y, cell);
  }

  public FountainCell getCell(int x, int y) {
    return cellsByPos.get(x+"-"+y);
  }
  
  public void setState(String cmd) {
    if (cmd.length() < 27) {
      System.err.println("TENemos un prolema con la cadena no tiene el tama\u00f1o m\u00ednimo y el tam\u00f1o importa");
    }

    for (FountainCell cell : cells) {
      char c = cmd.charAt((int)(cell.pos.x+cell.pos.y*6));
      int value = c - '0';
      
      if (value <= 9) {
        cell.chorro = value;
        cell.difusor = false;
      } else {
        cell.chorro = 0;
        cell.difusor = true;
      }
      println("cell "+cell.pos.x+":"+cell.pos.y+" ->"+value+" ->difusor:"+cell.difusor );
    }
  }
}



class FountainCell {

  public FountainCell(PVector pos, float chorro, boolean difusor, int rgb1, int rgb2) {
    this.pos = pos;
    this.chorro = chorro;
    this.difusor = difusor;
    this.rgb1 = rgb1;
    this.rgb2 = rgb2;
  }

 public  PVector pos;

 public  float chorro;

  public boolean difusor;

  int rgb1;

  int rgb2;
}

class Particle {
  PVector speed;
  float initSpeedZ = 1;
  float gravity = -0.05f;
  PVector pos;
  int age;
  int ageMax;

  public Particle() {
    speed = new PVector();
    pos = new PVector();
    init();
  }

  public void animate() {
    speed.z += gravity;
    pos = PVector.add(pos, PVector.mult(speed, 10f));

    if (pos.z < 0.0f) {
      speed.z = -0.8f * speed.z;
      pos.z = 0.0f;
    }

    if (++age >= ageMax)
      init();
  }

  public void draw(PGraphics canvas) {		
    canvas.stroke( 255-255 * ((float) age / (float) ageMax), 255-255 * ((float) age / (float) ageMax), 255);
    canvas.vertex(pos.x, pos.y, pos.z);
  }

  public void init() {		
    pos = new PVector(0.0f, 0.0f, 0.0f);
    float angle = 2.0f * PI * random(1);
     float norm = random(0.01f);
    if(gravity==0){
       norm = random(0.02f);
    }
    speed = new PVector(norm * cos(angle), norm * sin(angle), random(initSpeedZ));
    age = 0;
    ageMax = 50 + (int) random(100);
  }
  
  public void setInitialSpeed(float speed){
    
    initSpeedZ = speed;
  }
  
}
  public void settings() {  size(1027, 768, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "FountainAnimation" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
