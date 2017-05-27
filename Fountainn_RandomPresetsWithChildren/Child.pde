class Child {

  PVector noiseOffset;

  Child() {
    noiseOffset = new PVector(random(-1000, 1000), random(-1000, 1000));
  }


  void run() {

    float x = noise(noiseOffset.x)*width;
    float y = noise(noiseOffset.y)*height;

    noiseOffset.x += 0.01;
    noiseOffset.y += 0.01;

    fill(#F27A7F);
    ellipse(x, y, 25, 25);
  }
}