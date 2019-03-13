import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;
PImage depthImg, cloudImg, canvas;
int [] rawData;
//Distance Threashold
int maxD = 1500; // 4.5mx
int minD = 0;  //  50cm

void setup() {
  size(1240, 720, P3D);
  colorMode(HSB, 100);
  kinect = new KinectPV2(this);

  //Enable point cloud
  kinect.enableDepthImg(true);
  kinect.enablePointCloud(true);

  kinect.init();
}

void draw() {
  background(0);
  this.depthImg = kinect.getDepthImage();
  this.rawData = kinect.getRawDepthData();
  this.cloudImg = kinect.getPointCloudDepthImage();

  //image(kinect.getDepthImage(), 0, 0);

  /* obtain the point cloud as a PImage
   * Each pixel of the PointCloudDepthImage corresponds to the Z value
   * of Point Cloud i.e. distances.
   * The Point cloud values are mapped from (0 - 4500) mm  to gray color format (0 - 255)
   */
  image(cloudImg, 512, 0);

  //obtain the raw depth data in integers from [0 - 4500]

  cloudImg.loadPixels();
  for (int y = 0; y < 424; y++ ) {
    for (int x = 0; x < 512; x++ ) {
      int i = x+y*512;


      int module = 10;
      if (y%module==0) {
        if (x%module==0) {
          int cx = round(map(x, 0, 512, 0, width));
          int cy = round(map(y, 0, 424, 0, height));



          float h = hue(cloudImg.pixels[i]);
          float s = saturation(cloudImg.pixels[i]);
          float b = brightness(cloudImg.pixels[i]);
          float a = alpha(cloudImg.pixels[i]);

          float d = map(b, 0, 100, 0, 50);

          noStroke();
          if (b>20&&b<40) {
            fill(200, 100, b, a);
          } else {

            fill(h, s, b, a);
          }
          ellipse(cx, cy, d-20, d-20);
        }
      }
    }
  }
  cloudImg.updatePixels();


  //Threahold of the point Cloud.
  kinect.setLowThresholdPC(minD);
  kinect.setHighThresholdPC(maxD);
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
