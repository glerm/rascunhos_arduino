/*
 * NunchuckTest
 *
 * By Karsten Schmidt (http://postspectacular.com/).
 *
 */

import toxi.geom.*;
import processing.opengl.*;
import processing.serial.*;

Serial port;

NunchukParcel nunchuk;

Vec3D pos;

void setup() {
  size(1024,768,OPENGL);
  pos=new Vec3D(width/2,height/2,0);
  nunchuk=new NunchukParcel("0,0,0,0,0,1,1");
  port=new Serial(this,"COM6",19200);           //CHECK THIS - change to relevant serial port
}

void draw() {
  if (port.available()>0) {
    String input=port.readStringUntil('*');
    println(input);
    if (input!=null) {
      input=input.substring(0,input.length()-1);
      NunchukParcel n=new NunchukParcel(input);
      nunchuk.updateParcel(n);
      //pos.se(nunchuk.joystick.sub(116,130,0));
    }
  }
  background(0);
  lights();
  translate(pos.x,pos.y,pos.z);
  rotateX(radians(nunchuk.accel.x));
  rotateY(radians(nunchuk.accel.y));
  rotateZ(radians(nunchuk.accel.z));
  pushMatrix();
  scale(2);
  beginShape(LINES);
  stroke(255,0,0);
  vertex(0,0,0); vertex(100,0,0);
  stroke(0,255,0);
  vertex(0,0,0); vertex(0,100,0);
  stroke(0,0,255);
  vertex(0,0,0); vertex(0,0,100);
  endShape();
  popMatrix();
  if (nunchuk.isZButtonOn) fill(255,0,0);
  else fill(255);
  noStroke();
  scale(max(0,(nunchuk.joystick.y-130)*0.1+2));
  box(100);
  //println(nunchuk.joystick);
}

class NunchukParcel {
  Vec3D joystick;
  Vec3D accel;
  boolean isZButtonOn;
  boolean isCButtonOn;

  NunchukParcel(String data) {
    String[] items=split(data,",");
    if (items.length==7) {
      joystick=new Vec3D(parseInt(items[0]),parseInt(items[1]),0);
      accel=new Vec3D(parseInt(items[2]),parseInt(items[3]),parseInt(items[4]));
      isZButtonOn=(parseInt(items[5])==0);
      isCButtonOn=(parseInt(items[6])==0);
    }
    else {
      println("invalid nunchuk parcel: "+data);
    }
  }

  void updateParcel(NunchukParcel p) {
    joystick.interpolateToSelf(p.joystick,0.15);
    accel.interpolateToSelf(p.accel,0.15);
    isZButtonOn=p.isZButtonOn;
    isCButtonOn=p.isCButtonOn;
  }
}
