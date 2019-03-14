import KinectPV2.KJoint;
import KinectPV2.*;
import java.util.HashSet;
import java.util.Set;
import java.util.Iterator;

KinectPV2 kinect;
PImage depthImg, cloudImg, canvas;
int [] rawData;
int [] Xsample, Ysample;

HashSet KXsample = new HashSet();
HashSet KYsample = new HashSet();


//Distance Threashold
int maxD = 2000; // 4.5mx
int minD = 50;  //  50cm

void setup() {
  //size(1240, 720, P3D);
  fullScreen(P3D);
  colorMode(HSB, 100);
  kinect = new KinectPV2(this);

  //Enable point cloud
  kinect.enableDepthImg(true);
  kinect.enablePointCloud(true);

  kinect.init();

  Xsample = new int[10];
  Ysample = new int[10];
}

void draw() {
  background(0, 0, 50);
  this.depthImg = kinect.getDepthImage();
  this.rawData = kinect.getRawDepthData();
  this.cloudImg = kinect.getPointCloudDepthImage();

  //image(cloudImg, 512, 0);

  if (!test) {
    println("------ loadPixels");

    cloudImg.loadPixels();

    KXsample.clear();
    KYsample.clear();
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

            if (b>5 && b<20) {

              if (cy < height) {
                KXsample.add(cx);
                KYsample.add(cy-offset);
              }

              ellipse(cx, cy-offset, d, d);
                      }
          }
        }
      }
    }
    cloudImg.updatePixels();
 
    fill(200, 50, 50);
    ellipse(getAverage(KXsample), getAverage(KYsample), 50, 50);

  }


  //Threahold of the point Cloud.
  kinect.setLowThresholdPC(minD);
  kinect.setHighThresholdPC(maxD);
}

int getAverage (HashSet set) {
  int total=0;
  int average=0;
  Iterator<Integer> sampleIterator = set.iterator();
  while (sampleIterator.hasNext()) {
    int sample = sampleIterator.next();
    total +=sample;
    average=total/set.size();
  }
  return average;
}

void keyPressed() {
  if (key == '1') {
    minD += 10;
    println("Change min: "+minD);
  }

  if (key == '2') {
    minD -= 10;
    println("Change min: "+minD);
  }

  if (key == '3') {
    maxD += 50;
    println("Change max: "+maxD);
  }

  if (key == '4') {
    maxD -=50;
    println("Change max: "+maxD);
  }
}
