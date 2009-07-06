/*
 * WiiChuck -- Send serial data with a Wii Nunchuck
 *
 * This code is based on the original code by Chad Philips (www.windmeadow.com), 
 * WiiChuck code from Todd E. Kurt (todbot.com) and has been tweaked by Karsten
 * Schmidt (http://postspectacular.com/).
 *
 * The WiiChuck adaptor uses analog pins 2-5 as shown below:
 * PWR - -- gnd -- black -- Gnd
 * PWR + -- +5V -- red   -- 5V
 * I2C d -- SDA -- green -- Analog In 4
 * I2C c -- SCK -- blue  -- Analog In 5
 *
 */

#include "Wire.h"
#include "WiiChuck_funcs.h"

uint8_t outbuf[6];		// array to store arduino output
int cnt = 0;

#define WiiChuck_ARDUINO_POWERED 1

void setup()
{
    Serial.begin(19200);
    
    if( WiiChuck_ARDUINO_POWERED ) {
        WiiChuck_beginWithPower();
    } else {
        WiiChuck_begin();
    }

    nunchuck_init(); // send the initilization handshake
}

void loop() {
  Wire.requestFrom (0x52, 6);	// request data from nunchuck
  while (Wire.available ()) {
    outbuf[cnt] = nunchuk_decode_byte (Wire.receive ());	// receive byte as an integer
    cnt++;
  }

  // If we recieved the 6 bytes, then go print them
  if (cnt >= 5) {
    print ();
  }

  cnt = 0;
  send_zero (); // send the request for next bytes
  delay (100);
}

// Print the input data we have recieved
// accel data is 10 bits long
// so we read 8 bits, then we have to add
// on the last 2 bits.  That is why I
// multiply them by 2 * 2
void print () {
  int joy_x_axis = outbuf[0];
  int joy_y_axis = outbuf[1];
  int accel_x_axis = outbuf[2] <<2; 
  int accel_y_axis = outbuf[3] <<2;
  int accel_z_axis = outbuf[4] <<2;

  int z_button = 0;
  int c_button = 0;

  // byte outbuf[5] contains bits for z and c buttons
  // it also contains the least significant bits for the accelerometer data
  // so we have to check each bit of byte outbuf[5]
  if (outbuf[5] & 0x01) {
    z_button = 1;
  }
  if (outbuf[5] & 0x02) {
    c_button = 1;
  }

  if (outbuf[5] & 0x04) {
    accel_x_axis += 2;
  }
  if (outbuf[5] & 0x08) {
    accel_x_axis ++;
  }
  if (outbuf[5] & 0x10) {
    accel_y_axis += 2;
  }
  if (outbuf[5] & 0x20) {
    accel_y_axis ++;
  }
  if (outbuf[5] & 0x40) {
    accel_z_axis += 2;
  }
  if (outbuf[5] & 0x80) {
    accel_z_axis ++;
  }

  Serial.print (joy_x_axis, DEC);
  Serial.print (",");

  Serial.print (joy_y_axis, DEC);
  Serial.print (",");

  Serial.print (accel_x_axis, DEC);
  Serial.print (",");

  Serial.print (accel_y_axis, DEC);
  Serial.print (",");

  Serial.print (accel_z_axis, DEC);
  Serial.print (",");

  Serial.print (z_button, DEC);
  Serial.print (",");

  Serial.print (c_button, DEC);

  Serial.print ("*");
}

void nunchuck_init () {
  Wire.beginTransmission (0x52);// transmit to device 0x52
  Wire.send (0x40);		// sends memory address
  Wire.send (0x00);		// sends sent a zero.  
  Wire.endTransmission ();	// stop transmitting
}

void send_zero () {
  Wire.beginTransmission (0x52);// transmit to device 0x52
  Wire.send (0x00);		// sends one byte
  Wire.endTransmission ();	// stop transmitting
}

// Encode data to format that most wiimote drivers except
// only needed if you use one of the regular wiimote drivers
char nunchuk_decode_byte (char x) {
  x = (x ^ 0x17) + 0x17;
  return x;
}
