/* 
 ---- SimpleMessageSystem Example 1 ----
 Control Arduino board functions with the following messages:
 
 r a -> read analog pins
 r d -> read digital pins
 w d [pin] [value] -> write digital pin
 w a [pin] [value] -> write analog pin
 
 
 Base: Thomas Ouellet Fredericks 
 Additions: Alexandre Quessy 
 
 */

// Include de SimpleMessageSystem library
// REMOVE THE FOLLOWING LINE IF USING WIRING
#include <SimpleMessageSystem.h> 

void setup()
{
Serial.begin(9600); 
}

void loop()
{

  if (messageBuild() > 0) { // Checks to see if the message is complete and erases any previous messages
      readpins(); // Call the readpins function
  }

}

void readpins(){ // Read pins (analog or digital)


/*  switch (messageGetChar()) { // Gets the next word as a character

    case 'd': // READ digital pins

    messageSendChar('d');  // Echo what is being read
    for (char i=2;i<14;i++) {
      messageSendInt(digitalRead(i)); // Read pins 2 to 13
    }
    messageEnd(); // Terminate the message being sent
    break; // Break from the switch

  case 'a': // READ analog pins
*/

    messageSendChar('a');  // Echo what is being read
//    for (char i=0;i<6;i++) {

int i;
for (i=0;i<=1023;i++){
  messageSendInt(i); // Read pins 0 to 5
}


//    }
    messageEnd(); // Terminate the message being sent

//  }



}
