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
