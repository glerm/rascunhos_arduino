

/*
 * WiiChuckDemo -- 
 *
 * 2008 Tod E. Kurt, http://thingm.com/
 *
 */
#include <Firmata.h>
#include <Wire.h>
#include "nunchuck_funcs.h"

int loop_cnt=0;

byte accx,accy,zbut,cbut;
int ledPin = 13;


void setup()
{
    Firmata.begin(19200);
    Firmata.processInput();
    nunchuck_setpowerpins();
    nunchuck_init(); // send the initilization handshake
    
    Serial.print("WiiChuckDemo ready\n");
}

void loop()
{
    if( loop_cnt > 100 ) { // every 100 msecs get new data
        loop_cnt = 0;

        nunchuck_get_data();

        accx  = nunchuck_accelx(); // ranges from approx 70 - 182
        accy  = nunchuck_accely(); // ranges from approx 65 - 173
        zbut = nunchuck_zbutton();
        cbut = nunchuck_cbutton(); 
        
        
        Firmata.sendAnalog(0, accx); 
        Firmata.sendAnalog(1, accy);
        Firmata.sendDigital(2, zbut);
        Firmata.sendDigital(3, cbut);

    }
    loop_cnt++;
    delay(1);
}

