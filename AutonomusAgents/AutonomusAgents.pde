/*
from: Nature of code
 https://natureofcode.com/book/chapter-6-autonomous-agents/
 Components:
 1- An autonomous agent has a limited ability to perceive environment.
 2- An autonomous agent processes the information from its environment and calculated an action.
 3- An autonomous agent has no leader.
 
 Usuing Vehicles as the main unit
 
 1) Action Selection: A desire drives the calculation of an action. Such as seek a target,
 avoid an obstacle, or follow a path. The elements of the system and its goals.
 2) Steering: Steering force = desired velocity - current velocity.
 3) Locomotion: The way it moves.
 
 PVector steer = PVector.sub(desired,velocity);
 
 PVector desired = PVector.sub(target,location);
 "The vehicle desires to move towards the target at maximum speed"
 
 */
Vehicle v;
ArrayList<Vehicle> vs = new ArrayList<Vehicle>();
color bg; 
void settings() {
  //size(1240, 720);
  fullScreen();
}

void setup() {
  for (int i=0; i<100; i++) {
    v = new Vehicle(random(width), random(height));
    v.start();
    vs.add(v);
  }
}

void draw() {

  background(20,20,80);
  //background(255, 5);
  fill(255);
  ellipse(mouseX, mouseY, 50, 50);

  for (Vehicle v : vs) {
    v.display();
    //v.seek(new PVector(mouseX, mouseY));
    v.arrive(new PVector(mouseX, mouseY));
  }
}

void mouseDragged() {
  for (Vehicle v : vs) {
    v.flee(new PVector(mouseX, mouseY));
  }
}
