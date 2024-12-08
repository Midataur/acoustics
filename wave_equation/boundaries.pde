void circularBoundary(float[][] field, int x, int y, int radius) {
  for (int i = 0; i < sim_width; i++) {
    for (int j = 0; j < sim_height; j++) {
      float real_x = i-x;
      float real_y = j-y;
      
      if (sqrt(pow(real_x, 2)+pow(real_y, 2)) < radius) {
        field[i][j] = 0;
      }
    }
  }
  
  // draw the boundary
  noFill();
  circle(x, y, radius);
}

void inverseCircularBoundary(float[][] field, int x, int y, int radius) {
  for (int i = 0; i < sim_width; i++) {
    for (int j = 0; j < sim_height; j++) {
      float real_x = i-x;
      float real_y = j-y;
      
      if (sqrt(pow(real_x, 2)+pow(real_y, 2)) > radius) {
        field[i][j] = 0;
      }
    }
  }
  
  // draw the boundary
  noFill();
  circle(x, y, radius);
}

void source(float[][] field, int x, int y, float power, float freq) {
  field[x][y] = power*sin(((millis()-start)*freq*TAU)/1000);
}
