// Boilerplate for a Processing Sketch

float wave_speed = 30;
float color_scale = 3;

color red = color(255, 0, 0);
color blue = color(0, 0, 255);
color white = color(255);

float[][] field;
float[][] velocity;

int sim_width = 801;
int sim_height = 801;


void setup() {
  // Initialize your settings
  size(401, 401); // Set the size of the canvas (width, height)
  background(255); // Set the background color (white in this case)
  
  // Additional setup code goes here (e.g., setting frame rate, loading assets)
  frameRate(60); // Set the frame rate (frames per second)
  
  field = new float[sim_width][sim_height];
  velocity = new float[sim_width][sim_height];
  
  // initialise the field
  for (int i = 0; i < sim_width; i++) {
    for (int j = 0; j < sim_height; j++) {
      field[i][j] = 0;
      velocity[i][j] = 0;
    }
  }
}

void draw() {
  float[][] secondX = partialX(partialX(field));
  float[][] secondY = partialY(partialY(field));
  
  float dv;
  for (int i = 0; i < sim_width; i++) {
    for (int j = 0; j < sim_height; j++) {
      dv = pow(wave_speed, 2)*(secondX[i][j]+secondY[i][j]);
      velocity[i][j] = velocity[i][j]+dv/frameRate;
      field[i][j] = field[i][j]+velocity[i][j]/frameRate;
    }
  }
  
  //field[(sim_width-1)/2][(sim_height-1)/2] = 50*sin(millis()/(TAU*100));
  for (int i = 0; i < sim_width; i++) {
    field[i][0] = 5*sin(millis()/(TAU*100));
  }
  
  for (int i = 0; i < 340; i++) {
    field[i][(sim_height-1)/2] = 0;
  }
  
  for (int i = 350; i < 450; i++) {
    field[i][(sim_height-1)/2] = 0;
  }
  
  for (int i = 460; i < sim_width; i++) {
    field[i][(sim_height-1)/2] = 0;
  }
  
  drawField();
}

float rescaleColor(float input) {
  return min(1, max(color_scale*input, -1));
}

void drawField() {
  loadPixels();
  
  // draw the new field
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      float new_color = rescaleColor(field[2*i][2*j]);
      if (new_color >= 0) {
        pixels[width*j+i] = lerpColor(white, red, new_color);
      } else {
        pixels[width*j+i] = lerpColor(white, blue, -new_color);
      }
    }
  }
  
  updatePixels();
}

float[][] partialX(float[][] field) {
  float[][] partial = new float[sim_width][sim_height];
  
  // calculate middle partials
  for (int i = 1; i < sim_width-1; i++) {
    for (int j = 0; j < sim_height; j++) {
      partial[i][j] = field[i+1][j]-field[i-1][j];
    }
  }
  
  // do edge case
  // boundary conditions are that off screen is held 0
  for (int j = 0; j < sim_height; j++) {
    partial[0][j] = field[1][j]/2;
    partial[sim_width-1][j] = -field[sim_width-2][j]/2;
  }
  
  return partial;
}

float[][] partialY(float[][] field) {
  float[][] partial = new float[sim_width][sim_height];
  
  // calculate middle partials
  for (int i = 0; i < sim_width; i++) {
    for (int j = 1; j < sim_height-1; j++) {
      partial[i][j] = field[i][j+1]-field[i][j-1];
    }
  }
  
  // do edge case
  // boundary conditions are that off screen is held 0
  for (int i = 0; i < sim_width; i++) {
    partial[i][0] = field[i][1]/2;
    partial[i][sim_height-1] = -field[i][sim_height-2]/2;
  }
  
  return partial;
}
