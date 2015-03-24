/* @pjs preload= "smile.png","brokencouple.png","couple.png","frown.png","background.png","arrow.png", "opening.png"; */
import ddf.minim.*;
Minim minim;
AudioPlayer player;
AudioPlayer theme;
boolean buttonClick;
PImage smile;
boolean out = false;
PImage broken_couple; //image for balloon when hit
PImage couple;
PImage frown;
PImage background;
PImage opening;
PImage winImage;
PImage loseImage;
PImage anticupid;
PImage arrow; //arrow shot by player
float distance;
int no_hit = 0;
int no_arrows = 12;
int thresh = 75; //max distance between arrow and balloon to warrant a hit
int which = 0;
float x = 750;
int index = 0;
String[] win = {
  "You extinguished it."
};
String[] lose = {
  "Love still blooms."
};
Anticupid anti_cupid;
Balloon floatingB1;  //target objects
Balloon floatingB2;  
Balloon floatingB3; 
Balloon floatingB4;  
Balloon floatingB5; 
Balloon floatingB1L2;  
Balloon floatingB2L2;  
Balloon floatingB3L2; 
Balloon floatingB4L2;  
Balloon floatingB5L2; 
Balloon floatingB1L3;  
Balloon floatingB2L3;  
Balloon floatingB3L3; 
Balloon floatingB4L3;  
Balloon floatingB5L3; 
boolean collideB1 = false; //checks if any arrow has collided with a balloon
boolean collideB2 = false;
boolean collideB3 = false;
boolean collideB4 = false;
boolean collideB5 = false;

boolean collideL21 = false;
boolean collideL22 = false;
boolean collideL23 = false;
boolean collideL24 = false;
boolean collideL25 = false;

boolean collideL31 = false;
boolean collideL32 = false;
boolean collideL33 = false;
boolean collideL34 = false;
boolean collideL35 = false;
PFont font;
PFont defaultF;
void setup() {
  size(1000, 750);  
  font = loadFont("AdobeGothicStd-Bold-48.vlw");
  defaultF = loadFont("LucidaSans-48.vlw");
  smooth();
  minim = new Minim(this);
  winImage = loadImage("youwin.png");
  loseImage = loadImage("youlose.png");
  background = loadImage("background.png"); 
  opening = loadImage("opening.png"); 
  broken_couple = loadImage("brokencouple.png"); 
  couple = loadImage("couple.png"); 
  anticupid = loadImage("anticupid.png"); 
  arrow = loadImage("arrow.png");
  frown = loadImage("frown.png");
  smile = loadImage("smile.png");
  player = minim.loadFile("balloonburst.wav");
  // theme  = minim.loadFile("anti_cupid.wav");
  anti_cupid = new Anticupid(2, 25, 375, this); //instantiates player object
  floatingB1 = new Balloon(1, 220, 300, this); //instatiantes balloon objects
  floatingB2 = new Balloon(1, 350, 267, this);
  floatingB3 = new Balloon(1, 530, 544, this);
  floatingB4 = new Balloon(1, 720, 108, this);
  floatingB5 = new Balloon(1, 900, 700, this);
  floatingB1L2 = new Balloon(3, 220, 300, this); //level 2
  floatingB2L2 = new Balloon(3, 350, 267, this);
  floatingB3L2 = new Balloon(3, 530, 544, this);
  floatingB4L2 = new Balloon(3, 720, 108, this);
  floatingB5L2 = new Balloon(3, 900, 700, this); 
  floatingB1L3 = new Balloon(5, 220, 300, this);//level 3
  floatingB2L3 = new Balloon(5, 350, 267, this);
  floatingB3L3 = new Balloon(5, 530, 544, this);
  floatingB4L3 = new Balloon(5, 720, 108, this);
  floatingB5L3 = new Balloon(5, 900, 700, this);
  //theme.loop();
}

