//sound lib
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;

// this package is where we get our Synthesizer from
import javax.sound.midi.*;
// what we need from JavaSound for sound making.
Synthesizer   synth;
// the MidiChannels of the synth.
MidiChannel[] channels;

// Notes are called by name, this arrya stores them
String[] noteName = {
                    "C1", "C#1", "D1","D#1","E1","F1","F#1","G1","G#1","A1","A#1","B1",
                     "C2", "C#2", "D2","D#2","E2","F2","F#2","G2","G#2","A2","A#2","B2",
                     "C3", "C#3", "D3","D#3","E3","F3","F#3","G3","G#3","A3","A#3","B3",
                      "C4", "C#4", "D4","D#4","E4","F4","F#4","G4","G#4","A4","A#4","B4",
                      "C5", "C#5", "D5","D#5","E5","F5","F#5","G5","G#5","A5","A#5","B5",
                        "C6", "C#6", "D6","D#6","E6","F6","F#6","G6","G#6","A6","A#6","B6",
                      };

//leap iniciate
LeapMotionP5 leap;
// leap lib
import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.ScreenTapGesture;
import com.leapmotion.leap.Gesture.State;
import com.leapmotion.leap.SwipeGesture;
import com.leapmotion.leap.CircleGesture;
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
PImage menuPic, menuPic1, menuPic2, menuPic3;



//BOOLEAN FOR SCREEN TAPINT
boolean tap=false;
//bolean for selecting the instrument
boolean select1 = false;
boolean select2 = false;
boolean select3 = false;

// PVector for one finger
PVector pointer = new PVector(0, 0);

// boolean to control de diferent scenes
boolean m0, m1, m2, m3;

// diferent visual Modes
mode01 mode1;
mode02 mode2;
mode03 mode3;


// ARRAY WITH THE SELECT MIDI INSTRUMENTS
String[] instrName = {"TANGO ACCORDION", "ELECTRIC BASS" ," CONTRABASS", "STRING ENSEMBLE","TUBA", "TENOR SAX", "CLARINET", "PICCOLO PIPE", "SAWTOOTH SYNTH", 
                      "CHIFF SYNTH", "NEW AGE SYNTH PAD", "POLY SYNTH SYNTH PAD","BOWED SYNTH PAD", "METALLIC SYNTH PAD", "KOTO", "GUITAR FRET NOISE","HELICOPTER FX"   };
int [] instrSelect = {23, 25, 43, 49,58, 66, 71, 72, 81, 83, 88, 90, 92, 93, 107, 120, 125 };

//var that olds de instrument name/id
int instrChange=1;


//screen dim
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
 return false;
 }
 

SineWave sine;


void setup () {
  // size (1200,750);
println(instrSelect.length+" "+instrName.length);
  size (displayWidth, displayHeight);

  mode1= new mode01();
  mode2= new mode02();
  mode3= new mode03();

//image for the menu screen
 menuPic = loadImage("menu_Screen.png");
 menuPic1 = loadImage("menu_Screen_1.png");
 menuPic2 = loadImage("menu_Screen_2.png");
 menuPic3 = loadImage("menu_Screen_3.png");

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
  leap.enableGesture(Type.TYPE_SWIPE);
   leap.enableGesture(Type.TYPE_CIRCLE);

  m0=true;


   noCursor();

  strokeCap(SQUARE);
  frameRate(50);
  
  
  ///////////////////////
  // INICIATE MIDI SYNTH
     try
  {
    synth = MidiSystem.getSynthesizer();
    synth.open();
    // get all the channels for the synth
    channels = synth.getChannels();
    // CHANNEL ZERO IS FOR THE MENUS SOUNDS
    channels[0].programChange( 5 );
    // CHANNEL ONE IS FOR MODE1 INSTRUMENTS
    channels[1].programChange( instrChange ); 
    // CHANNEL TWO IS FOR MODE1 INSTRUMENTS 1
    channels[2].programChange( 5 ); 
    // CHANNEL TWO IS FOR MODE1 INSTRUMENTS 1
    channels[3].programChange( 10 ); 
    // CHANNEL TWO IS FOR MODE1 INSTRUMENTS 1
    channels[4].programChange( 15 ); 
    
   

  
   }
  catch( MidiUnavailableException ex )
  {
    // oops there wasn't one.
    println( "No default synthesizer." );
  } 
  //////////////////////
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


///////////////////////////////////////////////////////////////////////////////////////

  // mMENU
  if (m0==true) {
    background(240);
    imageMode(CENTER);
   if(select1==false && select2==false && select3==false) image(menuPic, width/2, height/2);
  //menu screen for each instrument
    if(select1==true) image(menuPic1, width/2, height/2);
    if(select2==true) image(menuPic2, width/2, height/2);
     if(select3==true) image(menuPic3, width/2, height/2);
   
   
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
  
  if(tap && select1==false){
    note( 0, 1,0,"C5" , 0.8 );
    select1=true;
    select2=false;
    select3=false;
    tap=false;
    
  }
   
   if(tap && select1){
       
    m1=true;
     m2=false;
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
    
      if(tap && select2==false){
        note( 0, 1,0,"D5" , 0.8 );
    select1=false;
    select2=true;
    select3=false;
    tap=false;
    
  }
   
   if(tap && select2){
    m2=true;
     m3=false;
    m1=false;
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
    
     if(tap && select3==false){
       note( 0, 1,0,"A5" , 0.8 );
    select1=false;
    select2=false;
    select3=true;
    tap=false;
    
  }
   
   if(tap && select3){
    m3=true;
    m1=false;
    m2=false;
    m0=false;
   tap=false; 
   }
      
    }
    
    
    
  }


////////////////////////////////////////////////////////



  // 1 scene 
  if (m1==true) {
      out.setTempo( 120 );
     stroke(5);
    strokeCap(SQUARE);
    noFill();
    mode1.display();
    out2.mute();
    
    // INFO AND MENUS ON SCREEN.
    text("Instrument "+instrName[instrChange], 30, 30);
    
  }


  // 2 scene 
  if (m2==true) {
    //use the mouse
    //mode2.display(mouseY);
    //using leap
    mode2.display(pointer.y);
    out2.mute();
  }



  // 3 scene 
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
    
    select1=false;
    select2=false;
    select3=false;
    
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


public void swipeGestureRecognized(SwipeGesture gesture) {
 
  if (gesture.state() == State.STATE_STOP) {
    //GESTURE IN INST-1 IF THERE IS ONLY ONE HAND, AND AN HORIZONTAL SWIPE ->> CHANGE INSTRUMENT
  if(countH==1 && m1 && gesture.direction().get(1)<0.5 && gesture.direction().get(1)>-0.5){
    instrChange = int(random(0,16));
    channels[1].programChange( instrSelect[instrChange] );
   println("swipe "+ gesture.duration());
    
   
    
  }
   }
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  
  }
  
}

public void circleGestureRecognized(CircleGesture gesture, String clockwiseness) {
 /*
  if (gesture.state() == State.STATE_STOP) {
  if(m1 && gesture.durationSeconds()>0.6){
    int instrument = int(random(1,127));
    channels[1].programChange( instrument );
   // println("intrs "+instrument+" // circle duration "+gesture.durationSeconds());
    
  }
  } 
 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
   */
}



//function to make noite with MIDISynth
// just a little helper function to reduce how much typing is required
// for the sequence code below.
void note( float time, float duration, int channelIndex, String noteName, float velocity )
{
  out.playNote( time, duration, new MidiSynth( channelIndex, noteName, velocity ) );
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

