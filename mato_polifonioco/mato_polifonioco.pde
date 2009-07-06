
#define SOUNDOUT_PIN 9
#define BT 8

float rt;
int o,t,val,prog;

int pt[32] = {
 346,411,461,518,616,691,822,923,1036,1232,1383,1644,1845,2071,2463,2765,3288,
  3691,4143,4927,5530,6577,7382,8286,9854,11060,13153,14764,16572,19708,22121,26306
};

void setup(void){
//Set the sound out pin to output mode
pinMode(SOUNDOUT_PIN,OUTPUT);
pinMode(BT,INPUT);
val=0;

}

void loop(void){


t=analogRead(5)/32;

rt=pt[t];
o=rt*analogRead(4)/64;

val = digitalRead(BT);  // le o botao
if (val == HIGH) {            
    digitalWrite(ledPin, LOW);  
  } else {
    prog=prog;
  }

//Set the pin high and delay for 1/2 a cycle of 1KHz, 500uS.
digitalWrite(SOUNDOUT_PIN,HIGH);
delayMicroseconds(o);

//Set the pin low and delay for 1/2 a cycle of 1KHz, 500uS.
digitalWrite(SOUNDOUT_PIN,LOW);
delayMicroseconds(o);


}
