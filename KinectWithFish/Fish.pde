public class Fish extends Thread {

  private PVector location;
  private PVector velocity;
  private PVector acceleration;
  private PVector target;
  private float maxspeed;
  private float maxforce;
  private boolean followingHand = false;
  private float r;
  //private PImage f = loadImage("/f.png");
  PImage [] fishFrames = new PImage[12];
  int f=0;

  public Fish(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(x, y);
    r = random(2.0, 8.0);
    maxspeed = random(2, 8);
    maxforce = random(0.05, 0.5);
    for (int i=0; i<fishFrames.length; i++) {
      fishFrames[i] = loadImage("/f"+i+".png");
    }
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

  void stayWithinWalls() {

    PVector target;

    if (location.x < 200 || location.x > width-200) {
      target = new PVector(location.x*-1, location.y);

      arrive(target);
    }
    if (location.y < 200 || location.y > height-200) {
      target = new PVector(location.x, location.y*-1);

      arrive(target);
    }
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
    //PVector steer = PVector.sub(desired, velocity);
    PVector steer = PVector.sub(velocity, desired);
    steer.limit(maxforce);    
    applyForce(steer);
  }

  void arrive(PVector target) {

    if (dist(target.x, target.y, location.x, location.y)<400) {
      followingHand = true;
      PVector desired = PVector.sub(target, location);
      float d = desired.mag();
      desired.normalize();

      if (d < 200) {
        float m = map(d, 0, 200, 0, maxspeed);
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
    } else {
      followingHand=false;
    }
  }

  boolean isFollowingHand() {
    return followingHand;
  }
  void applyForce(PVector force) {
    force.div(r);//mass
    acceleration.add(force);
  }
  void animateFish(int x, int y) {
    imageMode(CENTER);
    image(fishFrames[f], x, y);
    if (frameCount%round(r)==0) {
      
      if (f<fishFrames.length-1) {
        f++;
      } else {
        f=0;
      }
    }
  }
  void display() {
    float theta = velocity.heading() + PI/2;
    //fill(0, 0, 0, 60);
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    imageMode(CENTER);

    //ellipse(0, 0, r+20, r+40);
    //image(f, 0, 0);
    animateFish(0, 0);
    /*beginShape();
     vertex(0, -r*2);
     vertex(-r, r*2);
     vertex(r, r*2);
     endShape(CLOSE);*/
    popMatrix();
  }
}
