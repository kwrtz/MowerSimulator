// Instead of a bunch of floats, we now just have two PVector variables.
// Declare Mover object

boolean flagShowFoundBlackBorder = false;
boolean flagShowFoundRedObstacles = false;
boolean flagShowImage = true;

// Filename to save images to
String fileName = "BBB_V1_1_";
String lawnImage = "ground.png";
//Bell.png

Mower mower;
Perimeter per; 

PImage img;
int cntPixels;  // LOCATION = X + Y*WIDTH
int XMAX, YMAX;


// rotation angles
float alpha = 45;
int numberOfRotations;

boolean flagSaving = false;

void setup() {

  size(1000, 1000);

  mower = new Mower();
  per = new Perimeter();
  numberOfRotations = 0;


  // load image for boundary
  img = loadImage(lawnImage);
  //img = loadImage("Bell.png");

  XMAX = img.width;
  YMAX = img.height;
  cntPixels = XMAX * YMAX;

  img.loadPixels();

  if (flagShowImage == true) {
    image(img, 0, 0);
  }

  per.setup();
  per.calculateBoundary();
  per.display();


  //Startposition and direction of mower
  //mower.location = new PVector(XMAX/4, YMAX/4+200);
  // mower.location = new PVector(XMAX/2, YMAX/2+100);
  mower.location.set( per.startpoint);
  mower.velocity = new PVector(1, 0.5);

  //for (int i = 0; i < cntPixels; i += 2) { 
  //} 
  //img.updatePixels();
  // image(img, 0, 0);
}


void draw() {
  // background(255);

  // Call functions on Mover object.
  mower.update();
  mower.checkBorder();
  mower.checkObstacle();
  mower.display();

  // Save image ever 100 rotations
  if (numberOfRotations%100 == 0  && flagSaving==false) {
    String s = fileName + str(numberOfRotations) + ".png";
    save(s);
    flagSaving = true; //latch saving state because numberOfRotations has all the driven way the same value and therfore save would be called a lot of times for the same picture.
  }

  if (numberOfRotations%100 != 0) {
    flagSaving = false;
    randomSeed(millis());
  }  
  // Stop simulation
  while (numberOfRotations > 5000) {
    delay(100);
  }
}

void mouseClicked() {

  int loc = mouseX + mouseY*XMAX;
  float r = red   (img.pixels[loc]);
  float g = green (img.pixels[loc]);
  float b = blue  (img.pixels[loc]);
  print(r);
  print(" ");
  print(g);
  print(" ");
  print(b);
  print(" ");


  println(img.pixels[loc]);
}