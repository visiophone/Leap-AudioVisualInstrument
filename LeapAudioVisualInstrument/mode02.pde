class mode02 {

  float xx;
  float yy;

  Circle circle1;
  Circle circle2;
  Circle circle3;


  boolean selC1=false;
  boolean selC2=false;
  boolean selC3=false;
  int counter=1;

  mode02() {
    //draws the circles in the screen
    circle1= new Circle(width/5-30, height/2);
    circle2= new Circle(width/2, height/2);
    circle3= new Circle(width/5*4+30, height/2);
  }


  void display (float inputY) {
    background(240);

    //println(mouseX+" "+mouseY+" "+selC1);
    stroke(140);
    strokeWeight(1);
    ellipse(pointer.x, pointer.y, 20, 20);

    // select the  circle 1
// IF FINGER IS ON THE LEFT OF THE SCREEN

    if (pointer.x<width/3-10) {

      //line to help orientation. 
      if (selC1==false && selC2==false && selC3==false) {
        line(width/5-30, height/2, pointer.x, pointer.y);
      }
      //IF TAP SELECT OR DE-SELECT

      if (tap)
      {
        tap=false;  

        if (selC1==false && selC2==false && selC3==false) {

          selC1=true;
          selC2=false;
          selC3=false;
        }
        else selC1=false;
        
        //ALSO DESELECT THE OTHER CIRCLES FROM THE OTHERS SCFREEN REGIONS
        if (selC2==true || selC3==true) {
          selC3=false;
          selC2=false;
        }
      }
    } 

    // select cricle 2 
  // IF FINGER IS ON THE MIDDLE OF THE SCREEN
  
    if (pointer.x>=width/3+10 && pointer.x<=(width/3)*2-10 ) {
if (selC1==false && selC2==false && selC3==false) {
        line(width/2, height/2, pointer.x, pointer.y);
}
      //IF TAP SELECT OR DE-SELECT

      if (tap)
      {
        tap=false;  
        if (selC1==false && selC2==false && selC3==false) {
          selC2=true;
          selC1=false;
          selC3=false;
        }
        else selC2=false;
        
        //ALSO DESELECT THE OTHER CIRCLES FROM THE OTHERS SCFREEN REGIONS
        if (selC3==true || selC1==true) {
          selC3=false;
          selC1=false;
        }
      }
    } 

// IF FINGER IS ON THE RIGTH OF THE SCREEN
    if ( pointer.x>(width/3)*2+10 ) {
if (selC1==false && selC2==false && selC3==false) {
        line(width/5*4+30, height/2, pointer.x, pointer.y);
} 
      
      //IF TAP SELECT OR DE-SELECT
      if (tap)
      {
        tap=false;  

//SELECT THE CIRCLE AND DESELECT THE OTHERS
        if (selC1==false && selC2==false && selC3==false) {
          selC3=true;
          selC1=false;
          selC2=false;
        }
        
        // IS IS SELECTED , DESELECT
        else selC3=false;
        
//ALSO DESELECT THE OTHER CIRCLES FROM THE OTHERS SCFREEN REGIONS
        if (selC2==true || selC1==true) {
          selC1=false;
          selC2=false;
        }
      }

    }    


    if (selC1) {

       line(width/5-30, height/2, pointer.x, pointer.y);
      fill(5, 20);
      noStroke();
      ellipse (width/5-30, height/2, 350, 350);
      strokeWeight(4);
      stroke(84,140,231);
      noFill();
      ellipse (width/5-30, height/2, 400, 400);
       circle1.helpLine();
    }


    if (selC2) {
       line(width/2, height/2, pointer.x, pointer.y);

      fill(5, 20);
      noStroke();
      ellipse (width/2, height/2, 350, 350);
      strokeWeight(4);
      stroke(110,86,206);
      noFill();
      ellipse (width/2, height/2, 400, 400);
       circle2.helpLine();
    }

    if (selC3) {
       
      line(width/5*4+30, height/2, pointer.x, pointer.y);

      fill(5, 20);
      noStroke();
      ellipse (width/5*4+30, height/2, 350, 350);
      strokeWeight(4);
      stroke(230,19,220);
      noFill();
      ellipse (width/5*4+30, height/2, 400, 400);
      circle3.helpLine();
    }

    ///////////////////////////////////////

    // calls the circle funcion
    circle1.display(selC1, 100, inputY, 2);
    circle2.display(selC2, 500, inputY, 3);
    circle3.display(selC3, 800, inputY, 4);

  }
}

