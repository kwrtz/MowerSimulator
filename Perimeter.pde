class Perimeter {

  Cell[][] boundary;
  final int MAXCHAIN = 5;
  PVector[] chain;
  Cell bouncedCell;

  int x;
  int y;

  int position = 0; 

  PVector P0 =   new PVector(0, 0);
  PVector P1 =   new PVector(0, 0);
  PVector P2 =   new PVector(0, 0);
  PVector P3 =   new PVector(0, 0);
  PVector P4 =   new PVector(0, 0);
  PVector P5 =   new PVector(0, 0);
  PVector P6 =   new PVector(0, 0);
  PVector P7 =   new PVector(0, 0);

  PVector startpoint = new PVector(0, 0);
  PVector runningPoint = new PVector(0, 0);                 
  // Cell Constructor
  Perimeter() {
  } 

  void setup() {

    chain = new PVector[MAXCHAIN];
    for (int x = 0; x < MAXCHAIN; x++) {
      chain[x] = new PVector(0, 0);
    }

    //------------------------------  
    // Create grid of boundery
    //------------------------------
    boundary = new Cell[XMAX][YMAX];
    for (int x = 0; x < XMAX; x++) {
      for ( int y = 0; y < YMAX; y++ ) {
        boundary[x][y] = new Cell(x, y);
      }
    }
    // determin boundary and obstacle
    for ( int x = 0; x < XMAX; x++) {
      for ( int y = 0; y < YMAX; y++ ) {
        
        // Calculate the 1D pixel location
        int loc = x + y*XMAX;

        if (img.pixels[loc] == color(0, 0, 0)) { //Perimeter pixel
          boundary[x][y].border = 2;
          /*
           print(x);
           print (":");
           println(y);
           */
        } else if (img.pixels[loc] == color(255, 0, 0)) { // Obstacle pixel
          boundary[x][y].border = 3;
          /*
          print(x);
           print (":");
           println(y);
           */
        }
      }
    }
  } 



  boolean isBorder1(PVector v) {
    if (boundary[(int)v.x][(int)v.y].border == 1) {
      return true;
    }  
    return false;
  }

  boolean isObstacle(PVector v) {
    if (boundary[(int)v.x][(int)v.y].border == 3) {
      return true;
    }  
    return false;
  }


  boolean bounced(PVector v) {

    setAdjacents(v);

    if (isBorder1(v)) {
      bouncedCell = getCell(v);
      return true;
    }
    if (isBorder1(P0)) {
      bouncedCell = getCell(P0);
      return true;
    }
    if (isBorder1(P1)) {
      bouncedCell = getCell(P1);
      return true;
    }
    if (isBorder1(P2)) {
      bouncedCell = getCell(P2);
      return true;
    }
    if (isBorder1(P3)) {
      bouncedCell = getCell(P3);
      return true;
    }
    if (isBorder1(P4)) {
      bouncedCell = getCell(P4);
      return true;
    }
    if (isBorder1(P5)) {
      bouncedCell = getCell(P5);
      return true;
    }
    if (isBorder1(P6)) {
      bouncedCell = getCell(P6);
      return true;
    }
    if (isBorder1(P7)) {
      bouncedCell = getCell(P7);
      return true;
    }

    return false;
  }


  Cell getCell(PVector v) {
    return boundary[(int)v.x][(int)v.y];
  }

  Cell getCell(int x1, int y1) {
    return boundary[(int)x1][(int)y1];
  }

  void display() {
    // Display found boundary 
    for (int i = 0; i < XMAX; i++) {
      for (int j = 0; j < YMAX; j++ ) {
        boundary[i][j].display();
      }
    }
  }

  // returns the angle from v1 to v2 in clockwise direction
  // range: [0..TWO_PI]
  float angle(PVector v1, PVector v2) {
    float a = atan2(v2.y, v2.x) - atan2(v1.y, v1.x);
    if (a < 0) a += TWO_PI;
    return a;
  }

  void shiftChain() {
    for (int x = 1; x < MAXCHAIN; x++) {
      chain[x-1].set(chain[x]);
    }
  }  



  void setAdjacents(PVector v) {
    P0.x= v.x-1;
    P0.y= v.y-1;
    P1.x= v.x-1;
    P1.y= v.y;
    P2.x= v.x-1;
    P2.y= v.y+1;
    P3.x= v.x;
    P3.y= v.y+1;
    P4.x= v.x+1;
    P4.y= v.y+1;
    P5.x= v.x+1;
    P5.y= v.y;
    P6.x= v.x+1;
    P6.y= v.y-1;
    P7.x= v.x;
    P7.y= v.y-1;
  }


  void findNextPointCC() {
    boolean found = false;

    // 0 7 6
    // 1   5
    // 2 3 4

    int i = 0;
    // looks for pixes transition from 0 to (1 or 2) 
    do {
      switch(position) {
      case 0: 
        if ( boundary[(int)P0.x][(int)P0.y].border > 0   &&  boundary[(int)P7.x][(int)P7.y].border < 1  ) {
           //Transiton found from P7 to P0
          runningPoint.x = P0.x; 
          runningPoint.y = P0.y;
          boundary[(int)runningPoint.x][(int)runningPoint.y].border = 1;  //Mark P0 as Perimeter boundary
          position = 4;
          found = true;
        } else {
          position = 1;
        }  
        break;
      case 1: 
        if ( boundary[(int)P1.x][(int)P1.y].border > 0   &&  boundary[(int)P0.x][(int)P0.y].border < 1  ) {
          runningPoint.x = P1.x; 
          runningPoint.y = P1.y;
          boundary[(int)runningPoint.x][(int)runningPoint.y].border = 1;
          position = 5;
          found = true;
        } else {
          position = 2;
        }  
        break;
      case 2: 
        if ( boundary[(int)P2.x][(int)P2.y].border > 0   &&  boundary[(int)P1.x][(int)P1.y].border < 1  ) {
          runningPoint.x = P2.x; 
          runningPoint.y = P2.y;
          boundary[(int)runningPoint.x][(int)runningPoint.y].border = 1;
          position = 6;
          found = true;
        } else {
          position = 3;
        }  
        break;

      case 3: 
        if ( boundary[(int)P3.x][(int)P3.y].border > 0   &&  boundary[(int)P2.x][(int)P2.y].border < 1  ) {
          runningPoint.x = P3.x; 
          runningPoint.y = P3.y;
          boundary[(int)runningPoint.x][(int)runningPoint.y].border = 1;
          position = 7;
          found = true;
        } else {
          position = 4;
        }  
        break;

      case 4: 
        if ( boundary[(int)P4.x][(int)P4.y].border > 0   &&  boundary[(int)P3.x][(int)P3.y].border < 1  ) {
          runningPoint.x = P4.x; 
          runningPoint.y = P4.y;
          boundary[(int)runningPoint.x][(int)runningPoint.y].border = 1;
          position = 0;
          found = true;
        } else {
          position = 5;
        }  
        break;

      case 5: 
        if ( boundary[(int)P5.x][(int)P5.y].border > 0   &&  boundary[(int)P4.x][(int)P4.y].border < 1  ) {
          runningPoint.x = P5.x; 
          runningPoint.y = P5.y;
          boundary[(int)runningPoint.x][(int)runningPoint.y].border = 1;
          position = 1;
          found = true;
        } else {
          position = 6;
        }  
        break;

      case 6: 
        if ( boundary[(int)P6.x][(int)P6.y].border > 0   &&  boundary[(int)P5.x][(int)P5.y].border < 1  ) {
          runningPoint.x = P6.x; 
          runningPoint.y = P6.y;
          boundary[(int)runningPoint.x][(int)runningPoint.y].border = 1;
          position = 2;
          found = true;
        } else {
          position = 7;
        }  
        break;

      case 7: 
        if ( boundary[(int)P7.x][(int)P7.y].border > 0   &&  boundary[(int)P6.x][(int)P6.y].border < 1  ) {
          runningPoint.x = P7.x; 
          runningPoint.y = P7.y;
          boundary[(int)runningPoint.x][(int)runningPoint.y].border = 1;
          position = 3;
          found = true;
        } else {
          position = 0;
        }  
        break;
      }

      if (i>9) {
        println("ERROR NEXT POINT NOT FOUND");
      }  
      i++;
      //println(position);
    } while (found == false);
  }  


  void calculateBoundary() {

    // determin bondary
    //------------------------------
    // Find first inner startpoint of boundary
    //------------------------------
    y = YMAX/2;
    //find the left perimeter boarder pixel
    for ( x = 0; x < XMAX; x++) {
      if (boundary[x][y].border == 2) {
        break;
      }
    }
    //find the right (inner) perimer boarder pixel
    for (++x; x < XMAX; x++) {
      if (boundary[x][y].border == 0) {
        startpoint.x = x-1; 
        startpoint.y = y;
        runningPoint.x = x-1; 
        runningPoint.y = y;
        position = 5;
        println("found");
        break;
      }
    }

    stroke(255, 127, 80);
    fill(255, 127, 80);
    ellipse(startpoint.x, startpoint.y, 14, 14);

    //------------------------------
    // Run inside the perimeter boundary CW 
    // The chain array has 5 boundary cells in. The caluclation of the direction vector is done for the position 2 in the array by calculating the vector betwenn position 0 and 4. 
    //------------------------------

    int cnt=0;
    int cnt2=0;
    println(runningPoint);

    do {
       //runningPoint is the current found inner pixel from where the next pixel is searched
      if (cnt == 50) {
        startpoint=runningPoint.copy();
        ellipse(startpoint.x, startpoint.y, 14, 14);
      }  

      setAdjacents(runningPoint);
      findNextPointCC();
      shiftChain();
      chain[MAXCHAIN-1].set(runningPoint);

      PVector v = new PVector(chain[MAXCHAIN-1].x, chain[MAXCHAIN-1].y);
      //print(chain[0]);
      //print(v);
      v.sub( chain[0]);
      v.rotate(PI/2);
      v.normalize();
      boundary[(int)chain[2].x][(int)chain[2].y].direction =  v.copy();
      //println(v);


      // draw every 10 pixel the direction vector in white
      if (cnt2 > 10) {
        PVector p = boundary[(int)chain[2].x][(int)chain[2].y].position.copy();
        PVector d =  boundary[(int)chain[2].x][(int)chain[2].y].direction.copy();
        d.mult(10);
        //d.rotate(PI/2);
        cnt2 = 0;
        fill(255);
        stroke(255);
        line(p.x, p.y, p.x + d.x, p.y + d.y);
      }

      cnt++;
      cnt2++;
    } while ( (!((runningPoint.y == startpoint.y) && (runningPoint.x == startpoint.x))));

    println(cnt);
    println(runningPoint);
    println("ENDE");
  }
}