import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer player;
FFT fft;

void setup()
{
  size(512, 512);
  
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
    stroke(255);
    values[i] = fft.getBand(i)*3;
    if (prevValues == null) {
      prevValues = new float[fft.specSize()];
    }
    if (prevValues[i] > values[i]) {
      line(i, height, i, height - prevValues[i]);
      prevValues[i] = prevValues[i] * 0.9;
    } else {
      line(i, height, i, height - values[i]);
      prevValues[i] = values[i];
    }
  }
}
