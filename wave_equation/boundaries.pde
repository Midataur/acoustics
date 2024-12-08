void circularBoundary(float[][] field, int x, int y, int radius) {
  for (int i = 0; i < sim_width; i++) {
    for (int j = 0; j < sim_height; j++) {
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
  for (int i = 0; i < sim_width; i++) {
    for (int j = 0; j < sim_height; j++) {
      if (sqrt(pow(i-x, 2)+pow(j-y, 2)) >= radius) {
        field[i][j] = 0;
      }
    }
  }
  
  // draw the boundary
  noFill();
  circle(x, y, 2*radius);
}

void source(float[][] field, int x, int y, float power, float freq) {
  field[x][y] = power*sin(((millis()-start)*freq*TAU)/1000);
}
