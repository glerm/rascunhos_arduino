//Arduino Sound Hello World
//Created by David Fowler of uCHobby.com
//Define the I/O pin we will use for our sound output
#define SOUNDOUT_PIN 9
int t;
float rt;

int pt[32] = {
 346,411,461,518,616,691,822,923,1036,1232,1383,1644,1845,2071,2463,2765,3288,
  3691,4143,4927,5530,6577,7382,8286,9854,11060,13153,14764,16572,19708,22121,26306
};

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
