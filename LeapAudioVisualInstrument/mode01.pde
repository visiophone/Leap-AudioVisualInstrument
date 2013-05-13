class mode01 {
  
  float xx;
  float yy;
  
  //nr of lines
int nr=100;

//lines spectrum Pos
float [] linesXX = new float [nr];
float [] linesYY = new float [nr];

int nrNotes=0;

//finger prevPos
float [] preFingerXX = new float [30];
float [] preFingerYY = new float [30];

// For some reason I get strange and high fingers's ID numbers.  
// For that reason  the fingers array has 30 pos. to avoid "array out of limite" errors

// time between notes
int timeN=0;

// time count to change instrument
int changeCount=0;
boolean change=false;
  
  mode01() {
  stroke(5);
  strokeCap(SQUARE);
  noFill();
  
   //iniciate vars that containt lines
   for(int i=0;i<nr;i++) {
     linesXX[i]=i*(width/nr+1);
     linesYY[i]=height-5;
   }
  }
  
  
  void display (){
    background(240);
   timeN++;
    //checking if fingers still active /moving. if not, return to zero
   for(int id=0;id<30;id++){  
     
     
  if (abs(preFingerYY[id]-fingerYY[id])>3 || abs(preFingerXX[id]-fingerXX[id])>2 ){
     
    fingerYY[id]+=((height-5)-fingerYY[id])*0.02;  
    
// manage note durations, if heavy activity notes are faster, if slow activity notes are longer.
  float dur=0.0;
  if (timeN>20) dur=2;
  if (timeN>10) dur=1;
  if (timeN<1) dur=0.2;
  if (timeN>=1 && timeN<=10) dur=map(timeN, 1, 10, 0.8, 1);

// MAPPING FINGERS POS-Y WITH THE PITCH
  int mapNote= int(map(fingerYY[id], height, 0, 0,71));
  mapNote=constrain(mapNote,0,71);
// PLAY MIDI NOTE
//TIME, / DURATION / CHANNEL / NOTENAME, VELOCITY);
note( 0, dur,1, noteName[mapNote], 0.8 );
  } 

  fingerYY[id]+=((height-5)-fingerYY[id])*0.02;  

    timeN=0; 
      preFingerXX[id]=fingerXX[id];
      preFingerYY[id]=fingerYY[id];
   }
    // drawing lines spectrum
 strokeWeight(10);
  for(int i=0;i<nr;i++) {  
    for(int id=0;id<30;id++){
        
  //if finger is near a line, give the finger YY to the line   
     if(abs(fingerXX[id]-linesXX[i])<5) linesYY[i]=fingerYY[id];
        line(linesXX[i],height, linesXX[i],linesYY[i]);        
    }  
   // reseting all lines to the botom of the screen
   linesYY[i]+=((height-5)-linesYY[i])*0.02;
  }  
nrNotes =0;

////////
// If no hands on screen for some seconds change instrument

if(countH==1 || countF==0  && !change ) {
 
  changeCount++;
  
  
 // println(changeCount);
  if(changeCount>=30){
    
     instrChange = int(random(0, 16));
      channels[1].programChange( instrSelect[instrChange] );
      changeCount=0;
      change=true;
  }
  
}
if(countH!=0){
  changeCount=0;
  change=false;
}


  }
  
  
}
