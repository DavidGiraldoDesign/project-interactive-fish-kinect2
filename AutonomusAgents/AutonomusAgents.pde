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
float [] pointsX = new float [4];
float [] pointsY = new float [4];
void settings() {
  //size(1240, 720);
  fullScreen();
}

void setup() {
  noCursor();
  for (int i=0; i<50; i++) {
    v = new Vehicle(random(width), random(height));
    v.start();
    vs.add(v);
  }
}
float iC;
float iS;
boolean seekHand= false;
void draw() {

  fill(10, 10, 30);
  rect(0, 0, width, height);
  //background(255, 5);
  fill(255);
  ellipse(mouseX, mouseY, 50, 50);

  noFill();
  stroke(255);
  //rect(200, 200, width-400, height-400);

  float ampS = height*0.4;
  float ampC = width*0.4;
  iS+=0.02;
  iC+=0.01;
  float sin = sin(iS)*ampS;
  float cos = cos(iC)*ampC;
  fill(255);
  float flowX = (width/2)+(cos);
  float flowY = (height/2)+(sin);
  ellipse(flowX, flowY, 10, 10);

  for (int i=0; i<pointsX.length; i++) {

    pointsX[i] = mouseX+(i*300);
    pointsY[i] = mouseY+(i*300);

    fill(255, 0, 0);
    ellipse(pointsX[i], pointsY[i], 10, 10);
  }

  for (Vehicle v : vs) {
    v.display();
    //v.seek(new PVector(mouseX, mouseY));

    for (int i=0; i<pointsX.length; i++) {

      v.arrive(new PVector( pointsX[i], pointsY[i]));
      if (v.isFollowingHand()==true) {
        break;
      }
    }



    if (v.isFollowingHand()==false) {
      v.seek(new PVector(flowX, flowY));
    }


    //v.stayWithinWalls();
  }
}
void mousePressed() {
  fill(255, 0, 0);
  ellipse(mouseX, mouseY, 50, 50);
  seekHand = true;
}
void mouseReleased() {
  seekHand = false;
}
