void circularBoundary(float[][] field, int x, int y, int radius) {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      if (sqrt(pow(i-x, 2)+pow(j-y, 2)) <= radius) {
        field[i][j] = 0;
      }
    }
  }
  
  // draw the boundary
  noFill();
  circle(x, y, 2*radius);
}

void inverseCircularBoundary(float[][] field, int x, int y, int radius) {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      if (sqrt(pow(i-x, 2)+pow(j-y, 2)) >= radius) {
        field[i][j] = 0;
      }
    }
  }
  
  // draw the boundary
  noFill();
  circle(x, y, 2*radius);
}

void squareBoundary(float[][] field, int x, int y, int radius) {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      if (max(abs(i-x), abs(j-y)) == radius) {
        field[i][j] = 0;
      }
    }
  }
  
  // draw the boundary
  noFill();
  rectMode(RADIUS);
  square(x, y, radius);
}

void rotatedSquareBoundary(float[][] field, int x, int y, int radius) {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      if (abs(i-x)+abs(j-y) == radius) {
        field[i][j] = 0;
      }
    }
  }
  
  // draw the boundary
  noFill();
  rectMode(RADIUS);
  
  pushMatrix();
  translate(x, y);
  rotate(PI/4);
  square(0, 0, radius/sqrt(2));
  popMatrix();
}