void draw() {
  if (out == true) { //if out of arrows display this scene
    image(loseImage, 0, 0);
    scroll(lose);
    fill(255, 0, 0);
    textAlign(CENTER);
    textFont(defaultF);
    textSize(18); 
    text("You ran out... Press S to start over.", 500, 350);
    if (key == 's') { //if key pressed, reset all values
      which = 0; //which level is picked on start screen
      no_hit = 0;
      out = false; //no arrows != 0
      open(); //display start screen 
      hover();
      resetCollisions();
    }
  } else {
    if (no_hit == 5) {
      image(winImage, 0, 0);
      scroll(win);
      textSize(20);
      fill(255, 0, 0);
      text("S to start over", 500, 320);
      if (which != 3) {
        text("N to advance.", 500, 350);
      }
      if (key == 's') { 
        which = 0;
        out = false;
        no_hit = 0;
        resetCollisions();
        open();
        hover();
      } else if (key == 'n') {
        resetCollisions();
        out = false;
        no_hit = 0;
        if (which == 1) {
          which = 2;
          no_arrows = 5;
        } else if (which == 2) {
          which = 3;
          no_arrows = 3;
        } else {
          open();
          hover();
        }
      }
    } else if (which == 1 || which == 2 || which == 3) {
      commence();
      fill(255);
      textSize(16);
      text("Number hit: " + no_hit, 50, 30);
      text("Arrows left: " + no_arrows, 850, 30);
    } else {
      open();
      hover();
    }
  }
}

void hover() {
  //if user hovers over a level cue effect
  if ((mouseX > 250 && mouseX < 380) && (mouseY > 590 && mouseY < 720)) {
    rect(250, 590, 130, 130);
    textSize(24);
    fill(255, 0, 0);
    text("Level 1", 270, 665);
  }
  if ((mouseX > 450 && mouseX < 580) && (mouseY > 590 && mouseY < 720)) {
    rect(450, 590, 130, 130);
    textSize(24);
    fill(255, 0, 0);
    text("Level 2", 470, 665);
  }
  if ((mouseX > 650 && mouseX < 780) && (mouseY > 590 && mouseY < 720)) {
    rect(650, 590, 130, 130);
    textSize(24);
    fill(255, 0, 0);
    text("Level 3", 670, 665);
  }
}

