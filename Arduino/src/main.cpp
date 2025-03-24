 #include <Arduino.h>
 
bool newData = false;
volatile long prev_time = 0;
volatile int frequence = 0;
unsigned long current_time;


void rising();

void setup() {
  attachInterrupt(digitalPinToInterrupt(2), rising, RISING);
  Serial.begin(9600);
}

void loop(){
  if(newData){
    Serial.print("frequence:");
    Serial.println(frequence);
    newData = false;
    prev_time= micros();
  }
}

void rising() {
  current_time = micros();
  frequence = 1000000.0 / (current_time - prev_time);
  prev_time = current_time;
  newData = true;
  
}


  