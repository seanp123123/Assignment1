import ddf.minim.*;

AudioPlayer song;
Minim minim;//audio context

void setup()
{
  minim = new Minim(this);
  song = minim.loadFile("seanmusic.mp3", 2048);
  song.play();
  
}

void draw()
{
   background(0);
  stroke(255);
  /*draw waveform based on amplitude information
  gain variable needed as song.left and song.right return a value between 1 and -1*/
  float gain; 
  gain = 50;
  
  for(int i = 0; i < song.bufferSize() - 1; i++)
  {
    line(i, 50 + song.left.get(i)*gain, i+1, 50 + song.left.get(i+1)*gain);
    line(i, 150 + song.right.get(i)*gain, i+1, 150 + song.right.get(i+1)*gain);
  }
}
//function to stop song from playing
void stop()
{
  song.close();
  minim.stop();
  super.stop();
}
