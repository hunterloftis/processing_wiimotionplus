/**
 * RGB Cube.
 * 
 * The three primary colors of the additive color model are red, green, and blue.
 * This RGB color cube displays smooth transitions between these colors. 
 */
 
float xmag, ymag = 0;
float newXmag, newYmag = 0; 
 
import processing.serial.*;

int baud = 19200;

Serial myPort;  // Create object from Serial class

float yaw, pitch, roll = 0.0;
float degToRad = 3.14 / 180;
 
void setup() 
{ 
  size(640, 360, P3D); 
  noStroke(); 
  colorMode(RGB, 1); 
  
  print("Starting serial...");
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, baud);
  myPort.bufferUntil('\n');
} 

void serialEvent(Serial myPort) {
  String inStr = myPort.readStringUntil('\n');
  if (inStr != null) {
    inStr = trim(inStr);
    float[] position = float(split(inStr, ","));
    if (position.length >= 3) {
      yaw = -position[0] * degToRad;
      pitch = -position[1] * degToRad;  
      roll = -position[2] * degToRad;
    }
  }
}
 
void draw() 
{ 
  background(0.5);
  
  pushMatrix(); 
 
  translate(width/2, height/2, -30); 
  
  newXmag = mouseX/float(width) * TWO_PI;
  newYmag = mouseY/float(height) * TWO_PI;
  
  float diff = xmag-newXmag;
  if (abs(diff) >  0.01) { xmag -= diff/4.0; }
  
  diff = ymag-newYmag;
  if (abs(diff) >  0.01) { ymag -= diff/4.0; }

  rotateY(-yaw);  
  rotateZ(roll);    
  rotateX(-pitch); 
  
  scale(90);
  beginShape(QUADS);

  fill(0, 1, 1); vertex(-1,  1,  1);
  fill(1, 1, 1); vertex( 1,  1,  1);
  fill(1, 0, 1); vertex( 1, -1,  1);
  fill(0, 0, 1); vertex(-1, -1,  1);

  fill(1, 1, 1); vertex( 1,  1,  1);
  fill(1, 1, 0); vertex( 1,  1, -1);
  fill(1, 0, 0); vertex( 1, -1, -1);
  fill(1, 0, 1); vertex( 1, -1,  1);

  fill(1, 1, 0); vertex( 1,  1, -1);
  fill(0, 1, 0); vertex(-1,  1, -1);
  fill(0, 0, 0); vertex(-1, -1, -1);
  fill(1, 0, 0); vertex( 1, -1, -1);

  fill(0, 1, 0); vertex(-1,  1, -1);
  fill(0, 1, 1); vertex(-1,  1,  1);
  fill(0, 0, 1); vertex(-1, -1,  1);
  fill(0, 0, 0); vertex(-1, -1, -1);

  fill(0, 1, 0); vertex(-1,  1, -1);
  fill(1, 1, 0); vertex( 1,  1, -1);
  fill(1, 1, 1); vertex( 1,  1,  1);
  fill(0, 1, 1); vertex(-1,  1,  1);

  fill(0, 0, 0); vertex(-1, -1, -1);
  fill(1, 0, 0); vertex( 1, -1, -1);
  fill(1, 0, 1); vertex( 1, -1,  1);
  fill(0, 0, 1); vertex(-1, -1,  1);

  endShape();
  
  popMatrix(); 
} 
