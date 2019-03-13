/**
 * Acceleration with Vectors 
 * by Daniel Shiffman.  
 * 
 * Demonstration of the basics of motion with vector.
 * A "Mover" object stores location, velocity, and acceleration as vectors
 * The motion is controlled by affecting the acceleration (in this case towards the mouse)
 *
 * For more examples of simulating motion and physics with vectors, see 
 * Simulate/ForcesWithVectors, Simulate/GravitationalAttraction3D
 */

// A Mover object
import java.util.*;
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;
PImage depthImg, cloudImg, canvas;
int [] rawData;
//Distance Threashold
int maxD = 2000; // 4.5mx
int minD = 50;  //  50cm
float kx, ky;


LinkedList<Mover> bichos = new LinkedList<Mover>();

float g;
void settings() {
  // size(1500, 800);
  fullScreen();
}

void setup() {
  colorMode(HSB, 100);
  kinect = new KinectPV2(this);

  //Enable point cloud
  kinect.enableDepthImg(true);
  kinect.enablePointCloud(true);

  kinect.init();

  for (int i = 0; i<80; i++) {
    Mover b = new Mover();
    b.start();
    bichos.add(b);
  }
}

void draw() {
background(50, 60, 130);
  this.depthImg = kinect.getDepthImage();
  this.rawData = kinect.getRawDepthData();
  this.cloudImg = kinect.getPointCloudDepthImage();
  cloudImg.loadPixels();
  boolean first = false;
  for (int y = 0; y < 424; y++ ) {
    for (int x = 0; x < 512; x++ ) {

      int i = x+y*512;

      int module = 5;
      if (y%module==0) {
        if (x%module==0) {
          int cx = round(map(x, 0, 512, 0, width));
          int cy = round(map(y, 0, 424, 0, (424*width)/512));

          int offset = ((424*width)/512 - height)/2;

          float h = hue(cloudImg.pixels[i]);
          float s = saturation(cloudImg.pixels[i]);
          float b = brightness(cloudImg.pixels[i]);
          float a = alpha(cloudImg.pixels[i]);

          colorMode(HSB);

          float d = map(b, 0, 100, 0, 50);
          //ellipse(cx, cy-offset, d, d);
          if (b>10 && b<25) {
            if (!first) {  
              noStroke();
              fill(130, 80, 100);
              // 
              kx=cx;
              ky= cy-offset;
              first=true;
              background(50, 80, 130);
            }
          }
        }
      }
    }
  }
  cloudImg.updatePixels();

  //Threahold of the point Cloud.
  kinect.setLowThresholdPC(minD);
  kinect.setHighThresholdPC(maxD);
  

  

  ellipse(kx, ky, 10, 10);
  for (Mover m : bichos) {
    m.display();
    m.perseguir(kx, ky);
  }
}