void mouseClicked() {
  //checks which level was pressed
  if ((mouseX > 250 && mouseX < 380) && (mouseY > 590 && mouseY < 720)) { //level 1
    which = 1;
    no_arrows = 12;
  }
  if ((mouseX > 450 && mouseX < 580) && (mouseY > 590 && mouseY < 720)) {// level 2
    which = 2;
    no_arrows = 8;
  }
  if ((mouseX > 650 && mouseX < 780) && (mouseY > 590 && mouseY < 720)) { //level 3
    which = 3;
    no_arrows = 4;
  }
}
void resetCollisions() {
  collideB1 = false;
  collideB2 = false;
  collideB3 = false;
  collideB4 = false;
  collideB5 = false;

  collideL21 = false;
  collideL22 = false;
  collideL23 = false;
  collideL24 = false;
  collideL25 = false;

  collideL31 = false;
  collideL32 = false;
  collideL33 = false;
  collideL34 = false;
  collideL35 = false;
}
void commence() {
  //starts game
  image(background, 0, 0);
  float arrowX = anti_cupid.getX(); /* gets the x and y positions of the arrows to check for collisions */
  float arrowY = anti_cupid.getY();
  if (which == 1) {//if level chosen == 1
    float balloonX1L1 = floatingB1.returnXLocation();
    float balloonY1L1 = floatingB1.returnYLocation();
    float  balloonX2L1 = floatingB2.returnXLocation();
    float  balloonY2L1 = floatingB2.returnYLocation();
    float   balloonX3L1 = floatingB3.returnXLocation();
    float   balloonY3L1 = floatingB3.returnYLocation();
    float   balloonX4L1 = floatingB4.returnXLocation();
    float   balloonY4L1 = floatingB4.returnYLocation();
    float   balloonX5L1 = floatingB5.returnXLocation();
    float   balloonY5L1 = floatingB5.returnYLocation();
    //return locations of all the balloons in lv 1
    if (!collideB1 && ((dist(balloonX1L1, balloonY1L1, arrowX, arrowY)) < thresh)) {
      collideB1 = true; 
      no_hit++; //increases number hit
      floatingB1.pop();
      player.rewind(); //plays sound of balloon popping
      player.play();

      // floatingB1.fall();
    } 
    if (collideB1) {
      player.pause();
      floatingB1.fall(); //balloon heart breaks and it falls to it's death
    } else {
      floatingB1.move(); //move balloon & check if its at the edge
      floatingB1.checkBounds();
      floatingB1.display();
    } 
    if (!collideB2 && ((dist(balloonX2L1, balloonY2L1, arrowX, arrowY)) < thresh)) {
      collideB2 = true;
      no_hit++;
      floatingB2.pop();
      player.rewind();
      player.play();

      floatingB2.fall();
    } else if (collideB2) {
      player.pause();
      floatingB2.fall();
    } else {
      floatingB2.move();
      floatingB2.checkBounds();
      floatingB2.display();
    }
    if  (!collideB3 && ((dist(balloonX3L1, balloonY3L1, arrowX, arrowY)) < thresh)) {
      collideB3 = true;
      no_hit++;
      floatingB3.pop();
      player.rewind();
      player.play();

      floatingB3.fall();
    } else if (collideB3) {
      player.pause();
      floatingB3.fall();
    } else {
      floatingB3.move();
      floatingB3.checkBounds();
      floatingB3.display();
    } 
    if (!collideB4 && ((dist(balloonX4L1, balloonY4L1, arrowX, arrowY)) < thresh)) {
      collideB4 = true;
      no_hit++;
      floatingB4.pop();
      player.rewind();
      player.play();

      floatingB4.fall();
    } else if (collideB4) {
      player.pause();
      floatingB4.fall();
    } else {
      floatingB4.move();
      floatingB4.checkBounds();
      floatingB4.display();
    }
    if (!collideB5 && ((dist(balloonX5L1, balloonY5L1, arrowX, arrowY)) < thresh)) {
      collideB5 = true;
      no_hit++;
      floatingB5.pop();
      player.rewind();
      player.play();

      floatingB5.fall();
    } else if (collideB5) {
      player.pause();
      floatingB5.fall();
    } else {
      floatingB5.move();
      floatingB5.checkBounds();
      floatingB5.display();
    }
  }
  thresh = 50;
  if (which == 2) { //level 2
    float    balloonX1L2 = floatingB1L2.returnXLocation();
    float    balloonY1L2 = floatingB1L2.returnYLocation();
    float   balloonX2L2 = floatingB2L2.returnXLocation();
    float    balloonY2L2 = floatingB2L2.returnYLocation();
    float    balloonX3L2 = floatingB3L2.returnXLocation();
    float   balloonY3L2 = floatingB3L2.returnYLocation();
    float   balloonX4L2 = floatingB4L2.returnXLocation();
    float   balloonY4L2 = floatingB4L2.returnYLocation();
    float    balloonX5L2 = floatingB5L2.returnXLocation();
    float    balloonY5L2 = floatingB5L2.returnYLocation();
    if (!collideL21 && ((dist(balloonX1L2, balloonY1L2, arrowX, arrowY)) < thresh)) {
      collideL21 = true;
      no_hit++;
      floatingB1L2.pop();
      player.rewind();
      player.play();
      floatingB1L2.fall();
    } else if (collideL21) {
      player.pause();
      floatingB1L2.fall();
    } else {
      floatingB1L2.move();
      floatingB1L2.checkBounds();
      floatingB1L2.display();
    }
    if (!collideL22 && ((dist(balloonX2L2, balloonY2L2, arrowX, arrowY)) < thresh)) {
      collideL22 = true;
      no_hit++;
      floatingB2L2.pop();
      player.rewind();
      player.play();

      floatingB2L2.fall();
    } else if (collideL22) {
      player.pause();
      floatingB2L2.fall();
    } else {
      floatingB2L2.move();
      floatingB2L2.checkBounds();
      floatingB2L2.display();
    }
    if (!collideL23 && ((dist(balloonX3L2, balloonY3L2, arrowX, arrowY)) < thresh)) {
      collideL23 = true;
      no_hit++;
      floatingB3L2.pop();
      player.rewind();
      player.play();

      floatingB3L2.fall();
    } else if (collideL23) {
      player.pause();
      floatingB3L2.fall();
    } else {
      floatingB3L2.move();
      floatingB3L2.checkBounds();
      floatingB3L2.display();
    }
    if (!collideL24 && ((dist(balloonX4L2, balloonY4L2, arrowX, arrowY)) < thresh)) {
      collideL24 = true;
      no_hit++;
      floatingB4L2.pop();
      player.rewind();
      player.play();

      floatingB4L2.fall();
    } else if (collideL24) {
      player.pause();
      floatingB4L2.fall();
    } else {
      floatingB4L2.move();
      floatingB4L2.checkBounds();
      floatingB4L2.display();
    }
    if (!collideL25 && ((dist(balloonX5L2, balloonY5L2, arrowX, arrowY)) < thresh)) {
      collideL25 = true;
      no_hit++;
      floatingB5L2.pop();
      player.rewind();
      player.play();

      floatingB5L2.fall();
    } else if (collideL25) {
      player.pause();
      floatingB5L2.fall();
    } else {
      floatingB5L2.move();
      floatingB5L2.checkBounds();
      floatingB5L2.display();
    }
  }
  thresh = 35;
  if (which == 3) { //level 3
    float   balloonX1L3 = floatingB1L3.returnXLocation();
    float   balloonY1L3 = floatingB1L3.returnYLocation();
    float   balloonX2L3 = floatingB2L3.returnXLocation();
    float   balloonY2L3 = floatingB2L3.returnYLocation();
    float   balloonX3L3 = floatingB3L3.returnXLocation();
    float    balloonY3L3 = floatingB3L3.returnYLocation();
    float    balloonX4L3 = floatingB4L3.returnXLocation();
    float    balloonY4L3 = floatingB4L3.returnYLocation();
    float    balloonX5L3 = floatingB5L3.returnXLocation();
    float   balloonY5L3 = floatingB5L3.returnYLocation();
    if (!collideL31 && ((dist(balloonX1L3, balloonY1L3, arrowX, arrowY)) < thresh)) {
      collideL31 = true;
      no_hit++;
      floatingB1L3.pop();
      player.rewind();
      player.play();
      floatingB1L3.fall();
    } else if (collideL31) {
      player.pause();
      floatingB1L3.fall();
    } else {
      floatingB1L3.move();
      floatingB1L3.checkBounds();
      floatingB1L3.display();
    }
    if (!collideL32 && ((dist(balloonX2L3, balloonY2L3, arrowX, arrowY)) < thresh)) {
      collideL32 = true;
      no_hit++;
      floatingB2L3.pop();
      player.rewind();
      player.play();
      floatingB2L3.fall();
    } else if (collideL32) {
      player.pause();
      floatingB2L3.fall();
    } else {
      floatingB2L3.move();
      floatingB2L3.checkBounds();
      floatingB2L3.display();
    }
    if (!collideL33 && ((dist(balloonX3L3, balloonY3L3, arrowX, arrowY)) < thresh)) {
      collideL33 = true;
      no_hit++;
      floatingB3L3.pop();
      player.rewind();
      player.play();
      floatingB3L3.fall();
    } else if (collideL33) {
      player.pause();
      floatingB3L3.fall();
    } else {
      floatingB3L3.move();
      floatingB3L3.checkBounds();
      floatingB3L3.display();
    }
    if (!collideL34 && ((dist(balloonX4L3, balloonY4L3, arrowX, arrowY)) < thresh)) {
      collideL34 = true;
      no_hit++;
      floatingB4L3.pop();
      player.rewind();
      player.play();
      floatingB4L3.fall();
    } else if (collideL34) {
      player.pause();
      floatingB4L3.fall();
    } else {
      floatingB4L3.move();
      floatingB4L3.checkBounds();
      floatingB4L3.display();
    }
    if (!collideL35 && ((dist(balloonX5L3, balloonY5L3, arrowX, arrowY)) < thresh)) {
      collideL35 = true;
      no_hit++;
      floatingB5L3.pop();
      player.rewind();
      player.play();
      floatingB5L3.fall();
    } else if (collideL35) {
      player.pause();
      floatingB5L3.fall();
    } else {
      floatingB5L3.move();
      floatingB5L3.checkBounds();
      floatingB5L3.display();
    }
  }
  // out = anti_cupid.outOfArrows();
  anti_cupid.move();
  anti_cupid.checkBounds();
  anti_cupid.display();
  anti_cupid.fire();
}
void scroll(String[] theText) {
  fill(255, 0, 0);
  textFont(font, 60); 
  text(theText[index], x, 250); 
  x = x - 3;
  float w = textWidth(theText[index]);
  if (x < -w) {
    x = width; 
    index = (index + 1) % theText.length;
  }
}
void keyReleased() {
  if (key == ' ') {
    if (no_arrows != 0) {
      anti_cupid.shoot();
      no_arrows --;
    } else {
      out = true;
    }
  }
}

