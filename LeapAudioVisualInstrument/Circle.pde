class Circle {
  //bool to check if the weel is selected
  boolean sel=false;
  
  //colours for the shape;
  int colorFreq=0;
  int fillColor=0;
  
  //line to to guide the finger position and help to control
  float yLine=0;
  float prevYline=0;
  
  float x;
  float y;
  
  int nr=36;
  
// arrays with all the angles
float [] alpha =new float [nr];

// arrays with the positions of the lines
float [] xx1 =new float [nr];
float [] xx2 =new float [nr];
float [] yy1 =new float [nr];
float [] yy2 =new float [nr];

// array with the radium
float [] r1 =new float [nr];
float [] r2 =new float [nr];

// radium after intereaction
float[] newR = new float [nr];

float speed = 0.02;
  
  
  //contructor
  Circle(float xx, float yy) {
    x=xx;
    y=yy;
    
      // inicialize stuff
  for (int i=0;i<nr;i++){
   
   alpha[i]=i*((PI*2)/nr);
   r1[i]=30;
   r2[i]=45;
   newR[i]=45;
   
   xx1[i] = r1[i]*cos(alpha[i]);
  yy1[i] = r1[i]*sin(alpha[i]);
  xx2[i] = r2[i]*cos(alpha[i]);
  yy2[i] = r2[i]*sin(alpha[i]);
   
line(xx1[i],yy1[i],xx2[i],yy2[i])   ; 
  }
  
  }
  
 
 // function , receives select to know if the circle is active or not, and a value to multiply the frequencies, and the input Y + instrument number
  void display (boolean select, float freq, float inputY, int instSelec){
  
    sel=select;
   // println(sel);
   // background(200);
 
 // translate to 0,0
  pushMatrix();
  translate(x, y);
  
strokeWeight(1);
stroke(0);

line (0,0,0,-175);
noFill();

//central circles
ellipse(0,0,350,350);
ellipse(0,0,100,100);
for (int i=125;i<350;i=i+25) {
  stroke(150);
 ellipse(0,0,i ,i);
 }
 

//draw shape
 colorMode(HSB, 360,100,100);
 beginShape();
strokeWeight(1); 
fillColor+=(((freq/100)+180+colorFreq/10)-fillColor)*0.9;
fill(fillColor,100,100,100);
stroke(0);
for(int i=0; i<nr;i++){
 vertex(xx2[i],yy2[i]);  
}

endShape(CLOSE);
colorMode(RGB, 255);

//Moving it, and playing it

for (int i=0;i<nr;i++){
  
   alpha[i]-=speed;

// from polar to cardeais  
xx1[i] = r1[i]*cos(alpha[i]);
yy1[i] = r1[i]*sin(alpha[i]);
xx2[i] = r2[i]*cos(alpha[i]);
yy2[i] = r2[i]*sin(alpha[i]);


// check the 0 bar. (vertical top)
 if((abs(-(PI/2)-alpha[i]))<0.01 ){

  stroke(2550, 40,10);
  
 
 // if cirle is selected, calculates the High og the mouse/selector and redraws the graph; 
  if(select==true) {
  if(i==nr-1) { 
      
  newR [0]= map(inputY,0,300, 175,45);
  newR[0]=constrain(newR[0], 45,175);
  yLine=newR[0];
  } 
  if(i<nr-1) {
     newR [i+1]= map(inputY,0,300, 175,45);
  newR[i+1]=constrain(newR[i+1], 45,175);
    yLine=newR[i+1];
  } 
}


// if the line draw is up, play that note play note
if(r2[i]>50){
//out.playNote( freq+(r2[i]*2) );
 int mapNote= int(map(r2[i], 50, 175, 0,11));
// PLAY MIDI NOTE
//TIME, / DURATION / CHANNEL / NOTENAME, VELOCITY);
 channels[2].programChange( instrSelect[instSelec] );
note( 0, 1,2, noteName[mapNote], 0.8 );

println(r2[i]);
colorFreq=int(freq+(r2[i]*2));
}
}

else stroke(0);

r2[i]+=(newR[i]-r2[i])*0.4;



 
 // bar
strokeWeight(4); 

//line(-10,r2[i],10,r2[i]);

line(xx1[i],yy1[i],xx2[i],yy2[i]); 

// reset angle
if(alpha[i]<-(2*PI))alpha[i]=0;
  
}


 
// guide line to help the gestures
strokeWeight(2);

if(select==true){
 stroke(245,100,10,200);
}
else { stroke(245,100,10,50); };


noStroke();
ellipse(0,-prevYline,20,20);


//stroke(20,20,245,100);
//fill(20,20,245,100);
noFill();
prevYline+=(yLine-prevYline)*0.5;

//line(-175,-prevYline,175,-prevYline); 
//line(-175, -prevYline,-175,0);
//ellipse(-175,-yLine, 15,15);
//ellipse(175,-yLine, 15,15);
 

  // central circle
    noStroke();
   
    
  fill(0);

ellipse(0,0,60,60);
 fill(200);
ellipse(0,0,50,50);
    
    popMatrix();
  }
  
  
  void helpLine(){
   pushMatrix();
  translate(x, y);
  strokeWeight(1);
  stroke(140);
   line(0,-prevYline, pointer.x-x,pointer.y-y); 
    popMatrix();
  }
  
  
}
