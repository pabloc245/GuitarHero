/* #include <Arduino.h>

// --- Configuration des broches ---
const int inputPin = 2;      // Entrée du signal NE555 (Interruption INT0)
const int mirrorPin = 9;     // Sortie miroir pour l'oscilloscope (Channel 2)
const int metronomePin = 3;  // LED ou Buzzer pour le rythme

// --- Variables pour la mesure de fréquence ---
volatile unsigned long lastMicros = 0;
volatile unsigned long duration = 0;
volatile bool newData = false;

// --- Variables Métronome ---
int bpm = 180;
unsigned long metronomeInterval;
unsigned long previousMetronomeMicros = 0;

// Fonction d'interruption (appelée à chaque front montant du NE555)
void measureFrequency() {
  unsigned long currentMicros = micros();
  duration = currentMicros - lastMicros; // Temps d'une période en µs
  lastMicros = currentMicros;
  newData = true;
}

void setup() {
  Serial.begin(9600);
  
  pinMode(inputPin, INPUT);
  pinMode(mirrorPin, OUTPUT);
  pinMode(metronomePin, OUTPUT);

  // Calcul de l'intervalle du métronome en microsecondes
  metronomeInterval = (60000000ULL / bpm);

  // Configuration de l'interruption sur la Pin 2 (Front montant)
  attachInterrupt(digitalPinToInterrupt(inputPin), measureFrequency, RISING);
  
  Serial.println("Systeme de mesure et Metronome pret.");
}

void loop() {
  unsigned long currentLoopMicros = micros();

  // 1. GESTION DU MÉTRONOME (Sans delay)
  if (currentLoopMicros - previousMetronomeMicros >= metronomeInterval) {
    previousMetronomeMicros = currentLoopMicros;
    digitalWrite(metronomePin, HIGH);
    // Le flash dure 20ms pour ne pas bloquer le reste
  }
  if (currentLoopMicros - previousMetronomeMicros >= 20000) {
    digitalWrite(metronomePin, LOW);
  }

  // 2. GÉNÉRATION DU SIGNAL MIROIR ET AFFICHAGE
  if (newData) {
    newData = false;
    float frequency = 1000000.0 / duration;

    // On reproduit la fréquence sur la Pin 9 (Signal miroir)
    // tone() génère un signal carré de la fréquence voulue
    if (frequency > 20 && frequency < 5000) { // Filtre de sécurité
       tone(mirrorPin, (int)frequency);
    } else {
       noTone(mirrorPin);
    }

    // Debug pour le moniteur série
    static unsigned long lastPrint = 0;
    if (millis() - lastPrint > 500) { // Affiche toutes les 0.5s
      Serial.print("Frequence NE555 mesuree : ");
      Serial.print(frequency);
      Serial.println(" Hz");
      lastPrint = millis();
    }
  }
} */

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
    pinMode(pinMetronome, OUTPUT); // Active la Pin 8 

    // --- ON FIXE LE MÉTRONOME ICI SANS ATTENDRE LE CLAVIER ---
    int tempoParDefaut = 1000; // 1000ms entre chaque bip (1 seconde)
    MsTimer2::set(tempoParDefaut, metronome); // On règle le timer 
    MsTimer2::start(); // On lance le métronome 
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


  