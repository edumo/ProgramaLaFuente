class Particle {
  PVector speed;
  float initSpeedZ = 1;
  PVector pos;
  int age;
  int ageMax;

  public Particle() {
    speed = new PVector();
    pos = new PVector();
    init();
  }

  public void animate() {
    speed.z -= 0.05f;
    pos = PVector.add(pos, PVector.mult(speed, 10f));

    if (pos.z < 0.0) {
      speed.z = -0.8f * speed.z;
      pos.z = 0.0f;
    }

    if (++age == ageMax)
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
    speed = new PVector(norm * cos(angle), norm * sin(angle), random(initSpeedZ));
    age = 0;
    ageMax = 50 + (int) random(100);
  }
  
  public void setInitialSpeed(float speed){
    
    initSpeedZ = speed;
  }
  
}