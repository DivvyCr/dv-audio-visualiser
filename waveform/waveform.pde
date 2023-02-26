/**
  * This sketch demonstrates how to play a file with Minim using an AudioPlayer. <br />
  * It's also a good example of how to draw the waveform of the audio. Full documentation 
  * for AudioPlayer can be found at http://code.compartmental.net/minim/audioplayer_class_audioplayer.html
  * <p>
  * For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/
  */

import ddf.minim.*;

Minim minim;
AudioPlayer player;

void setup()
{
  size(360, 720, P3D);
  
  minim = new Minim(this);
  player = minim.loadFile("../track2.mp3");
  player.play(0);
}

void draw()
{
  fill(0, 0, 0, 64);
  rect(0, 0, width, height);
  
  float[] samples = player.mix.toArray();
  for(int i = 0; i < samples.length - 1; i++)
  {
    float y1 = map(i  , 0, samples.length, 0, height);
    float y2 = map(i+1, 0, samples.length, 0, height);
    stroke(255, 152, 26);
    line(width/2 + samples[i]*50, y2, width/2 + samples[i+1]*50, y1);
  }
}
