// ISD4003code_0.1.pde
// Paul Badger 2007
// A program to control recording and playback on an ISD4003 chip with an Arduino. This program was developed for a  
// custom ISD4003 pcb but it should work on any ISD4003 / Arduino hookup.
// The board contains a digital potentiometer for volume control. The code for this chip is not in this program
// but will be added to a later version.

/* Arduino pin definitions  */
// Line up the first five pins of the sound board with the coresponding pins of the Bare Bones Board (Arduino) and run
// wires across the breadboard groove to connect

#define SCS        2	// MCP41100 chip select
#define SCS        3	// ISD4003 chip select 
#define MOSI       4	// ISD4003 serial data (master out - slave in)
#define SCLK       5	// ISD4003 serial clock
#define RecLED     8
#define PlayLED    9
#define RecSwitch  12
#define PlaySwitch 13                                                                                                                                
#define Shutdown   5


unsigned int addr = 0;	       // 11 bit address variable for isd4003
unsigned int r = addr;         // r will be reversed bits of v; first get LSB of v
int s = sizeof(addr) - 1;      // extra shift needed at end


unsigned int counter;
unsigned int contr;	       // 5 bit control variable for isd4003
unsigned int rpflag;
int val2;
int val;
int i;  
#define powerUp	        B00000100	// power up chip - wait Tpud - 32 ms for 4003-5
#define setPlay		B00000111	// initiates playback from included address <A0-A10>
#define play		B01111	// initiates playback from current address
#define setRec		B00101	// record from included address
#define rec		B01101	// record from current address
#define setMc 	        B10111	// start message cueing from included address
#define mc		B11111	// start message cue from current address
#define stopp		B01110	// stop current operation
#define stPwrDn		B01000	// stop current operation and power down
#define rInt	 	B01100	// read interrupt status - data out on "int" pin
int  pflag = 0;
int  rflag = 0;


void setup (){
  pinMode(Shutdown, OUTPUT); 
  digitalWrite(Shutdown, LOW);         // not the problem
  Serial.begin(9600);
  pinMode(SCS, OUTPUT);                // sets the digital pin as output
  pinMode(MOSI, OUTPUT);               // sets the digital pin as output
  pinMode(SCLK, OUTPUT);               // sets the digital pin as output
  pinMode(RecLED, OUTPUT);             // sets the digital pin as output
  pinMode(PlayLED, OUTPUT);            // sets the digital pin as output
  pinMode(RecSwitch, INPUT);           // sets the digital pin as output
  digitalWrite(RecSwitch, HIGH);       // set pullup resistor on RecSwitch pin
  pinMode(PlaySwitch, INPUT);          // sets the digital pin as output
  digitalWrite(PlaySwitch, HIGH);      // set pullup resistor on PlaySwitch pin

  Serial.print("start");
}

// record and play switches are set up as follows
// record switch on pin 15 - wired active high (+5V = button pushed)    - active LOW if using pullups
// record LED on pin 14 - don//t forget the series resistor
// play switch on pin 13 - wired active high (+5V = button pushed)
// play LED on pin 12 - don//t forget the series resistor

void loop(){
  addr =  500;
  // Serial.print(addr, DEC);
  // Serial.print("  ");
  // Serial.println(addr, BIN);

  delay(400);
  val = digitalRead(RecSwitch);  // read input value
  val2 = digitalRead(PlaySwitch); //read switch 2

  // Serial.print("val = ");
  // Serial.println(val);

  // ************************** handle record switch
  if (val == 1) {                     // check if the Rec switch input is HIGH - do record
    digitalWrite(RecLED, HIGH);       // turn LED ON
    //   Serial.print("rpflay = ");
    //    Serial.println(rpflag, DEC);
    if (rflag == 0){ 	              // do record routine on first time through loop only
      // addr = 0;		      // insert address to record from here
      DoRecord();	              // rpflag checks for the first time through
      rflag = 1; 
      // Serial.println(rflag, DEC);

      Serial.println("dorec");
    }
    //  Serial.println(rflag,DEC);

  } 
  else {                        // Record switch Off 
    digitalWrite(RecLED, LOW);  // turn LED OFF
                                // Serial.println(rflag, DEC);
  }

  //*****************  handle play switch
  if(val2 == 1){                   // play switch is on
    digitalWrite(PlayLED,HIGH);    // turn on "play" LED on pin 12

    if( pflag == 0){ 	           // do play routine on first time through loop only
      //  addr = 10;		   // insert the address to play from here		
      DoPlay();
      pflag = 1;                  // pflag = 1 means it's playing
    }
    //  Serial.println("doplay");
  }
  else if(val == 0 && val2 == 0 ){  // both switches are off - do stop
    digitalWrite(PlayLED, LOW);	    // turn off the play LED
    STOPPlayRec();	 //go to stop
    pflag = 0; 
    rflag = 0;
  }
} 

