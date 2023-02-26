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
  size(1024, 512, P3D);
  
  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  
  // loadFile will look in all the same places as loadImage does.
  // this means you can find files that are in the data folder and the 
  // sketch folder. you can also pass an absolute path, or a URL.
  player = minim.loadFile("track3.mp3");
  player.play(0);
}

void draw()
{
  fill(0, 0, 0, 64);
  rect(0, 0, width, height);
  
  float[] samples = player.mix.toArray();
  for(int i = 0; i < samples.length - 1; i++)
  {
    // if (random(0, 1) < 0.5) continue;
    float x1 = map( i, 0, player.bufferSize(), 0, width );
    float x2 = map( i+1, 0, player.bufferSize(), 0, width );
    stroke(255, 152, 26);
    line( x1, height/2 + samples[i]*50, x2, height/2 + samples[i+1]*50 );
  }
}
