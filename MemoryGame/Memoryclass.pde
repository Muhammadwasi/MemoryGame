import ddf.minim.*;
Minim minim  = new Minim(this); // created minim library
AudioSample winning,shuffle,initialize, info,wrong,button; //specific song
class Tile {
  public boolean clicked;
  public int x, y, w, h;
  public PImage img, fixImg, e;  
  public String iname;  

  public Tile(int x, int y, int w, int h, String iname) {
  
     shuffle = minim.loadSample("shuffle.mp3");
      initialize = minim.loadSample("initialize.MP3");
       info = minim.loadSample("info.mp3");
        wrong = minim.loadSample("wrong.mp3");
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.iname = iname;
    this.img = loadImage(iname);
    this.clicked = false;
  }

  public void show() {
    shuffle.trigger();
    image(img, x, y, w, h);
   /// song.stop();
    
  }

  public void hide() { 
    wrong.trigger();   
    e=loadImage("e.jpg");
    image(e, x, y, w, h);
  }
  public void highlight() {
    info.trigger();
    fixImg=loadImage("a.png");
    image(fixImg, x, y, w, h);
  }
}

