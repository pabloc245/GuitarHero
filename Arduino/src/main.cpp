#include <Arduino.h>

bool newData = false;
volatile int prev_time = 0;
volatile int frequence = 0;

void setup() {
  // Appel de la fonction d'interruption rising sur front montant de la pin numérique 2
  attachInterrupt(digitalPinToInterrupt(2), rising, RISING);
  Serial.begin(9600);
}

void loop(){
  if(newData){
    Serial.println(frequence);
    newData = false;
  }
}

void rising() {
  unsigned long current_time = micros();
  frequence = 1000000 / (current_time - prev_time);
  prev_time = current_time;
  newData = true;
}
  