void open() {
  //opening screen
  textFont(defaultF); 
  image(opening, 0, 0);
  fill(170, 219, 251);
  stroke(255);
  strokeWeight(10);
  textAlign(LEFT);
  rect(250, 590, 130, 130);
  rect(450, 590, 130, 130);
  rect(650, 590, 130, 130);
  textSize(20);
  fill(0);
  text("Love is in the air. Extinguish it.", 370, 550 );
  fill(255);
  textSize(48);
  text("1", 300, 675);
  text("2", 500, 675);
  text("3", 700, 675);
}

class Anticupid {
  boolean out = false;
  float x;
  float xx;
  float yy;
  float ax;
  float y;
  float speedY;
  assignment03 user;
  int i = 0;
  ArrayList <Arrow> arrows = new ArrayList<Arrow>(); //creates arrayList of arrow objects


  Anticupid(float speed, float xPos, float yPos, assignment03 control) {
    this.speedY = speed;
    this.x = xPos;
    this.y = yPos;
    //sets values to values given on instantiation
    this.user = control;
  }
  /* controls movement of anti-cupid */
  void move() {
    if (keyPressed && key == CODED)
    {
      if (keyCode == UP)
      {
        this.y -= speedY;
      } else if (keyCode == DOWN)
      {
        this.y += speedY;
      }
    }
  }
  void shoot() {
    Arrow a = new Arrow(this.x, this.y, 8); //add new arrow to list
    arrows.add(a);
  }

