#include "WProgram.h"
/*
 * Blink
 *
 * The basic Arduino example.  Turns on an LED on for one second,
 * then off for one second, and so on...  We use pin 13 because,
 * depending on your Arduino board, it has either a built-in LED
 * or a built-in resistor so that you need only an LED.
 *
 * http://www.arduino.cc/en/Tutorial/Blink
 */

void setup();
void loop();
int ledPin = 2;                // LED connected to digital pin 2
int l2=5;
int l3=7;

void setup()                    // run once, when the sketch starts
{
  pinMode(ledPin, OUTPUT);      // sets the digital pin as output
  pinMode(l2, OUTPUT);      // sets the digital pin as output
  pinMode(l3, OUTPUT);
}

void loop()                     // run over and over again
{
  digitalWrite(ledPin, HIGH);   // sets the LED on
  digitalWrite(l2, HIGH);   // sets the LED on
  digitalWrite(l3, HIGH);
  delay(500);                  // waits for a second
  digitalWrite(ledPin, LOW);    // sets the LED off
  
  delay(500);        
  
  digitalWrite(l2, LOW);    // sets the LED off
  digitalWrite(l3, HIGH);

  digitalWrite(ledPin, HIGH);   // sets the LED on
  delay(250);                  // waits for a second
  digitalWrite(ledPin, LOW);    // sets the LED off
  digitalWrite(l3, LOW);
  delay(500);                  // waits for a second

  digitalWrite(ledPin, HIGH);   // sets the LED on
  digitalWrite(l2, HIGH);   // sets the LED on
  delay(100);                  // waits for a second
  digitalWrite(ledPin, LOW);    // sets the LED off
  digitalWrite(l2, LOW);    // sets the LED off
  delay(100);                  // waits for a second
    
  
  
  
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

