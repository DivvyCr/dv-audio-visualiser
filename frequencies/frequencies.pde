import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer player;
FFT fft;

void setup()
{
  size(1024, 1024);
  
  minim = new Minim(this);
  player = minim.loadFile("../track2.mp3"); 
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.linAverages(fft.specSize()/3); // TODO: Use log, but don't account for band widths (ie. just use lines)
  
  player.play(0);
}

float[] values;
float[] prevValues;

void draw()
{
  fill(0, 16);
  rect(0, 0, width, height);
  
  fft.forward(player.mix);
 
  values = new float[fft.specSize()];
  for(int i = 0; i < fft.avgSize(); i++) {
    float j = map(i, 0, fft.avgSize(), 0, height/2);
    stroke(255);
    values[i] = fft.getAvg(i)*3;
    if (prevValues == null) {
      prevValues = new float[fft.avgSize()];
    }
    
    stroke(255);
    if (prevValues[i] > values[i]) {
      line(width/2, height/2 - j, width/2 - prevValues[i], height/2 - j);
      line(width/2, height/2 - j, width/2 + prevValues[i], height/2 - j);
      line(width/2, height/2 + j, width/2 - prevValues[i], height/2 + j);
      line(width/2, height/2 + j, width/2 + prevValues[i], height/2 + j);
      prevValues[i] = prevValues[i] * 0.9;
    } else {
      //if ((values[i] - prevValues[i]) / prevValues[i] > 0.8) {
      //  stroke(255, 150, 25);
      //}
      stroke(255, 150, 25);
      line(width/2, height/2 - j, width/2 - values[i], height/2 - j);
      line(width/2, height/2 - j, width/2 + values[i], height/2 - j);
      line(width/2, height/2 + j, width/2 - values[i], height/2 + j);
      line(width/2, height/2 + j, width/2 + values[i], height/2 + j);
      prevValues[i] = values[i];
    }
  }
}
