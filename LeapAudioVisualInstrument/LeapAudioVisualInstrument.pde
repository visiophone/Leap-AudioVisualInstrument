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
  "C1", "C#1", "D1", "D#1", "E1", "F1", "F#1", "G1", "G#1", "A1", "A#1", "B1", 
  "C2", "C#2", "D2", "D#2", "E2", "F2", "F#2", "G2", "G#2", "A2", "A#2", "B2", 
  "C3", "C#3", "D3", "D#3", "E3", "F3", "F#3", "G3", "G#3", "A3", "A#3", "B3", 
  "C4", "C#4", "D4", "D#4", "E4", "F4", "F#4", "G4", "G#4", "A4", "A#4", "B4", 
  "C5", "C#5", "D5", "D#5", "E5", "F5", "F#5", "G5", "G#5", "A5", "A#5", "B5", 
  "C6", "C#6", "D6", "D#6", "E6", "F6", "F#6", "G6", "G#6", "A6", "A#6", "B6",
};


// leap lib
import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.ScreenTapGesture;
import com.leapmotion.leap.Gesture.State;
import com.leapmotion.leap.SwipeGesture;
import com.leapmotion.leap.CircleGesture;
import com.leapmotion.leap.Gesture.Type;

//leap iniciate
LeapMotionP5 leap;

//sound iniciate
Minim minim;
AudioOutput out;
Oscil  wave;

AudioOutput out1;

AudioOutput out2;
Oscil       wave1;
Oscil       wave2;
Oscil      modul1;
Oscil      modul2;


//image for the welcome screen
PImage menuPic, menuPic1, menuPic2, menuPic3, help1, help2, help3;



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
String[] instrName = {
  "TANGO ACCORDION", "ELECTRIC BASS", " CONTRABASS", "STRING ENSEMBLE", "TUBA", "TENOR SAX", "CLARINET", "PICCOLO PIPE", "SAWTOOTH SYNTH", 
  "CHIFF SYNTH", "NEW AGE SYNTH PAD", "POLY SYNTH SYNTH PAD", "BOWED SYNTH PAD", "METALLIC SYNTH PAD", "KOTO", "GUITAR FRET NOISE", "HELICOPTER FX"
};
int [] instrSelect = {
  23, 25, 43, 49, 58, 66, 71, 72, 81, 83, 88, 90, 92, 93, 107, 120, 125
};

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
float handsZZ [] = new float [5];

//finger Pos
float [] fingerXX = new float [30];
float [] fingerYY = new float [30];
float [] fingerZZ = new float [30];

// go to fullscreen
boolean sketchFullScreen() {
  return false;
}


SineWave sine;

// counter to check if hands are still during an X amount of time
int stillHands =0; 
// var to compare of the current handsYY.to check that the hands are not moving. so you dont trigger the menu in the middle of a performance
float handsYYprev=0;
boolean help=false;

