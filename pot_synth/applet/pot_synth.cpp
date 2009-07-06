#include "WProgram.h"
//Arduino Sound Hello World
//Created by David Fowler of uCHobby.com
//Define the I/O pin we will use for our sound output
#define SOUNDOUT_PIN 9
void setup(void);
void loop(void);
int t;
float rt;

void setup(void){
//Set the sound out pin to output mode
pinMode(SOUNDOUT_PIN,OUTPUT);

}

void loop(void){
//Generate sound by toggling the I/O pin High and Low
//Generate a 1KHz tone. set the pin high for 500uS then
//low for 500uS to make the period 1ms or 1KHz.

t=analogRead(5);
rt=t*10;

//Set the pin high and delay for 1/2 a cycle of 1KHz, 500uS.
digitalWrite(SOUNDOUT_PIN,HIGH);
delayMicroseconds(rt);

//Set the pin low and delay for 1/2 a cycle of 1KHz, 500uS.
digitalWrite(SOUNDOUT_PIN,LOW);
delayMicroseconds(rt);
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

