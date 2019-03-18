class Vehicle extends Thread {

  private PVector location;
  private PVector velocity;
  private PVector acceleration;
  private PVector target;
  private float maxspeed;
  private float maxforce;

  private float r;
  private PImage f = loadImage("/f.png");

  public Vehicle(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(x, y);
    r = random(2.0, 8.0);
    maxspeed = random(2, 8);
    maxforce = random(0.05, 0.5);
  }

  public void run() {
    while (true) {
      try {
        move();
        sleep(10);
      }
      catch(Exception e) {
      }
    }
  }
  void move() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }

  void seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    //PVector steer = PVector.sub(velocity, desired);
    steer.limit(maxforce);    
    applyForce(steer);
  }

  void flee(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxspeed);
    //PVector steer = PVector.sub(desired, velocity);
    PVector steer = PVector.sub(velocity, desired);
    steer.limit(maxforce);    
    applyForce(steer);
  }

  void arrive(PVector target) {
    PVector desired = PVector.sub(target, location);

    float d = desired.mag();
    desired.normalize();

    if (d < 300) {
      float m = map(d, 0, 100, 0, maxspeed);
      desired.mult(m);
    } else {

      desired.mult(maxspeed);
    }
    PVector steer = PVector.sub(desired, velocity);
    //PVector steer = PVector.sub(velocity, desired);
    steer.limit(maxforce); 
    //applyForce(new PVector(0.2,0.1));
    //applyForce(new PVector(desired.x*0.01,desired.y*0.01));
    //applyForce(new PVector(desired.x*0.01,0));
    applyForce(steer);
  }

  void applyForce(PVector force) {
    force.div(r);//mass
    acceleration.add(force);
  }
  void display() {
    float theta = velocity.heading() + PI/2;
    fill(0, 0, 0, 60);
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    imageMode(CENTER);

    //ellipse(0, 0, r+20, r+40);
    image(f, 0, 0);
    /*beginShape();
     vertex(0, -r*2);
     vertex(-r, r*2);
     vertex(r, r*2);
     endShape(CLOSE);*/
    popMatrix();
  }
}
