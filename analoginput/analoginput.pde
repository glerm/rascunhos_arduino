/*
  Analog input

 reads an analog input on analog in 0, prints the value out.

 created 24 March 2006
 by Tom Igoe
 */

int analogValue = 0;    // variable to hold the analog value

void setup() {
  // open the serial port at 9600 bps:
  Serial.begin(115200);
}

void loop() {
  // read the analog input on pin 0:
  analogValue = analogRead(0);


//  Serial.print("a");
  Serial.print(analogValue/4, BYTE); // print as a raw byte value (divide the

}
