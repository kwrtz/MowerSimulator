// A Cell object
class Cell {
  // A cell object knows about its location in the grid 
  // as well as its direction
  // only perimeter pixels have a direction
  PVector position;
  PVector direction;
   
  //3=obstacle red detected
  //2=border black detected
  //1=inner boarder pixes detected an directon calculated. Used for calculate the impact angle and reflect angle
  int border;
  // Cell Constructor
  Cell(float tempX, float tempY) {
    position = new PVector(tempX, tempY);
    border = 0;
  } 

  void display() {
    
    if (border == 2 && flagShowFoundBlackBorder == true ) { // 2 means print found black boarder
      stroke(0, 154, 205);
      point(position.x, position.y);
    }
    
    if (border == 3 && flagShowFoundRedObstacles == true ) { // 3 means print found red boarder
      stroke(0, 154, 205);
      point(position.x, position.y);
    }
    
     if (border == 1 ) { // 1 means found perimeter
      stroke(255, 0, 0);
      point(position.x, position.y);
    }

    //print(position.x);
    //println(position.y);
  }
}