  void fire() {
    for (Arrow a : arrows) {
      a.display();
      a.move();
    }
  }



  // return out;

  //  

  void display() {
    image(anticupid, this.x, this.y);
  }

  void checkBounds() {
    if (this.y > height)
    {
      this.y = this.y - height;
    }
    if (this.y < 0)
    {
      this.y = height  - this.y;
    }
  }
  float getX() {
    for (Arrow a : arrows) {
      xx =  a.returnXLocation();
    }
    return xx;
  }
  float getY() {
    for (Arrow a : arrows) {
      yy = a.returnYLocation();
    }
    return yy;
  }
}

class Arrow {
  float xArrow;
  float yArrow;
  float arrowS;

  Arrow(float x, float y, float s) {
    this.arrowS = s;
    this.xArrow = x;
    this.yArrow = y;
  }
  void display() {
    image(arrow, this.xArrow+60, this.yArrow-22); 
    /* arrow's initial location is a specific distance away from the anti-cupid */
  }
  void move() {
    this.xArrow += arrowS;
   // print(xArrow);
  }
  float returnXLocation() {
    return this.xArrow;
  }
  float returnYLocation() {
    return this.yArrow;
  }
}

class Balloon {
  float ySpeed = 2.0;
  float xPos = 0;
  float yPos = 0;
  assignment03 thisOne;


  Balloon(float sy, float x, float y, assignment03 main) {
    this.ySpeed = sy;
    this.xPos = x;
    this.yPos = y;
    this.thisOne = main;
  }
  void move() {
    this.yPos -= this.ySpeed;
  }
  void fall() {
    this.yPos += this.ySpeed;
    image(broken_couple, this.xPos, this.yPos);
  }
  void pop() {
    image(broken_couple, this.xPos, this.yPos);
  }

  float returnXLocation() {
    return this.xPos;
  }
  float returnYLocation() {
    return this.yPos;
  }
  void display() {
    image(couple, this.xPos, this.yPos);
  }

  void checkBounds() {
    if (this.yPos > height)
    {
      this.yPos = this.yPos - height;
    }
    if (this.yPos < 0)
    {
      this.yPos = height  - this.yPos;
    }
  }
}

