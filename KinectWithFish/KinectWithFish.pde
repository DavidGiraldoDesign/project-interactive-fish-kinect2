import KinectPV2.KJoint;
import KinectPV2.*;
//============================================= Kinect and Average
KinectPV2 kinect;
PImage depthImg, cloudImg, canvas;
int [] rawData;
//Distance Threashold
int maxD = 2000; // 4.5mx
int minD = 50;  //  50cm

ArrayList<XYAverageZone> zones = new ArrayList<XYAverageZone>();
int xx=400;
int yy=400;
//============================================= Kinect and Average
//private Fish f;
private ArrayList<Fish> fish = new ArrayList<Fish>();

void settings() {
  fullScreen(P3D);
}
void setup() {
  colorMode(HSB, 100);
  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);
  kinect.enablePointCloud(true);
  kinect.init();

  kinect.setLowThresholdPC(minD);
  kinect.setHighThresholdPC(maxD);

  for (int y = 0; y < height; y+=yy ) {
    for (int x = 0; x < width; x+=xx ) {
      zones.add(new XYAverageZone(x, y, x+xx, y+yy));
    }
  }
  println(zones.size());
  for (int i=0; i<100; i++) {
    Fish f =  new Fish(random(0, width), random(0, height), 10-(i*0.09), 100-(i*0.8));
    f.start();
    fish.add(f);
  }
}

void draw() {
  background(0, 60);
  //cloudPointAnalizis();
  
  for (Fish f : fish) {
    //f.move();
    for (XYAverageZone xy : zones) {
      if (xy.IsAverageCreated()==true) {
        //ellipse(xy.getAverageXY()[0], xy.getAverageXY()[1], 50, 50);
        //f.change(xy.getAverageXY()[0], xy.getAverageXY()[1]);
      }
    }
    //f.change(mouseX, mouseY);
  }

  displayGraphics();
}

void cloudPointAnalizis() {
  this.cloudImg = kinect.getPointCloudDepthImage();
  cloudImg.loadPixels();
  for (XYAverageZone xy : zones) {
    xy.clearSample();
  }
  for (int y = 0; y < 424; y++ ) {
    for (int x = 0; x < 512; x++ ) {
      int i = x+y*512;
      int module = 3;
      if (y%module==0) {
        if (x%module==0) {
          int cx = round(map(x, 0, 512, 0, width));
          int cy = round(map(y, 0, 424, 0, (424*width)/512));

          int offset = ((424*width)/512 - height)/2;

          float h = hue(cloudImg.pixels[i]);
          float s = saturation(cloudImg.pixels[i]);
          float b = brightness(cloudImg.pixels[i]);
          float a = alpha(cloudImg.pixels[i]);

          //colorMode(HSB);

          float d = map(b, 0, 100, 0, 50);

          if (b>5 && b<20) {

            for (XYAverageZone xy : zones) {
              xy.gatheringSamples(cx, cy-offset);
            }

            //ellipse(cx, cy-offset, d, d);
          }
        }
      }
    }
  }
  cloudImg.updatePixels();
  for (XYAverageZone xy : zones) {
    xy.createXYAverage();
  }

  noStroke(); 
  fill(200, 50, 50);
  for (XYAverageZone xy : zones) {
    if (xy.IsAverageCreated()==true) {
      ellipse(xy.getAverageXY()[0], xy.getAverageXY()[1], 50, 50);
    }
  }

  noFill();
  stroke(255, 0, 0);
  for (int y = 0; y < height; y+=xx ) {
    for (int x = 0; x < width; x+=yy ) {
      rect(x, y, xx, yy);
    }
  }
}

void displayGraphics() {
  

  for (Fish f : fish) {
    float a = atan2(f.getTargetY()-height/2, f.getTargetX()-width/2);
    //float a = atan2(f.getTargetY(), f.getTargetX());

    noStroke();
    fill(0, f.getA(), 100);
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
