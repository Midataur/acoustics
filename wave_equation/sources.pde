void sinSource(float[][] field, int x, int y, float power, float freq, boolean add) {
  float base = 0;
  if (add) {
    base = field[x][y];
  }
  
  field[x][y] = base+power*sin(global_time*freq*TAU);
}

void triangleSource(float[][] field, int x, int y, float power, float freq, boolean add) {
  float base = 0;
  if (add) {
    base = field[x][y];
  }
  
  field[x][y] = base+2*power*asin(sin(global_time*freq*TAU))/PI;
}

void squareSource(float[][] field, int x, int y, float power, float freq, boolean add) {
  float base = 0;
  if (add) {
    base = field[x][y];
  }
  
  field[x][y] = base+power*sgn(sin(global_time*freq*TAU));
}

void sawtoothSource(float[][] field, int x, int y, float power, float freq, boolean add) {
  float base = 0;
  if (add) {
    base = field[x][y];
  }
  
  float t = global_time*freq*TAU;
  field[x][y] = base+2*power*sgn(cos(t))*asin(sin(t))/PI;
}

void dumbassSinSource(float[][] field, int x, int y, float power, float freq, boolean add) {
  float base = 0;
  if (add) {
    base = field[x][y];
  }
  
  float t = global_time*freq*TAU;
  field[x][y] = base+power*sgn(sin(PI*t/2))*sqrt(1-pow(2*asin(sin(PI*(t+1)/2))/PI, 2));
}
