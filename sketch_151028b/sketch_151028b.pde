import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer song;
FFT fft;
float centX = width/2;
float centY = height/2;
float bassx = width/10;
float bassy = height/10;
float lowend = 100;
float midrange = 10000;
float highend = 20000;



void setup()
{
  size(1024, 700);
 
  // always start Minim first!
  minim = new Minim(this);
 
  // specify 512 for the length of the sample buffers
  // the default buffer size is 1024
  song = minim.loadFile("seanmusic.mp3", 2048);
  song.play();
 
  // an FFT needs to know how 
  // long the audio buffers it will be analyzing are
  // and also needs to know 
  // the sample rate of the audio it is analyzing
  fft = new FFT(song.bufferSize(), song.sampleRate());
}
 
void draw()
{
  background(0);
  // first perform a forward fft on one of song's buffers
  // I'm using the mix buffer
  //  but you can use any one you like
  fft.forward(song.mix);
 
  stroke(255, 0, 0, 128);
  
  for(int i = 0; i < fft.specSize(); i++)                    //for each part of the music sample
  {
    if((i>0) && (i<lowend))        //split the music into separate bands(lows)
    {
      ellipse(centX,centY,bassx,bassy);    //bass circle
    }
    if((fft.getFreq(i)>lowend) && (fft.getFreq(i)<midrange))  //split the music into separate bands(mids)
    {
      rect(centX-10,centY-10,20,20);      //draw mid rectangle
    }
    if((fft.getFreq(i)>midrange) && (fft.getFreq(i)<highend) )  //split the music into separate bands(highs)
    {
      line(i,height, i , (5 + fft.getBand(i)));          //draw lines based on frequencies
    }
    line(i, height, i, height - fft.getBand(i)*25);
  }
 
  stroke(255);
  // I draw the waveform by connecting 
  // neighbor values with a line. I multiply 
  // each of the values by 50 
  // because the values in the buffers are normalized
  // this means that they have values between -1 and 1. 
  // If we don't scale them up our waveform 
  // will look more or less like a straight line.
  for(int i = 0; i < song.left.size() - 1; i++)
  {
    line(i, 50 + song.left.get(i)*200, i+1, 50 + song.left.get(i+1)*200);

  }
}

void stop()
{
  song.close();
  minim.stop();
  super.stop();
}
