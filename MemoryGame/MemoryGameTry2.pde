Minim minim1  = new Minim(this);
AudioPlayer song;
int rows ;
int cols; 
PFont myFont;
PImage b, e;
boolean showing = false; //false mean first time click
int Score = 0;
int x1, x2, y1, y2;
boolean gameState=false; //// for distinguishing other keys
boolean gameState1=false;
boolean screen1=false;
boolean screen2 =false;//when game starts so that time starts from then
int actualSecs; //actual seconds elapsed since start
int actualMins; //actual minutes elapsed since start
int startSec = 0; //used to reset seconds shown on screen to 0
int startMin = 0; //used to reset minutes shown on screen to 0
int scrnSecs; //seconds displayed on screen (will be 0-60)
int scrnMins=0; //minutes displayed on screen (will be infinite)
int restartSecs=0; //number of seconds elapsed at last click or 60 sec interval
int restartMins=0; //number of seconds ellapsed at most recent minute or click
int gameEnder=0;
int steps=1;
int highScore=0;
boolean pause=false;
boolean resume=true;
Tile [][] at;
void setup() {  

  song = minim1.loadFile("song.mp3"); //load song
  winning = minim.loadSample("winning.mp3");
  shuffle = minim.loadSample("shuffle.mp3");
  initialize = minim.loadSample("initialize.MP3");
  info = minim.loadSample("info.mp3");
  wrong = minim.loadSample("wrong.mp3");
  button = minim.loadSample("button.mp3");
  myFont = createFont("serif", 12, true);
  song.play();
  song.loop();
  size(800, 800);
  setuper();
}
void setuper() {
  b=loadImage("b.jpg");
  image(b, 0, 0, width, height); 
  drawButton(height/4, "Play \n Press P", #E1F1F7, 30);
  drawButton(height/4+100, "Help \n Press H", #E1F1F7, 30);
  drawButton(height/4+200, "High Score \n Press S", #E1F1F7, 30);
  text("Created By Muhammad Wasi Naseer", width-200, height-40);
}
void timer() {

  actualSecs = millis()/1000; //convert milliseconds to seconds, store values.
  actualMins = millis() /1000 / 60; //convert milliseconds to minutes, store values.
  scrnSecs = actualSecs - restartSecs; //seconds to be shown on screen
  scrnMins = actualMins - restartMins; //minutes to be shown on screen

  if (gameState1) { //if mouse is pressed, restart timer
    restartSecs = actualSecs; //stores elapsed SECONDS
    scrnSecs = startSec; //restart screen timer 
    restartMins = actualMins; //stores elapsed MINUTES
    scrnMins = startMin; //restart screen timer
    gameState1=false;
  }

  if (actualSecs % 60 == 0) { //after 60 secs, restart second timer 
    restartSecs = actualSecs;   //placeholder for this second in time
    scrnSecs = startSec; //reset to zero
  }
  //displays time on screen
  timerscoreButton(550, 5, nf(scrnMins, 2) + " : " + nf(scrnSecs, 2), #E1F1F7, 3);
}

void loadTheme(String theme) {
  String [] img = loadStrings(""+theme+".txt");
  String[] imgs= new String [rows*cols];
  int n = imgs.length; // 16 
  imgs = resize(img, rows*cols);//resize 8 strings into 16  
  n = imgs.length; // 16
  int x=0, y=0;
  int w = width/cols; //100 
  int h = (height-30)/rows; 
  for (int k=0; k<n; k++) {
    int r=(int)random(0, rows); //random for rows
    int c=(int)random(0, cols); //random for columns 
    while (at[r][c]!=null) { //if tile at r c is initialized then choose again
      r=(int)random(0, rows); //random for rows
      c=(int)random(0, cols); //random for columns
    }
    x= c*w;
    y= r*h;
    at[r][c] = new Tile(x, y+30, w, h, imgs[k]);
    e=loadImage("e.jpg");
    image(e, x, y+30, w, h);
  }
}
void displayHelp() {
  //helpMode = 1;
  String[] mesg = {
    "Memory Game:", 
    "* The object of the game is to turn over pairs of matching cards.", 
    "* Player chooses two cards and turns them face up by doing mouse click.", 
    "* If both two cards chosen has the same face (matched pair), then they are opened.", 
    "* If both two cards chosen has different faces, then they are temporary opened,", 
    "    but will be closed on the next click.", 
    "* Each click increases Steps counter.", 
    "* The game ends when the last pair has been opened.", 
    "* Player should try finishing the game with least steps.", 
    "* Keyboards: [C] Change Set, [N] New Game, [O] Turn Off/On Sounds, [H] Help", 
    " ", 
    "  This sketch is developed for Final Project 'Bringing It All Together'", 
    "    of Coursera's Introduction to Computational Arts course.", 
    "  To demonstrate three core areas of the course: ", 
    "    programming, visual art, and sound art.", 
    " ", 
    "          (Press B to close this help popup.)"
  };
  stroke(255);
  fill(255);
  float x = 80, y = 60;
  rect(x, y, width-(x*2), height-(y*2), 8);
  textFont(myFont, 32);
  textAlign(LEFT, TOP);
  fill(0);
  text(mesg[0], x + 30, y + 20);

  textFont(myFont, 16);
  textAlign(LEFT, TOP);
  for (int i=1; i < mesg.length; i++) {
    text(mesg[i], x + 30, y + 60 + (i*24));
  }
}
void drawButton(float y, String s, color clr, int align) {
  stroke(0);
  fill(clr);
  float x = width/3+50;
  rect(x, y, 180, 70, 8);
  textFont(myFont, 16);
  textSize(25);
  textAlign(CENTER, CENTER);
  fill(0);
  text(s, x+90, y+align);
}
void drawButtonSize(float x, float y, String s, color clr, int align, int sizeX, int sizeY) {
  stroke(0);
  fill(clr);

  rect(x, y, sizeX, sizeY, 8);
  textFont(myFont, 16);
  textSize(25);
  textAlign(CENTER, CENTER);
  fill(0);
  text(s, x+sizeX/2, y+align);
}
void timerscoreButton(float x, float y, String s, color clr, int align) {
  stroke(0);
  fill(clr);
  rect(x, y, 180, 20, 8);
  textFont(myFont, 16);
  textSize(20);
  textAlign(CENTER, CENTER);
  fill(0);
  text(s, x+90, y+align);
}
void keyPressed() {
  if (gameState==false)
  {
    if (key=='P' || key=='p') {
      button.trigger();
      image(b, 0, 0, width, height); 
      drawButton(height/4, "Select Mode", #E1F1F7, 17);
      drawButton(height/4+100, "Easy \n Press E", #E1F1F7, 30);
      drawButton(height/4+200, "Normal \n Press N", #E1F1F7, 30);
      drawButton(height/4+300, "Difficult \n Press D", #E1F1F7, 30);
      drawButtonSize(width-100.0, height-100, "Back-B ==>", #E1F1F7, 18, 4, 3);
      textSize(20);
      screen1=true;
    }
    if (key=='s'|| key=='S') { 
      button.trigger();
      drawButtonSize(width/4, height/4, "\n\n\nHigh Score\nis "+highScore+"\n\n\n\n"+"                                                 Back-B", #E1F1F7, 217, 400, 400);
    }
    if (screen1) {
      if (key=='e' || key=='E') {
        button.trigger();
        image(b, 0, 0, width, height); 
        drawButton(height/4, "Select Themes", #E1F1F7, 17);
        drawButton(height/4+100, "Fruits \n Press 3", #E1F1F7, 30);
        drawButton(height/4+200, "Cars \n Press 4", #E1F1F7, 30);
        drawButtonSize(width-100.0, height-100, "Back-B ==>", #E1F1F7, 18, 4, 3);
        textSize(20);
        rows=2;
        cols=2;
        at = new Tile[rows][cols];
        screen1=false;
        screen2=true;
      }
      if (key=='n' || key=='N') {
        button.trigger();
        image(b, 0, 0, width, height); 
        drawButton(height/4, "Select Themes", #E1F1F7, 17);
        drawButton(height/4+100, "Fruits \n Press 3", #E1F1F7, 30);
        drawButton(height/4+200, "Cars \n Press 4", #E1F1F7, 30);
        drawButtonSize(width-100.0, height-100, "Back-B ==>", #E1F1F7, 18, 4, 3);
        textSize(20);
        rows=6;
        cols=6;
        at = new Tile[rows][cols];
        screen1=false;
        screen2=true;
      }
      if (key=='d' || key=='D') {
        button.trigger();
        image(b, 0, 0, width, height); 
        drawButton(height/4, "Select Themes", #E1F1F7, 17);
        drawButton(height/4+100, "Fruits \n Press 3", #E1F1F7, 30);
        drawButton(height/4+200, "Cars \n Press 4", #E1F1F7, 30);
        drawButtonSize(width-100.0, height-100, "Back-B ==>", #E1F1F7, 18, 4, 3);
        textSize(20);
        rows=8;
        cols=8;
        at = new Tile[rows][cols];
        screen1=false;
        screen2=true;
      }
    }
    if (key=='h'||key=='H') {
      button.trigger();
      displayHelp();
    }
    if (screen2) {
      if (key=='3') {
        button.trigger();  
        loadTheme("fruits");
        gameState=true;
        gameState1=true;
      }
      if (key =='4') {
        button.trigger();
        loadTheme("cars");
        gameState=true;
        gameState1=true;
      }
    }
  }
  if (key==' ') {
    button.trigger();
    timerscoreButton(300, 5, "Paused Resume-R", #E1F1F7, 3);

    pause=true;
    resume=false;
  }
  if (key =='r'||key=='R') {
    button.trigger();
    timerscoreButton(300, 5, "Back-B", #E1F1F7, 3);
    pause=false;
    resume=true;
  }
  if (key=='b'||key=='B') {
    button.trigger();
    setuper();
    if (gameState) {
      gameState=false;
      at[x1][y1].clicked= false;
      at[x2][y2].clicked= false;
    }
    gameEnder=0;
    Score=0;
    steps=1;
  }
}

public void Matching() {
  if (at[x1][y1].iname.equals(at[x2][y2].iname)) {
    at[x1][y1].highlight();
    at[x2][y2].highlight();
    steps++;
    gameEnder=gameEnder+1;
    println("Your Score = "+ Score);
  } else {
    at[x1][y1].hide();
    at[x2][y2].hide();
    at[x1][y1].clicked= false;
    at[x2][y2].clicked= false;
    steps++;
  }
  timerscoreButton(300, 5, "Back-B", #E1F1F7, 3);
  if (gameState==true && gameEnder==(rows*cols)/2) {
    println("happy");
    Score=gameEnder*20-steps;
    drawButton(width/2-75, "Good! Your Score\nis "+Score, #E1F1F7, 30);
    if (Score>highScore) {
      highScore=Score;
    }
    gameState=false;
    winning.trigger();
    //timerscoreButton(550, 5, nf(scrnMins, 2) + " : " + nf(scrnSecs, 2), #F5BCE9, 3);
  }
}
public void check() {

  for (int i=0; i<rows; i++) {
    for (int j=0; j<cols; j++) {
      if (mouseX > at[i][j].x && mouseX < (at[i][j].x + at[i][j].w)) {
        if (mouseY > at[i][j].y && mouseY < (at[i][j].y + at[i][j].h)) {
          if (showing == false ) {
            if (at[i][j].clicked== false) {
              at[i][j].show();
              showing = true;
              x1 = i;
              y1 = j;
              at[i][j].clicked= true;
            } else {
              //do nothi
            }
          } else {
            if (at[i][j].clicked== false) {
              at[i][j].show();
              showing = false;
              x2 = i;
              y2 = j;
              at[i][j].clicked= true;
              Matching();
            }
          }
        }
      }
    }
  }
}
public String []  resize(String [] inames, int num) { 
  int j, k = num / 2, n = inames.length;        // half of total cells = (rows x cols) / 2
  // length of original array 
  String [] temp = new String[num];
  for (int i=0; i<k; i++) {
    j=(int) random(0, n);    // randomly generate an index for selecting from available images
    temp[i] = temp[num-1 - i] = inames[j];   // assign the random image to both ends of the array
  }
  return temp;
}

void draw() {
  if (mousePressed && gameState==true && pause==false) {
    check();
  }

  if (gameState==true) {
    timer();
    timerscoreButton(20, 5, "Steps: "+steps+"", #E1F1F7, 3);
  }
}
void stop() {
  song.close();
  minim1.stop();
  minim.stop();
  super.stop();
}

