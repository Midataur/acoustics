float rescaleColor(float input) {
  return min(1, max(color_scale*input, -1));
}

void drawField(float[][] field) {
  loadPixels();
  
  // draw the new field
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      float new_color = rescaleColor(field[i][j]);
      if (new_color >= 0) {
        pixels[width*j+i] = lerpColor(white, red, new_color);
      } else {
        pixels[width*j+i] = lerpColor(white, blue, -new_color);
      }
    }
  }
  
  updatePixels();
}


// computes the 2nd order central differences
float[][] partialX(float[][] field) {
  float[][] partial = new float[width][height];
  
  // calculate middle partials
  for (int i = 1; i < width-1; i++) {
    for (int j = 0; j < height; j++) {
      partial[i][j] = field[i+1][j]+field[i-1][j]-2*field[i][j];
    }
  }
  
  // do edge case
  // boundary conditions are that off screen is held 0
  for (int j = 0; j < height; j++) {
    partial[0][j] = field[1][j]-2*field[0][j];
    partial[width-1][j] = field[width-2][j]-2*field[width-1][j];
  }
  
  return partial;
}

// computes the 2nd order central differences
float[][] partialY(float[][] field) {
  float[][] partial = new float[width][height];
  
  // calculate middle partials
  for (int i = 0; i < width; i++) {
    for (int j = 1; j < height-1; j++) {
      partial[i][j] = field[i][j+1]+field[i][j-1]-2*field[i][j];
    }
  }
  
  // do edge case
  // boundary conditions are that off screen is held 0
  for (int i = 0; i < width; i++) {
    partial[i][0] = field[i][1]-2*field[i][0];
    partial[i][height-1] = field[i][height-2]-2*field[i][height-1];
  }
  
  return partial;
}

float sgn(float x) {
  if (x > 0) {
    return 1;
  } else if (x < 0) {
    return -1;
  }
  return 0;
}
