#include "WProgram.h"
#include <SimpleMessageSystem.h>



void setup();
void loop();
void setup() {
  // open the serial port at 9600 bps:
  Serial.begin(115200);
}

void loop() {
  // read the analog input on pin 0:
  
    messageSendChar('a');  // Echo what is being read
    for (char i=0;i<6;i++) {
      messageSendInt(analogRead(i)); // Read pins 0 to 5
    }
    messageEnd(); // Terminate the message being sent

    messageSendChar('d');  // Echo what is being read
    for (char i=2;i<14;i++) {
      messageSendInt(digitalRead(i)); // Read pins 2 to 13
    }
    messageEnd(); // Terminate the message being sent





/*
     for (int i=0; i <= 1023; i++){
   
       messageSendChar('a');
       messageSendInt(i); // Analogo Zero        
       messageEnd(); // Termina      
   } 
*/  
 
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

