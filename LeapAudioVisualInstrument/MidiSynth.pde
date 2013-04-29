class MidiSynth implements ddf.minim.ugens.Instrument
{
  int         channel;
  int         noteNumber;
  int         noteVelocity;
 // Blip        blip;
  
  MidiSynth( int channelIndex, String noteName, float vel )
  {
    channel = channelIndex;
    // to make our sequence code more readable, we use note names.
    // and then convert the note name to a Midi note value here.
    noteNumber = (int)Frequency.ofPitch(noteName).asMidiNote();
    // similarly, we specify velocity as a [0,1] volume and convert to [1,127] here.
    noteVelocity = 1 + int(126*vel); 
  }
  
  void noteOn( float dur )
  {

    // make sound
    channels[channel].noteOn( noteNumber, noteVelocity );
  }
  
  void noteOff()
  {
    channels[channel].noteOff( noteNumber );
   // blips.remove( blip );
  }
}


