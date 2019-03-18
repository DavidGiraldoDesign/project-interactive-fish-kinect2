import java.util.HashSet;
import java.util.Set;
import java.util.Iterator;

public class XYAverageZone {

  private int startSampleX, startSampleY, endSampleX, endSampleY, sampleSizeX, sampleSizeY;
  private boolean averageCreated = false;
  private int [] averageXY = new int [2];
  private HashSet KXsample = new HashSet();
  private HashSet KYsample = new HashSet();

  public XYAverageZone(int startSampleX, int startSampleY, int endSampleX, int endSampleY) {
    this.startSampleX=startSampleX;
    this.startSampleY=startSampleY;
    this.endSampleX=endSampleX;
    this.endSampleY=endSampleY;
    this.sampleSizeX = 5;
    this.sampleSizeY = 5;
  }

  public void clearSample() {
    KXsample.clear();
    KYsample.clear();
  }

  public void gatheringSamples(int xSample, int ySample) {

    if (xSample >= startSampleX && xSample <= endSampleX && ySample >= startSampleY && ySample <= endSampleY) {
      KXsample.add(xSample);
      KYsample.add(ySample);
    }
  }

  public void createXYAverage() {
    if (KXsample.size()>= sampleSizeX && KYsample.size()>= sampleSizeY) {
      averageXY[0] = getAverage(KXsample);
      averageXY[1] = getAverage(KYsample);
      averageCreated = true;
    } else {
      averageXY[0] = 0;
      averageXY[1] = 0;
      averageCreated = false;
    }
  }
  
  public boolean IsAverageCreated() {
    return averageCreated;
  }

  public int[] getAverageXY() {
    return averageXY;
  }

  private int getAverage (HashSet set) {
    int total=0;
    int average=0;
    Iterator<Integer> sampleIterator = set.iterator();
    while (sampleIterator.hasNext()) {
      int sample = sampleIterator.next();
      total +=sample;
      average= round(total/set.size());
    }
    return average;
  }
}
