


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

import remixlab.proscene.*;
import java.util.*;
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;

MyScene scene;
float maxChorro = 2.0;
List<Chorro> chorros = new ArrayList();

FountainModel fountainModel = new FountainModel();

void setup() {
  size(1027, 768, P3D);
   oscP5 = new OscP5(this,12000);
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
  chorro.init(40-100, 40-100);
  chorros.add(chorro);
  fountainModel = new FountainModel();
  fountainModel.init();

  fountainModel.setState("012345012345012345012345012345012345a");
}

public void pushStateModel() {
  for (FountainCell cell : fountainModel.cells) {
    Chorro c = chorros.get((int)(cell.pos.x+cell.pos.y*6));
    float val = (cell.chorro);
    println("speedsss"+val+" chorro"+cell.chorro);
    c.setChorro(val==0?0:map(val,0.0,9.0,.4,.9)); //<>//
  }
}

// Note that proscenium will be called at the end of draw
void draw() {
  background(0);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  String cad = theOscMessage.get(0).toString();
  println(cad);
  fountainModel.setState(cad);
  pushStateModel();
}

void keyPressed() {
  if (key >= '0' && key <= '9') {
    StringBuilder cad = new StringBuilder("012345012345012345012345012345012345a");
    for (int i = 0; i<36; i++) {
      cad.setCharAt(i, key);
    }
    fountainModel.setState(cad.toString());
    pushStateModel();
  }

  if ((key == 'x') || (key == 'X')) {
    for (Chorro c : chorros) {
      float chorro = c.getChorro()+0.1;
      if (chorro > maxChorro) {
        chorro = maxChorro;
      }
      c.setChorro(chorro);
    }
  }    
  if ((key == 'y') || (key == 'Y')) {
    for (Chorro c : chorros) {
      float chorro = c.getChorro()-0.1;
      if (chorro < 0) {
        chorro = maxChorro;
      }
      c.setChorro(chorro);
    }
  }
  for (Chorro c : chorros) {
    print(c.getChorro());
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