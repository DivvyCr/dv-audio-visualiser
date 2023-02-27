/**
  * This sketch demonstrates two ways to accomplish offline (non-realtime) analysis of an audio file.<br>
  * The first method, which uses an AudioSample, is what you see running.<br>
  * The second method, which uses an AudioRecordingStream and is only available in Minim Beta 2.1.0 and beyond,<br>
  * can be viewed by looking at the offlineAnalysis.pde file.
  * <p>
  * For more information about Minim and additional features, visit http://code.compartmental.net/minim/
  *
  */

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;

Minim minim;
AudioPlayer track;
float[] avgSamplesLeft;
float[] avgSamplesRight;

void setup()
{
  size(1024, 512, P3D);

  minim = new Minim(this);

  analyzeUsingAudioRecordingStream();
  
  track = minim.loadFile("../track3.mp3");
  track.play(0);
}

void analyzeUsingAudioRecordingStream()
{
  int fftSize = 1024;
  AudioRecordingStream stream = minim.loadFileStream("../track3.mp3", fftSize, false);
  
  // tell it to "play" so we can read from it.
  stream.play();
  
  // create the buffer we use for reading from the stream
  MultiChannelBuffer buffer = new MultiChannelBuffer(fftSize, stream.getFormat().getChannels());
  
  // figure out how many samples are in the stream so we can allocate the correct number of spectra
  int totalSamples = int( (stream.getMillisecondLength() / 1000.0) * stream.getFormat().getSampleRate() );
  
  // now we'll analyze the samples in chunks
  int totalChunks = (totalSamples / fftSize) + 1;
  println("Analyzing " + totalSamples + " samples for total of " + totalChunks + " chunks.");
  
  avgSamplesLeft = new float[totalChunks];
  avgSamplesRight = new float[totalChunks];
  
  for(int chunkIdx = 0; chunkIdx < totalChunks; ++chunkIdx)
  {
    stream.read( buffer );

    float avgSampleLeft = 0;
    float avgSampleRight = 0;
    for(int i = 0; i < buffer.getBufferSize(); ++i) {
      avgSampleLeft += abs(buffer.getSample(0, i));
      avgSampleRight += abs(buffer.getSample(1, i));
    }
    avgSamplesLeft[chunkIdx] = avgSampleLeft / buffer.getBufferSize();
    avgSamplesRight[chunkIdx] = avgSampleRight / buffer.getBufferSize();
  }
}

void draw()
{ 
  background(0);

  float pos = map(track.position(), 0, track.length(), 0, avgSamplesLeft.length);
  
  for (int i = max(0, int(pos)-100); i < avgSamplesLeft.length && i < int(pos)+100; i++) {
    float x = map(i, int(pos)-100, int(pos)+100, 0, width);
    
    float temp = x >= width/2 ? 1 : -1;
    temp *= pow(0.5 * abs(i - int(pos)), 1.6);
    
    float deviate = map(abs(width/2 - x), 100, width/2, 0, 2);
    temp += random(-deviate, deviate);
    
    if (x >= width/2 - 10 && x <= width/2 + 10) {
      stroke(255, 150, 25, 255);
    } else {
      float opacity = map(abs(width/2 - x), 50, width/2, 0, 255);
      stroke(255, opacity);
    }
    strokeWeight(2);
    line(width/2 + temp, height/2, width/2 + temp, height/2 - avgSamplesLeft[i]*200);
    line(width/2 + temp, height/2, width/2 + temp, height/2 + avgSamplesRight[i]*200);
  }
}
