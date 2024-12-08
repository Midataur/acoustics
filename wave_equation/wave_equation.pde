// Boilerplate for a Processing Sketch

float real_wave_speed = 120;
float color_scale = 1;
float friction = 0.2;

float wave_speed = 0;

float dt;
int last_millis;
int start;

int counter = 0;
float max_courant = 0;

int timeout = 20;

color red = color(255, 0, 0);
color blue = color(0, 0, 255);
color white = color(255);

float[][] field;
float[][] velocity;

int sim_width = 401;
int sim_height = 401;


void setup() {
  // Initialize your settings
  size(401, 401); // Set the size of the canvas (width, height)
  background(255); // Set the background color (white in this case)
  
  // Additional setup code goes here (e.g., setting frame rate, loading assets)
  frameRate(480); // Set the frame rate (frames per second)
  
  field = new float[sim_width][sim_height];
  velocity = new float[sim_width][sim_height];
  
  // initialise the field
  for (int i = 0; i < sim_width; i++) {
    for (int j = 0; j < sim_height; j++) {
      field[i][j] = 0;
      velocity[i][j] = 0;
    }
  }
  
  last_millis = millis();
  start = last_millis;
}

void draw() {
  // get dt
  int now = millis();
  dt = (now-last_millis)/1000.0;
  last_millis = now;
  
  // the courant number is a measuare of numerical stability
  // the lower the better (greater than 1 is unstable)
  // it gets big if the framerate drops
  float courant = wave_speed*dt;
  if (courant > max_courant) {
    max_courant = courant;
  }
  
  println(frameRate, courant, max_courant);
  
  // makes the sim more resilient by pretending the framerate is higher than it is
  if (courant > 0.3) {
    dt = 0.3/wave_speed;
  }
  
  // main update loop
  float[][] secondX = partialX(field);
  float[][] secondY = partialY(field);
  
  float dv;
  for (int i = 0; i < sim_width; i++) {
    for (int j = 0; j < sim_height; j++) {
      dv = pow(wave_speed, 2)*(secondX[i][j]+secondY[i][j]) - friction*velocity[i][j];
      velocity[i][j] = velocity[i][j]+dv*dt;
      field[i][j] = field[i][j]+velocity[i][j]*dt;
      
      if (i == (sim_width-1)/2 && j == 0) {
        //println("dv", dv);
      }
    }
  }
  
  drawField(field);
  
  // boundary conditions
  circularBoundary(field, (sim_width-1)/2-50, (sim_height-1)/2, 70);
  circularBoundary(field, (sim_width-1)/2+110, (sim_height-1)/2, 70);
  
  inverseCircularBoundary(field, (sim_width-1)/2, (sim_height-1)/2, 200);
  
  source(field, (sim_width-1)/2, 0, 50, 1);
  
  // the sim becomes numerically unstable if the frame rate drops
  // the frame rate is always really low on start up for a second
  // therefore, we skip the first few frames to avoid this
  counter++;
  if (counter == timeout) {
    wave_speed = real_wave_speed;
  }
}

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
  float[][] partial = new float[sim_width][sim_height];
  
  // calculate middle partials
  for (int i = 1; i < sim_width-1; i++) {
    for (int j = 0; j < sim_height; j++) {
      partial[i][j] = field[i+1][j]+field[i-1][j]-2*field[i][j];
    }
  }
  
  // do edge case
  // boundary conditions are that off screen is held 0
  for (int j = 0; j < sim_height; j++) {
    partial[0][j] = field[1][j]-2*field[0][j];
    partial[sim_width-1][j] = field[sim_width-2][j]-2*field[sim_width-1][j];
  }
  
  return partial;
}

// computes the 2nd order central differences
float[][] partialY(float[][] field) {
  float[][] partial = new float[sim_width][sim_height];
  
  // calculate middle partials
  for (int i = 0; i < sim_width; i++) {
    for (int j = 1; j < sim_height-1; j++) {
      partial[i][j] = field[i][j+1]+field[i][j-1]-2*field[i][j];
    }
  }
  
  // do edge case
  // boundary conditions are that off screen is held 0
  for (int i = 0; i < sim_width; i++) {
    partial[i][0] = field[i][1]-2*field[i][0];
    partial[i][sim_height-1] = field[i][sim_height-2]-2*field[i][sim_height-1];
  }
  
  return partial;
}
