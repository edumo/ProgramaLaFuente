class Child {

  PVector noiseOffset;

  Child() {
    noiseOffset = new PVector(random(-1000, 1000), random(-1000, 1000));
  }


  void run() {

    float x = noise(noiseOffset.x)*(width+300)-150;
    float y = noise(noiseOffset.y)*(height+300)-150;

    noiseOffset.x += 0.01;
    noiseOffset.y += 0.01;

    fill(#F27A7F);
    ellipse(x, y, 25, 25);
  }
}