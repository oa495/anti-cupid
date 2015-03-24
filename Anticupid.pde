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

