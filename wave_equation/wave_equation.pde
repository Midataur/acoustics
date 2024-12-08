// Boilerplate for a Processing Sketch

float wave_speed = 60;
float color_scale = 0.6;
float friction = 0.1;
float courant_threshold = 0.3;

float dt;
int last_millis;
int start;

float max_courant = 0;

float global_time = 0;

color red = color(255, 0, 0);
color blue = color(0, 0, 255);
color white = color(255);

float[][] field;
float[][] velocity;


void setup() {
  // Initialize your settings
  size(401, 401); // Set the size of the canvas (width, height)
  background(255); // Set the background color (white in this case)
  
  // Additional setup code goes here (e.g., setting frame rate, loading assets)
  frameRate(480); // Set the frame rate (frames per second)
  
  field = new float[width][height];
  velocity = new float[width][height];
  
  // initialise the field
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
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
  
  // makes the sim more resilient by pretending the framerate is higher than it is
  float time_dilation = 1;
  if (courant > courant_threshold) {
    float new_dt = courant_threshold/wave_speed;
    time_dilation = dt/new_dt;
    dt = new_dt;
  }
  
  global_time = global_time + dt;
  
  println(frameRate, courant, max_courant, time_dilation);
  
  // main update loop
  float[][] secondX = partialX(field);
  float[][] secondY = partialY(field);
  
  float dv;
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      dv = pow(wave_speed, 2)*(secondX[i][j]+secondY[i][j]) - friction*velocity[i][j];
      velocity[i][j] = velocity[i][j]+dv*dt;
      field[i][j] = field[i][j]+velocity[i][j]*dt;
      
      if (i == (width-1)/2 && j == 0) {
        //println("dv", dv);
      }
    }
  }
  
  drawField(field);
  
  // boundary conditions
  circularBoundary(field, (width-1)/2-50, (height-1)/2-20, 80);
  rotatedSquareBoundary(field, (width-1)/2+110, (height-1)/2+20, 80);
  
  inverseCircularBoundary(field, (width-1)/2, (height-1)/2, 200);
  
  sinSource(field, (width-1)/2, 0, 50, 1, false);
}
