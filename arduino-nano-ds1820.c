//
//  ds1820 temperature to stdout
//

#include <OneWire.h>

#define DS1820_PIN 7
#define LED_PIN 13

OneWire ds(DS1820_PIN);


void led(int on) {
    if(on) { digitalWrite(LED_PIN, HIGH); }
    else { digitalWrite(LED_PIN, LOW); }
}


int read_t() {
  byte data[12];
    
  ds.reset(); ds.skip(); ds.write(0x44, 1); // measure
  delay(900); // delay > 750
  ds.reset(); ds.skip(); ds.write(0xBE); // read scratchpad

  int zero = 0;
  for(int i=0; i < 9; i++) { 
    data[i] = ds.read(); 
    if(data[i] != 0) { zero = 1; }
  }

  // Serial.print("hex: "); for(int i=0; i < 9; i++) { Serial.print(data[i], HEX); Serial.print(" "); }; Serial.println();
  
  if(data[8] != OneWire::crc8(data, 8) || zero == 0) {
    Serial.println("!DATA");
    return 0;
  }
  
  int t = ((int)data[1] << 8) + (int)data[0]; 
  
  // t = t*6+t/4;  // *6.25
  // Serial.print("t: "); 
  // Serial.println((float)t/100, 2);
  
  Serial.print((float)t * 0.0625, 2); Serial.print("\n");
  
  return 1;
}



void setup()
{
  pinMode(LED_PIN, OUTPUT);
  Serial.begin(9600);
}
 
void loop()
{
  led(1);
  if( read_t() ) {
    led(0); delay(400);
    led(1); delay(100);
    led(0); delay(100);
    led(1); delay(100);
    led(0); delay(100);
    led(1); delay(100);
  }
  led(0);

  delay(2000);
}

//.

