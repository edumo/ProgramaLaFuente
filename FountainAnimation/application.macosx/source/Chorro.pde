class Chorro {
  int nbPart;
  Particle[] particle;
  float speedZ = 1.0;
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
        particle[i].gravity= -0.0;
        
        particle[i].ageMax = 10 + (int) random(10);
        if(particle[i].age >particle[i].ageMax){
          particle[i].age = particle[i].ageMax-2;
        }
        particle[i].setInitialSpeed(0.2);
      }else{
        particle[i].gravity= -0.5;
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