//***************** Record 

void DoRecord(){					// record from address set in variable "addr"

  Serial.println("record");
  digitalWrite( SCS, LOW);
  contr = powerUp;				// set control variable to power up
  shiftOut(MOSI, SCLK, MSBFIRST,(contr >> 8));     // shiftout highbyte
  shiftOut(MOSI, SCLK, MSBFIRST,(contr));     // shiftout lowhbyte   digitalWrite( SCS, HIGH);
  // DEBUG BIN16 contr, CR  
  digitalWrite( SCS, HIGH);
  delay(70);					// this delay is specified in the ISD4003 datasheet

  digitalWrite( SCS, LOW);
  contr = powerUp;				  // set control variable to power up
  shiftOut(MOSI, SCLK, MSBFIRST,(contr >> 8));    // shiftout highbyte
  shiftOut(MOSI, SCLK, MSBFIRST,(contr));         // shiftout lowhbyte   digitalWrite( SCS, HIGH);
  digitalWrite( SCS, HIGH);
  delay(140);					  // this delay is specified in the ISD4003 datasheet

  addr = reverseAddress(addr);	                  // reverse the bits of address because ISD4003 wants address bits LSB first (reversed)

  //  debug   addr  = B11001101;
  // debug   addr = reverseAddress(addr);	  // reverse the bits of address because ISD4003 wants address bits LSB first (reversed)
  // debug  contr = B00011010; // setPlay;        // set contr variable to "setPlay" command - defined above

  contr = setRec;

  contr = addr + contr;
  digitalWrite( SCS, LOW);                        // chip select line LOW - do this before every command
  delay(1);
  shiftOut(MOSI, SCLK, MSBFIRST,(contr >> 8));    // shiftout highbyte
  shiftOut(MOSI, SCLK, MSBFIRST,(contr));         // shiftout lowhbyte  Serial.println(contr, BIN);

  delay(70);

  digitalWrite( SCS, HIGH);                       // chip select line HIGH - do this after every commnand - the "activates" the command 
  delay(70);
  Serial.println(contr, BIN);
}

//****************************** Stop Play Rec
void STOPPlayRec(){
  Serial.println("stop");
  digitalWrite( SCS, LOW);
  contr = stopp;	  
  shiftOut(MOSI, SCLK, MSBFIRST,(contr >> 8));     // shiftout highbyte
  shiftOut(MOSI, SCLK, MSBFIRST,(contr >> 8));     // shiftout lowhbyte 
  digitalWrite( SCS, HIGH);
  // delay(1000);			           // this pause slows the cycling down when no button is pressed - not  neccessary
} 
//****************************** Do Play
void DoPlay(){			// this is hardwired to record from the beginning memory address
  Serial.println("doplay");
  digitalWrite( SCS, LOW);
  contr = powerUp;				      // set control variable to power up
  // shiftOut(MOSI, SCLK, MSBFIRST,(contr >> 8));     // shiftout highbyte
  //  shiftOut(MOSI, SCLK, MSBFIRST,(contr));         // shiftout lowhbyte   digitalWrite( SCS, HIGH);
  // DEBUG BIN16 contr, TAB, DEC rpflag, CR  
  digitalWrite( SCS, HIGH);
  delay(70);					      // this delay is in the ISD4003 datasheet

  digitalWrite( SCS, LOW);

  addr = reverseAddress(addr);	                     // reverse the bits of address because ISD4003 wants address bits LSB first (reversed)
  contr =  setPlay;				     // set contr variable to "setPlay" command - defined above
  contr = addr + contr;

  Serial.println(contr, BIN);

  shiftOut(MOSI, SCLK, MSBFIRST,(contr >> 8));     // shiftout highbyte
  shiftOut(MOSI, SCLK, MSBFIRST,(contr));     // shiftout lowhbyte   
  delay(70);

  digitalWrite( SCS, HIGH);                    // chip select high to start play
  //digitalWrite(MOSI, LOW);
  delay(10);
  digitalWrite(SCS, LOW);    // extra pulse on chip select line - we sweat blood to make this happen
  delay(10);
  digitalWrite( SCS, HIGH);  

}

int reverseAddress(int ad){      // reverse bits function
  unsigned int Raddr = 0;           // the reversed address
  int i;                          // counter variable
  for (i=0; i<16; i++){
    Raddr = Raddr << 1;           // shift one bit to the left - same as mulitiplying by 2
    Raddr = Raddr | (ad & 1);     // first bitwise AND ad to mask first bit, then bitwise OR with Raddr to insert the bit into Raddr
    ad = ad >> 1;                     // shift ad to the right to do the next bit - same as dividing by 2
  }
  return Raddr;                         // send the returned address back to the calling function
}
