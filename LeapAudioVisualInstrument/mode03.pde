class mode03 {

  //Number of Bars
  int nrBars = 20;


  // vars for the right side bars
  ////////////////////////////////////////////

  // array that collects the width of the bar
  float [] barSize = new float [nrBars];
  float [] barSizePrev = new float [nrBars];

  // array that collect the y pos of each bar
  float [] barV = new float [nrBars];

  // array with the color of each bar
  int [] barColor = new int [nrBars];

  // base color
  float colorChange =180;

  // var to change freq
  float freqChange=0;

  ////////////////////////////////////////////////

  // vars for the left side bars
  ////////////////////////////////////////////

  // array that collects the width of the bar
  float [] barSize_ = new float [nrBars];
  float [] barSizePrev_ = new float [nrBars];

  // array that collect the y pos of each bar
  float [] barV_ = new float [nrBars];

  // array with the color of each bar
  int [] barColor_ = new int [nrBars];

  // base color
  float colorChange_ =180;

  // var to change freq
  float freqChange_=0;

  // if there are no hands on the screen, dont afect the bars
  boolean moveL=false;
  boolean moveR=false;


// vars for the zz. using the depth to modulate sound
float modulate1=0.0;
float modulate2=0.0;

  ////////////////////////////////////////////////

  // vars that receive the hands position to interact with the scene


    PVector controlL, controlR;

  //////////////////////////////////////////////////

  mode03() {



    controlL = new PVector(0, 0);
    controlR = new PVector(0, 0);

    //iniciate arrays 
    for (int i=0;i<nrBars ;i++) {
      //rigth site
      barSize[i]=20;
      barSizePrev[i]=20;
      barV[i]=(width/nrBars)*i-20;
      barColor[i]=int(colorChange);

      //left side
      barSize_[i]=20;
      barSizePrev_[i]=20;
      barV_[i]=(width/nrBars)*i-20;
      barColor_[i]=int(colorChange_);
    }
  }


  void display () {

    noStroke();
    fill(10);

    //color mode to HSB
    colorMode(HSB, 360, 100, 100);
   background(0, 0, 90);
     
  noFill();
////////////////
  stroke( 0,0,100 );
  // draw the waveforms
  for(int j=1;j<1000;j=j+50){
  for( int i = 0; i < out2.bufferSize() - 1; i++ )
  {
    // find the x position of each buffer value
    float x1  =  map( i, 0, out2.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out2.bufferSize(), 0, width );
    // draw a line from one buffer position to the next for both channels
    line( x1, 50 + out2.left.get(i)*50 +j, x2, 50 + out2.left.get(i+1)*50+j);
    line( x1, 150 + out2.right.get(i)*50+j, x2, 150 + out2.right.get(i+1)*50+j);
  }  
  }

    ////////////////////////////////
    // Getting the hands

    //println(countH);
    if (countH>0) {
      //deciding if the hand affects left side or right side
      // if there is only one hand check if is in the left side or rifht side
      if (countH==1) { 

     // drawing helping lines for the hands
        stroke(0,0,40);
        noFill();
        //ellipse(handsXX[0], handsYY[0],20,20);
        line(handsXX[0],0,handsXX[0],height); 
        line(handsXX[0]-20,handsYY[0],handsXX[0]+20,handsYY[0]); 
        
       
        if (handsXX[0]>width/2+10) {
          controlR.x=handsXX[0];
          controlR.y=handsYY[0];
          
          //use the depth to modulate sound
          modulate1=map(handsZZ[0],800,1200,0.1,10);
          modulate1=constrain(modulate1,0.1,10);
         // println(modulate1);
     
     /*     
             // play with the deep. if there is modulation, make the lines shake a bit
        for(int i=0;i<5;i++){   
          line(handsXX[0]+random(-modulate1*2,  modulate1*2),0,handsXX[0]+random(-modulate1*2,  modulate1*2),height);
          line(handsXX[0]-20,handsYY[0]+random(-modulate1,  modulate1),handsXX[0]+20,handsYY[0]+random(-modulate1,  modulate1)); 
        }
        */
          
          moveL=false;
          moveR=true;
        }

        if (handsXX[0]<width/2-10) {
          controlL.x=handsXX[0];
          controlL.y=handsYY[0];
             //use the depth to modulate sound
           modulate2=map(handsZZ[0],700,1200,0.1,10);
          modulate2=constrain(modulate2,0.1,10);
          /*
              // play with the deep. if there is modulation, make the lines shake a bit
        for(int i=0;i<5;i++){   
          line(handsXX[0]+random(-modulate2*2,  modulate2*2),0,handsXX[0]+random(-modulate2*2,  modulate1*2),height);
          line(handsXX[0]-20,handsYY[0]+random(-modulate2,  modulate2),handsXX[0]+20,handsYY[0]+random(-modulate2,  modulate2)); 
        }
        */
          
          moveR=false;
          moveL=true;
        }
      }

      //if there are two hands check which one is on the right, and whcic one is on the left
      if (countH==2) {
        moveR=true;
        moveL=true;
        if  (handsXX[0]>handsXX[1]) {

          controlR.x=handsXX[0];
          controlR.y=handsYY[0];

          controlL.x=handsXX[1];
          controlL.y=handsYY[1];
          
          modulate1=map(handsZZ[0],700,1200,0.1,10);
          modulate1=constrain(modulate1,0.1,10);
          modulate2=map(handsZZ[1],700,1200,0.1,10);
          modulate2=constrain(modulate2,0.1,10);
        
        stroke(0,0,40);
        noFill();
        /*
         // play with the deep. if there is modulation, make the lines shake a bit
        for(int i=0;i<5;i++){   
          line(handsXX[0]+random(-modulate1*2,  modulate1*2),0,handsXX[0]+random(-modulate1*2,  modulate1*2),height);
          line(handsXX[0]-20,handsYY[0]+random(-modulate1,  modulate1),handsXX[0]+20,handsYY[0]+random(-modulate1,  modulate1)); 
          line(handsXX[1]+random(-modulate2*2,  modulate2*2),0,handsXX[1]+random(-modulate2*2,  modulate2*2),height);
          line(handsXX[1]-20,handsYY[1]+random(-modulate2,  modulate2),handsXX[1]+20,handsYY[1]+random(-modulate2,  modulate2));
        }
        */
             
       
       // println(handsZZ[0]);
        noStroke();
        fill(10);
        
        }
        
        if  (handsXX[0]<handsXX[1]) {

          controlR.x=handsXX[1];
          controlR.y=handsYY[1];

          controlL.x=handsXX[0];
          controlL.y=handsYY[0];
          
           modulate1=map(handsZZ[1],700,1200,0.1,10);
          modulate1=constrain(modulate1,0.1,10);
          modulate2=map(handsZZ[0],700,1200,0.1,10);
          modulate2=constrain(modulate2,0.1,10);
          stroke(0,0,40);
        noFill();
        
        /*
           // play with the deep. if there is modulation, make the lines shake a bit
        for(int i=0;i<5;i++){   
          line(handsXX[1]+random(-modulate1*2,  modulate1*2),0,handsXX[1]+random(-modulate1*2,  modulate1*2),height);
          line(handsXX[1]-20,handsYY[1]+random(-modulate1,  modulate1),handsXX[1]+20,handsYY[1]+random(-modulate1,  modulate1)); 
          line(handsXX[0]+random(-modulate2*2,  modulate2*2),0,handsXX[0]+random(-modulate2*2,  modulate2*2),height);
          line(handsXX[0]-20,handsYY[0]+random(-modulate2,  modulate2),handsXX[0]+20,handsYY[0]+random(-modulate2,  modulate2));
        }
        */
        
       // println(handsZZ[0]);
        noStroke();
        fill(10);
          
        }
        
        stroke(0,0,40);
        noFill();
        line(handsXX[0]-20,handsYY[0],handsXX[0]+20,handsYY[0]); 
        line(handsXX[0],0,handsXX[0],height); 
            
        line(handsXX[1]-20,handsYY[1],handsXX[1]+20,handsYY[1]); 
        line(handsXX[1],0,handsXX[1],height);
        noStroke();
        fill(10);
        
      }
    }

    // if there are no hands on the screen dont affect the system
    else { 
      moveL=false;
      moveR=false;
    }
    
    if(moveR==false && modulate1>0.1) modulate1=modulate1-0.1;
    if(moveL==false && modulate2>0.1) modulate2=modulate2-0.1;

pushMatrix();
    translate(width/2, 0);
 

    ////////////////////////////////

    //WHERE ALL THE ACTION HAPPENS // RIGHT SIDE
    for (int i=0;i<nrBars ;i++) {

      // if mouse is with the same ypos as a bar, the bar gets its Width  
      if (abs(controlR.y-barV[i])<20 && moveR==true) {
        barSizePrev[i]=constrain(controlR.x-(width/2), 20, width/2);

        //println(constrain(controlR.x-(width/2), 20, width/2));
  
        wave1.frequency.setLastValue(map(barSizePrev[i], 0, width/2, 200, 800 ));
      //  wave1.amplitude.setLastValue(handsZZ[0] );
        // the size of the bar that the hand is controling defines de amplitude
        //wave1.amplitude.setLastValue(map(barSizePrev[i], 0, width/2, 0.1, 0.5 ));
      }

      // sofly reduce the size of the bar the 20 again
      if (barSizePrev[i]>20) barSizePrev[i]-=0.5;


      // give to each bar the width of the mouse. calculos trick to make it smooth
      barSize[i]+=(barSizePrev[i]-barSize[i])*0.2;
      // change the color depending on the size
      barColor[i]=int(colorChange+(barSize[i]/50));

      //draw the rect
      noStroke();
      fill(barColor[i], 60, 80);
      rect(2, barV[i], barSize[i], height*0.09);

      freqChange+=barSize[i];
    }


    // freqchaneg amkes the sum of all the bars sizes. big bars, lots of activity
    freqChange=map(freqChange, 400, 6000, 0.1, 0.5 );
  //  println(freqChange);
    //the sum of all the sizes defines the frequency
    wave1.amplitude.setLastValue(freqChange);
   //wave1.frequency.setLastValue(freqChange);
    freqChange=0;
    
    //modulate from Depth
  modul1.frequency.setLastValue( modulate1);
 modul1.amplitude.setLastValue( map(modulate1, 0,10,0.1,2) );

    //animate the the bars down 
    for (int i=0; i<nrBars-1;i++) { 
      barV[i]+=2;
      if (barV[i]>height) {

        // read the sound when the bar crosses the 0
        //wave1.frequency.setLastValue(barSize[i]+100);

        barV[i]=-(height*0.09);
      }
    }

    // smoothy change the color base
    colorChange+=0.05;
    if (colorChange>=360)colorChange=0; 
    /////////////////////////////////////////////////////////////////////////////////


    ////////////////////////////////

    //WHERE ALL THE ACTION HAPPENS LEFT SIDE
    for (int i=0;i<nrBars ;i++) {

      // if mouse is with the same ypos as a bar, the bar gets its Width  
      if (abs(controlL.y-barV_[i])<20 && moveL==true) {

        // barSizePrev_[i]=(map(barSizePrev_[i],0,width, width, 0));

        barSizePrev_[i]=constrain(abs(controlL.x-width/2), 20, width);


        // the size of the bar that the hand is controling defines de amplitude
        wave2.frequency.setLastValue(map(barSizePrev_[i], 0, width/2, 100, 800 ));
      }

      // sofly reduce the size of the bar the 20 again
      if (barSizePrev_[i]>20) barSizePrev_[i]-=0.5;


      // give to each bar the width of the mouse. calculos trick to make it smooth
      barSize_[i]+=(barSizePrev_[i]-barSize_[i])*0.2;
      // change the color depending on the size
      barColor_[i]=int(colorChange_+(barSize_[i]/50));

      //draw the 
      noStroke();
      fill(barColor_[i], 60, 80);
      rect(-2, barV_[i], -barSize_[i], (height*0.09));

      freqChange_+=barSize_[i];
    }


    // freqchaneg amkes the sum of all the bars sizes. big bars, lots of activity
    freqChange_=map(freqChange_, 400, 6000, 0.1, 0.5  );
    //println(freqChange);
    //the sum of all the sizes defines the amplitude
    wave2.amplitude.setLastValue(freqChange_);
    freqChange_=0;
        //modulate from Depth
 
  modul2.frequency.setLastValue( modulate2*5 );
 modul2.amplitude.setLastValue( map(modulate2, 0,10,0.1,2) );

    //animate the the bars down 
    for (int i=0; i<nrBars-1;i++) { 
      barV_[i]+=2;
      if (barV_[i]>height) {

        // read the sound when the bar crosses the 0
        //wave1.frequency.setLastValue(barSize[i]+100);

        barV_[i]=-(height*0.09);
      }
    }

    // smoothy change the color base
    colorChange_+=0.05;
    if (colorChange_>=360)colorChange_=0; 
    /////////////////////////////////////////////////////////////////////////////////
     popMatrix();
     
     
  }
 
}

