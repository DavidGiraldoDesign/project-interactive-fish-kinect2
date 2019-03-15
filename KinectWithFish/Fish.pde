public class Fish extends Thread {

  //Coordinates
  private float x, y, d, a;
  //Vectors
  private  PVector location;
  private  PVector velocity;
  private PVector acceleration;
  private PVector target;
  //Movement parameters
  private float speed;
  private float targetX;
  private float targetY;
  private float aMag;
  //Mouse interactions

  private boolean targetPointIsNear;
  private float XTargetPoint;
  private float YTargetPoint;
  private int detectionLimit;

  public Fish(float x, float y, float d, float a) {
    this.x=x;
    this.y=y;
    this.d=d;
    this.a=a;
    //Vector inicialization
    this.location = new PVector(this.x, this.y);
    this.velocity = new PVector(this.x, this.y);
    this.speed=2;
    this.targetX = random(0, width);
    this.targetY = random(0, height);
    this.aMag = 0.1;
    this.detectionLimit = 200;
    this.targetPointIsNear = false;
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

  public void move() {
    this.target = new PVector(this.targetX, this.targetY);
    if (this.targetPointIsNear == true) {

      //this.acceleration = PVector.sub(this.location, this.target);
      this.acceleration = PVector.sub(this.target, this.location);
    } else {
      this.acceleration = PVector.sub(this.target, this.location);
    }

    this.acceleration.setMag(aMag);
    this.velocity.add(this.acceleration);
    this.velocity.limit(this.speed);
    this.location.add(this.velocity);
    this.x = this.location.x;
    this.y = this.location.y;
  }

  public void change(float kx, float ky) {
    this.XTargetPoint = kx;
    this.YTargetPoint = ky;
    if (dist(XTargetPoint, YTargetPoint, this.getX(), this.getY())<detectionLimit) {
      this.speed=4;
      this.targetPointIsNear = true;
      this.targetX = XTargetPoint;
      this.targetY = YTargetPoint;
    } else {
      this.targetPointIsNear = false;
      this.speed= 2;
      if (frameCount%60 ==0) {
        this.targetX = random(0, width);
        this.targetY = random(0, height);
      } else {
        this.targetX = random(0, width);
        this.targetY = random(0, height);
      }
    }
  }
  public float getD() {
    return this.d;
  }
  public float getA() {
    return this.a;
  }


  public float getX() {
    return this.x;
  }

  public float getY() {
    return this.y;
  }

  public float getTargetX() {
    return this.location.x;
  }
  public float getTargetY() {
    return this.location.y;
  }
}
