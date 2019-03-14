//private Fish f;
private ArrayList<Fish> fish = new ArrayList<Fish>();

void settings() {
  size(1240, 720, P3D);
}
void setup() {
  //f  = new Fish(width/2, height/2);
  for (int i=0; i<100; i++) {
    fish.add(new Fish(width/2, height/2,10-(i*0.09)));
  }
}

void draw() {
  for (Fish f : fish) {
    f.move();
    f.change(mouseX,mouseY);
  }

  displayGraphics();
}
void displayGraphics() {
  background(0,60);
  for (Fish f : fish) {
    float a = atan2(f.getTargetY()-height/2, f.getTargetX()-width/2);
    //float a = atan2(f.getTargetY(), f.getTargetX());
    
    noStroke();
    fill(255);
    pushMatrix();
    translate(f.getX(), f.getY());
    rotate(a);
    rectMode(CENTER);
    rect(0, 0, 40+f.getD(), f.getD());
    fill(255, 0, 0);
    ellipse(10+f.getD(), 0, 10, 10);
    popMatrix();
  }
}
void mousePressed() {
}

void mouseReleased() {
}