void setup () {
  // size (1200,750);
 // println(instrSelect.length+" "+instrName.length);
  size (displayWidth, displayHeight);

  mode1= new mode01();
  mode2= new mode02();
  mode3= new mode03();

  //image for the menu screen
  menuPic = loadImage("menu_Screen.png");
  menuPic1 = loadImage("menu_Screen_1.png");
  menuPic2 = loadImage("menu_Screen_2.png");
  menuPic3 = loadImage("menu_Screen_3.png");
  help1 =   loadImage("help1.png");
   help2 =   loadImage("help2.png");
    help3 =   loadImage("help3.png");

  background (240);

  //SOUNDSTUFF
  minim = new Minim(this);
  out = minim.getLineOut(Minim.MONO, 2048); 
  //saida do mode1
  out2 = minim.getLineOut();
  // pause time when adding a bunch of notes at once
  //iniciate oscilator
  modul1 = new Oscil (220,0.1,Waves.TRIANGLE);
  modul2 = new Oscil (220,0.1,Waves.TRIANGLE);
  wave1 = new Oscil( 220, 0.1f, Waves.SINE );
  wave1.patch( out2 );
  //iniciate oscilator
  wave2 = new Oscil( 220, 0.1f, Waves.SINE );
 modul1.patch(wave1);
  modul2.patch(wave2);
  wave2.patch( out2 );
  


  /////////////////////////////////////////////// 
  out2.mute();

  leap = new LeapMotionP5(this);
  leap.enableGesture(Type.TYPE_SCREEN_TAP);

  m0=true;
  //noCursor();
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
    channels[0].programChange( 115 );
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

  // GEETING FINGERS
  for (Finger finger : leap.getFingerList()) {
    PVector fingerPos = leap.getTip(finger);
    strokeWeight(1);

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
    float handZ = leap.transformLeapToScreenY(hand.palmPosition().get(2));

    handsXX [countH] += (handX-handsXX [countH])*0.2;
    handsYY [countH] += (handY-handsYY [countH])*0.2;
    handsZZ [countH] += (handZ-handsZZ [countH])*0.2;
    countH++;
  } 

  ;


  ///////////////////////////////////////////////////////////////////////////////////////

  // MENU
  if (m0==true) {
    background(240);
    imageMode(CENTER);
    if (select1==false && select2==false && select3==false) image(menuPic, width/2, height/2);
    //menu screen for each instrument
    if (select1==true) image(menuPic1, width/2, height/2);
    if (select2==true) image(menuPic2, width/2, height/2);
    if (select3==true) image(menuPic3, width/2, height/2);


    //menu select 1    
    if (pointer.x<width/3-10 ) {

      stroke(0);
      fill(0);
      ellipse(pointer.x, pointer.y, 20, 20);
      line(pointer.x, pointer.y, width/3-120, height/2);
      ellipse( width/3-120, height/2, 10, 10);
      noStroke();
      // fill(240,150);
      //  rect(0,0, width/3,height);

      if (tap && select1==false) {
        note( 0, 1, 0, "C5", 0.8 );
        select1=true;
        select2=false;
        select3=false;
        tap=false;
      }

      if (tap && select1) {

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
      ellipse(pointer.x, pointer.y, 20, 20);
      line(pointer.x, pointer.y, width/2, height/2);
      ellipse( width/2, height/2, 10, 10);

      noStroke();
      // fill(240,150);
      //  rect(0,0, width/3,height);

      if (tap && select2==false) {
        note( 0, 1, 0, "D5", 0.8 );
        select1=false;
        select2=true;
        select3=false;
        tap=false;
      }

      if (tap && select2) {
        m2=true;
        m3=false;
        m1=false;
        m0=false;
        tap=false; 

        stroke(5);
        strokeCap(SQUARE);
        noFill();
        colorMode(RGB, 255);
      }
    }


    if ( pointer.x>(width/3*2)-10 ) {

      stroke(0);
      fill(0);
      ellipse(pointer.x, pointer.y, 20, 20);
      line(pointer.x, pointer.y, (width/3*2)+120, height/2);
      ellipse( (width/3*2)+120, height/2, 10, 10);

      noStroke();
      // fill(240,150);
      //  rect(0,0, width/3,height);

      if (tap && select3==false) {
        note( 0, 1, 0, "A5", 0.8 );
        select1=false;
        select2=false;
        select3=true;
        tap=false;
      }

      if (tap && select3) {
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
  if (m1==true && !help) {
    out.setTempo( 120 );
    stroke(5);
    strokeCap(SQUARE);
    noFill();
    mode1.display();
    out2.mute();

    // INFO AND MENUS ON SCREEN.
    fill(0);
    text("Instrument "+instrName[instrChange], 30, 30);
  }

  // 2 scene 
  if (m2==true && !help) {
    //use the mouse
    //mode2.display(mouseY);
    //using leap
    mode2.display(pointer.y);
    out2.mute();
  }

  // 3 scene 
  if (m3==true && !help) {
   
    tap=false;
    mode3.display();
    out2.unmute();
  }
/////////////////////////////////////////////////////////////////////
 // Gesture TO GO BACK to MENU  . 
 //If there are two hands, no fingers, no mainMeno, wait 60fs and HELP=True
 if(countH==2 && countF==0 && !m0 && !help && abs(handsYYprev-handsYY[0])<2){
  stillHands++;
  //println( stillHands);
  fill(255);
  rect(0,0,map(stillHands, 0,50,0,width),10);
 }
 else stillHands=0;
 
 if(stillHands>=50 && !m0) {
   help=true;
   tap=false;
 }
 // go to HELP menu
 if(help && !m0) {
out2.mute();   
  noStroke();
  fill(0,170);
  rect(0,0,width,height); 
// if finger in the left side, tap to go back to main menu   
   if ( pointer.x<(width/2) ) {
   strokeWeight(1);
   stroke(255);
   fill(255);
   line(pointer.x,pointer.y, width/2-462,height/2-329);
   ellipse(pointer.x,pointer.y,10,10);
   noFill();
   strokeWeight(3);
   ellipse(width/2-465,height/2-336,120,120);
   
   //Go back to Menu
   if(tap) {
     tap=false;
   m0=true; 
   help=false;
   m1=false;
   m2=false;
   m3=false;
   select1=false;
   select2=false;
   select3=false;
   colorMode(RGB, 255);
   out2.mute();
 }
 }
 // if finger in right side, tap to go back and play
   if ( pointer.x>(width/2) ) {
   strokeWeight(1);
   stroke(255);
   fill(255);
   line(pointer.x,pointer.y, width/2+462,height/2-329);
   ellipse(pointer.x,pointer.y,10,10);
    noFill();
   strokeWeight(3);
   ellipse(width/2+465,height/2-336,120,120);
   
   if(tap) {help=false;}
   
 }
  if(m1)image(help1, width/2, height/2); 
 if(m2)image(help2, width/2, height/2);
 if(m3)image(help3, width/2, height/2); 
 }
 
 
 
////////////////////////////////////////////////////
// reseting the counting of nr of fingers and hands  
  countH=0;
  countF=0; 

  handsYYprev=handsYY[0];
}

//END OF MAIN LOOP
////////////////////////////////////////////////////////////////////////


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
    colorMode(RGB, 255);
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

    println("MENU");
    colorMode(RGB, 255);
    out2.mute();
  }  
}

//LISTENING TO LEAP SCREEN TAP
public void screenTapGestureRecognized(ScreenTapGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    tap=true;
    
    if (m1 && gesture.position().get(2)<-200 && countF<5){
      
      instrChange = int(random(0, 16));
      channels[1].programChange( instrSelect[instrChange] );
     // println("Position: " + gesture.position());
     
    }
    
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
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

/*
void mouseMoved()
{
  float modulateAmount = map( mouseY, 0, height, 0, 1 );
  float modulateFrequency = map( mouseX, 0, width, 0.0, 20 );
 // println(modulateFrequency +" "+modulateAmount);
  modul1.frequency.setLastValue( modulateFrequency );
 modul1.amplitude.setLastValue( modulateAmount );
}
*/

