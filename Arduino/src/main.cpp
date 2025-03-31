 #include <Arduino.h>
 
bool newData = false;
volatile long prev_time = 0;
volatile int frequence = 0;
unsigned long current_time;

double f0 = 261.0;

// enum notes{
//   DO,
//   RE,
//   MI,
//   FA,
//   SOL,
//   LA,
//   SI,
//   DO,
// };


void rising();

void setup() {
  attachInterrupt(digitalPinToInterrupt(2), rising, RISING);
  Serial.begin(9600);
}

void loop(){
  if(newData){
    Serial.println(frequence);
    newData = false;
    prev_time= micros();
  }
  delay(100);
}

void rising() {
  current_time = micros();
  frequence = 1000000.0 / (current_time - prev_time);
  prev_time = current_time;
  newData = true;
  
}


  