/**
 * Acceleration with Vectors 
 * by Daniel Shiffman.  
 * 
 * Demonstration of the basics of motion with vector.
 * A "Mover" object stores location, velocity, and acceleration as vectors
 * The motion is controlled by affecting the acceleration (in this case towards the mouse)
 */


class Mover extends Thread {

  // The Mover tracks location, velocity, and acceleration 
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector direccion;
  // The Mover's maximum speed
  float topspeed;
  int cambio, cambio_dos;
  int t, r, g, b;
  float a;
  LinkedList<Estela> estelas = new LinkedList<Estela>();

  Mover() {
    // Start in the center
    location = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    direccion = new PVector(random(width), random(height));
    topspeed = (int)random(2, 6);
    a = 0.05;
    cambio = (int)random(10, 100);
    cambio_dos= (int)random(10, 100);
    this.r=150;
    this.g=150;
    this.b=160;
  }

  public void run() {
    while (true) {

      try {
        update();
        sleep(25);
      }
      catch(Exception e) {
      }
    }
  }

  void update() {

    // Compute a vector that points from location to mouse

    acceleration = PVector.sub(direccion, location);
    // Set magnitude of acceleration
    acceleration.setMag(a);
    // Velocity changes according to acceleration
    velocity.add(acceleration);
    // Limit the velocity by topspeed
    velocity.limit(topspeed);
    // Location changes by velocity
    location.add(velocity);
  }

  public void perseguir(float cx, float cy) {
    // if (frameCount%cambio_dos==0) {
    if (dist(cx, cy, getX(), getY())<300) {
      topspeed = (int)random(4,8);
      a=1;
      direccion = new PVector(cx, cy);
      //cambio = (int)random(2, 200);
    } else {

        direccion = new PVector(width/2, height/2);
      
      a=0.02;
      topspeed = (int)random(10, 20);
    }
    //}
  }

  public float getX() {
    return location.x;
  }

  public float getY() {
    return location.y;
  }

  void display() {
    noStroke();
    fill(r, g, b);
    ellipse(location.x, location.y, 30, 30);

    if (frameCount%1==0) {
      estelas.add(new  Estela(getX(), getY(), 30, r, g, b));
    }
    if (estelas.size()>50) {
      estelas.removeFirst();
    }
    for (Estela e : estelas) {
      e.pintar();
      e.encoger();
    }
  }
}
