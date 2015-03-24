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

