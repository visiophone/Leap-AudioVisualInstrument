//sound lib
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;

// leap lib
import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.ScreenTapGesture;
import com.leapmotion.leap.Gesture.State;
import com.leapmotion.leap.Gesture.Type;

//sound iniciate
Minim minim;
AudioOutput out;
Oscil  wave;

AudioOutput out1;

AudioOutput out2;
Oscil       wave1;
Oscil       wave2;

//image for the welcome screen
PImage menuPic;

//leap iniciate
LeapMotionP5 leap;

//BOOLEAN FOR SCREEN TAPINT
boolean tap=false;

// PVector for one finger
PVector pointer = new PVector(0, 0);

// boolean to control de diferent scenes
boolean m0, m1, m2, m3;

// diferent visual Modes
mode01 mode1;
mode02 mode2;
mode03 mode3;


int h;
int w;

//LEAP STUFF
// keep track of the number of Hands
int countH=0;
// keep track of the number of Fingers
int countF=0;

// hand positions
// there are 5 hand, because sometime the number os hands con crazy. to avoid Null Array stuf
float handsXX [] = new float [5];
float handsYY [] = new float [5];

//finger Pos
float [] fingerXX = new float [30];
float [] fingerYY = new float [30];


boolean sketchFullScreen() {
 return true;
 }
 

SineWave sine;


void setup () {
  // size (1200,750);

  size (displayWidth, displayHeight);

  mode1= new mode01();
  mode2= new mode02();
  mode3= new mode03();

//image for the menu screen
 menuPic= loadImage("menu_Screen.png");

  background (240);

  //SOUNDSTUFF
  minim = new Minim(this);
  out = minim.getLineOut(Minim.MONO, 2048); 
  //saida do mode1
  out2 = minim.getLineOut();
  // pause time when adding a bunch of notes at once

  //iniciate oscilator
  wave1 = new Oscil( 200, 0.1f, Waves.SINE );
  wave1.patch( out2 );
  //iniciate oscilator
  wave2 = new Oscil( 200, 0.1f, Waves.SINE );
  wave2.patch( out2 );


  /////////////////////////////////////////////// 
  out2.mute();



  leap = new LeapMotionP5(this);
  leap.enableGesture(Type.TYPE_SCREEN_TAP);

  m0=true;


   noCursor();

  strokeCap(SQUARE);
  frameRate(50);
}


void draw () {
  background(240);


  // leapStuff 
  // GEETING FINGERS
  for (Finger finger : leap.getFingerList()) {
    PVector fingerPos = leap.getTip(finger);
    strokeWeight(1);

    // ellipse(fingerPos.x, fingerPos.y,20, 20);
    // println(finger.id());
    // pointer = fingerPos.get();

    pointer.x += (fingerPos.x-pointer.x)*0.3;
    pointer.y += (fingerPos.y-pointer.y)*0.3;


    fingerXX[finger.id()]=fingerPos.x;
    fingerYY[finger.id()]=fingerPos.y;
    countF++;
  }

  // GEETTING HANDS  
  for (Hand hand : leap.getHandList()) {

    // Transform Leap coordinates in display coordinates
    float handX = leap.transformLeapToScreenX(hand.palmPosition().get(0));
    float handY = leap.transformLeapToScreenY(hand.palmPosition().get(1));

    handsXX [countH] += (handX-handsXX [countH])*0.2;
    handsYY [countH] += (handY-handsYY [countH])*0.2;
    countH++;
  } 

  ;

 // ellipse(pointer.x, pointer.y, 30, 30);
  //println(pointer.x);



  // menu
  if (m0==true) {
    background(240);
    imageMode(CENTER);
    image(menuPic, width/2, height/2);
 
 //menu select 1   
 
     if (pointer.x<width/3-10 ) {
    
    stroke(0);
    fill(0);
    ellipse(pointer.x, pointer.y, 20,20);
   line(pointer.x, pointer.y, width/3-120, height/2);
    ellipse( width/3-120, height/2 ,10,10);
     noStroke();
   // fill(240,150);
  //  rect(0,0, width/3,height);
    
   
   if(tap){
    m2=true;
     m1=false;
    m3=false;
    m0=false;
   tap=false; 
   }
      
    }
    
    
     if (pointer.x>width/3-10 && pointer.x<(width/3*2)-10 ) {
    
    stroke(0);
    fill(0);
    ellipse(pointer.x, pointer.y, 20,20);
   line(pointer.x, pointer.y, width/2, height/2);
     ellipse( width/2, height/2, 10,10);
  
     noStroke();
   // fill(240,150);
  //  rect(0,0, width/3,height);
    
   
   if(tap){
    m1=true;
     m3=false;
    m2=false;
    m0=false;
   tap=false; 
   
     stroke(5);
  strokeCap(SQUARE);
  noFill();
  colorMode(RGB,255);
   
   }
      
    }
    
    
         if ( pointer.x>(width/3*2)-10 ) {
    
    stroke(0);
    fill(0);
    ellipse(pointer.x, pointer.y, 20,20);
   line(pointer.x, pointer.y, (width/3*2)+120, height/2);
    ellipse( (width/3*2)+120, height/2, 10,10);
  
     noStroke();
   // fill(240,150);
  //  rect(0,0, width/3,height);
    
   
   if(tap){
    m3=true;
    m1=false;
    m2=false;
    m0=false;
   tap=false; 
   }
      
    }
    
    
    
  }


////////////////////////////////////////////////////////



  // 2 scene 
  if (m1==true) {
    
     stroke(5);
    strokeCap(SQUARE);
    noFill();
    mode1.display();
    out2.mute();
  }


  // 2 scene 
  if (m2==true) {
    //use the mouse
    //mode2.display(mouseY);
    //using leap
    mode2.display(pointer.y);
    out2.mute();
  }



  // 2 scene 
  if (m3==true) {
    tap=false;
    mode3.display();
    out2.unmute();
  }

  // reseting the counting of fingers and hands  
  //println(countH);
  countH=0;
  countF=0;
}



void keyReleased() {
  if (key == '1') { 
    m2=false;
    m1=true;
    m0=false;
    m3=false;
    println("mode1");
  
  stroke(5);
  strokeCap(SQUARE);
  noFill();
  colorMode(RGB,255);
}

  if (key == '2') { 
    m2=true;
    m1=false;
    m0=false;
    m3=false;
    println("mode2");
  }

  if (key == '3') { 
    m3=true;
    m1=false;
    m0=false;
    m2=false;
    println("mode3");
  }
  if (key == '0') { 
    m0=true;
    m1=false;
    m2=false;
    m3=false;
    println("mode4");
  }
  
    if (key == 'm' || key == 'M' ) { 
    m0=true;
    m1=false;
    m2=false;
    m3=false;
    println("mode4");
    colorMode(RGB,255);
    out2.mute();
  }
}





//LISTENING TO LEAP SCREEN TAP
public void screenTapGestureRecognized(ScreenTapGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    tap=true;
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
}




// always close Minim audio classes when you are done with them
void stop()
{
  // always close Minim audio classes when you are done with them
  out.close();
  out2.close();
  // always stop Minim before exiting.
  minim.stop();
  super.stop();
  //closing dow leap
  leap.stop();
}

