import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer player;
FFT fft;

void setup()
{
  size(1024, 512);
  
  minim = new Minim(this);
  player = minim.loadFile("../track2.mp3"); 
  fft = new FFT(player.bufferSize(), player.sampleRate());
  
  player.play(0);
}

float[] values;
float[] prevValues;

void draw()
{
  fill(0, 50);
  rect(0, 0, width, height);
  
  fft.forward(player.mix);
 
  values = new float[fft.specSize()];
  for(int i = 0; i < fft.specSize(); i++) {
    int j = fft.specSize()-i;
    stroke(255);
    values[i] = fft.getBand(i)*3;
    if (prevValues == null) {
      prevValues = new float[fft.specSize()];
    }
    
    stroke(255);
    if (prevValues[i] > values[i]) {
      line(width/2, j, width/2 - prevValues[i], j);
      line(width/2, j, width/2 + prevValues[i], j);
      prevValues[i] = prevValues[i] * 0.9;
    } else {
      //if ((values[i] - prevValues[i]) / prevValues[i] > 0.8) {
      //  stroke(255, 150, 25);
      //}
      stroke(255, 150, 25);
      line(width/2, j, width/2 - values[i], j);
      line(width/2, j, width/2 + values[i], j);
      prevValues[i] = values[i];
    }
  }
}
