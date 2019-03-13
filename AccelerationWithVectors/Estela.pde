public class Estela {

  private float x, y, d;
  private int t, r, g, b;

  public Estela(float x, float y, float d,int r, int g, int b) {
    this.x=x;
    this.y=y;
    this.d=d;
    this.t=255;
    
    this.r=r;
    this.g=g;
    this.b=b;
  }

  public void pintar() {
    noStroke();
    fill(r, g, b, t);
    ellipse(x, y, d, d);
  }

  public void encoger() {

    if (frameCount%1==0) {
      this.d-=1;
    }
    this.t-=5;
  }

  public void setR(int d) {
    this.d=d;
  }
}
