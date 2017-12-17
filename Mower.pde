class Mower {

  // Our object has two PVectors: location and velocity
  PVector location;
  PVector velocity;

  final int MAXHISTORY = 15; 
  PVector[] history; 
  float drivenDistance;


  boolean isArcNotInitialised;
  float state0Count;
  float state1Count;
  float state2Count;
  float state0CountMax;
  float state1CountMax;
  float state2CountMax;
  int state;

  int angleCounter;


  Mower() {
    location = new PVector(width/2, height/2+200);
    velocity = new PVector(1, 1);
    isArcNotInitialised = true;
    angleCounter = 0;
    state = 0;
    drivenDistance = 0;
    history = new PVector[MAXHISTORY];
    for (int x = 0; x < MAXHISTORY; x++) {
      history[x] = new PVector(0, 0);
    }
  }

  void update() {
    // Motion 101: Locations changes by velocity.
    shiftHistory();
    location.add(velocity);
    drivenDistance += velocity.mag();
    history[MAXHISTORY-1].set(location);
    /*
     print(velocity);
     print("");
     println(velocity.mag());
     */
  }

  void shiftHistory() {
    for (int x = 1; x < MAXHISTORY; x++) {
      history[x-1].set(history[x]);
    }
  } 
  
  // returns the angle from v1 to v2 in clockwise direction
  // range: [0..TWO_PI]
  float angle(PVector v1, PVector v2) {
    float a = atan2(v2.y, v2.x) - atan2(v1.y, v1.x);
    if (a < 0) a += TWO_PI;
    return a;
  }

  void display() {
    noStroke();
    fill(175);
    ellipse(location.x, location.y, 6, 6);
    //println(location);
  }

  void calcAngle() {
    
    if (isArcNotInitialised) {
      state0CountMax = random(15, 33); 
      state1CountMax = random(2, 5);
      state2CountMax = random(2, 5);
      state2Count = 0;
      state0Count = 0;
      state1Count = 0;
      state2Count = 0;
      angleCounter = 0;
      isArcNotInitialised = false;
    }

        /*
        if ( drivenDistance >300 && (dodgeArcCounterBig%3 == 0)) {
         alpha = random(100, 130);
         print("\t!05,>300");
         }
        */


    switch (state) {

      //transfer functions

    case 0: // Default mow routine
        state0Count++;
        alpha = random(5, 80);
        print("\t!05,5-80");

      // Transition
      if (state0Count >= state0CountMax) { 
        state = 1;
     }
      break; //case 0

    case 1:
        state1Count++;
        alpha = random(60, 110);
        print("\t!05,60-110");

       // Transition
      if (state1Count >= state1CountMax) {
        isArcNotInitialised = true;
        state = 0;
      }

      break; //case 1
    case 2:
        /*
        state2Count++;
        alpha = random(5, 15);
        print("\t!05,5-30");

       // Transition
      if (state2Count >= state2CountMax) {
        isArcNotInitialised = true;
        state = 0;
      }
      */ 
      break;
    }


    print(" Arc: ");
    print(alpha);

    print("\tdist: ");
    print(drivenDistance);
    print("\t#rot: ");
    println(numberOfRotations);
    if (angleCounter==0) {
      println("------------");
    }
   
  }


  void checkObstacle() {

    if (drivenDistance < 6) {
      return;
    }

    if (per.isObstacle(location)) {
      numberOfRotations ++;

      float direction = random(0, 100);
      float w = random(60, 135);
      if (direction<50) {
        velocity.rotate(radians(w));
      } else {
        velocity.rotate(radians(-w));
      }
      
      location.set(history[0]); // Simulate drive back
      drivenDistance = 0;
    }
  }


  void checkBorder() {


    if (drivenDistance <=1.5) {
      return;
    } 


    if (per.bounced(location)) {


      numberOfRotations ++;

      Cell c =  per.bouncedCell;

      float impactAngle =angle(c.direction, velocity);

      print("ImpactAngle: ");
      print(degrees(impactAngle));
      //alpha = 70;

      calcAngle();

      velocity.set(c.direction);
      if (impactAngle < PI) {
        velocity.rotate(radians(90-alpha));
      } else {
        velocity.rotate(radians(-90+alpha));
      }  
      
       drivenDistance = 0;
       
      /*
      print(velocity);
       print(" ");
       print(velocity.mag());
       */
      //println("BOUNCE");
    }
  }
}