#include "WProgram.h"

#include <math.h>  // requires an Atmega168 chip
#define outpin 4
void setup();
void loop();
void freqout(int freq, int t);
int val1;
int speakerOut = 4;
int sensor1 = 1;
int freq,t;

void setup() {

     pinMode (speakerOut, OUTPUT);
}


void loop(){
     val1 = analogRead(sensor1);
     freqout((int)val1, t);
       delay(10);
}


     void freqout(int freq, int t)
{

 int hperiod;                               //calculate 1/2 period in us
val1 = 440;
hperiod = 500000 / freq;              
long cycles, i;
cycles = ((long)freq * (long)t) / 100;    // calculate cycles
for (i=0; i<= cycles; i++){              // play note for t ms  
 
   digitalWrite(speakerOut, HIGH);
   delayMicroseconds(hperiod);
   digitalWrite(speakerOut, LOW);
   delayMicroseconds(hperiod);     // - 1 to make up for fractional microsecond in digitaWrite overhead
}
} 
int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

