#include "WProgram.h"

#define SOUNDOUT_PIN 9
#define BT 8

void setup(void);
void loop(void);
float rt;
int o,t,val,i;

int pt[32] = {
 346,411,461,518,616,691,822,923,1036,1232,1383,1644,1845,2071,2463,2765,3288,
  3691,4143,4927,5530,6577,7382,8286,9854,11060,13153,14764,16572,19708,22121,26306
};

void setup(void){
//Set the sound out pin to output mode
pinMode(SOUNDOUT_PIN,OUTPUT);
pinMode(BT,INPUT);
val=0;
i=1;

}

void loop(void){

t=analogRead(5)/32;

rt=pt[t];
o=rt*analogRead(4)/64;

val = digitalRead(BT);  // le o botao


  
    if (val == HIGH) {
    switch (i) {
      case 1:
        o=o;
        i=2;
        break;
      case 2:
        o=o/2;
        i=3;
        break;
      case 3:
        o=o/4;
        i=4;
        break;
      case 4:
        o=o;
        i=1;
        break;  
      }    


}

  digitalWrite(SOUNDOUT_PIN,HIGH);
  delayMicroseconds(o);
  digitalWrite(SOUNDOUT_PIN,LOW);
  delayMicroseconds(o);

  }





int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

