#include <Arduino.h>
#include <MsTimer2.h>

 
bool newData = false;
volatile long prev_time = 0;
volatile int frequence = 0;
unsigned long current_time;
int pinMetronome = 8;
double f0 = 261.0;

void rising();



void metronome(){
  digitalWrite(pinMetronome, HIGH);
  delay(50);
  digitalWrite(pinMetronome, LOW);
}

void setup() {
  attachInterrupt(digitalPinToInterrupt(2), rising, RISING);
  Serial.begin(9600);
  pinMode(13, OUTPUT);
  while (Serial.available() == 0) {
  }
  int data = Serial.parseInt();  
  MsTimer2::set(data, metronome); // Période de 1000 ms
  MsTimer2::start();
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


  