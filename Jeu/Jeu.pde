import processing.serial.*;
// 1. DÉCLARATION DES CONSTANTES
//Menu
final int MENU = 0;
final int POS_MENU = 190;

final float TEMPO = 32;
final int NB_NOTES = 8;
final float LIGNESX = 80;
final float START_Y = 150;
final float[] lNote = {6, 7, 1, 2, 3, 4, 5};
final int START_X = 300;
final float FIN_LIGNE = 600;
final int H_RECT = 18;
final int W_RECT = 20;
final int VITESSE = 6;

// 2. VARIABLES D'ÉTAT GÉNÉRALES
int ecranActif = MENU;
boolean partieEnCours = false;

// 3. VARIABLES UI REGROUPÉES PAR FONCTION

// Interface Menu
String[] textesBoutons = {"Jouer", "Options", "Quitter"};
color couleurBouton = color(0, 0, 0);
Bouton[] BoutonMenu = {
  new Bouton(300, POS_MENU, 200, 50, couleurBouton, "Jouer"),
  new Bouton(300, POS_MENU + 65, 200, 50, couleurBouton, "Options"),
  new Bouton(300, POS_MENU + 65*2, 200, 50, couleurBouton, "Quitter")
};

//inutile mais on sait jamais

// A : La
// B : Si
// C : Do
// D : Ré
// E : Mi
// F : Fa
// G : Sol

// Interface Jeu

float fact = 1;
Joueur joueur1;
ArrayList<Notes> touche = new ArrayList<>();
ArrayList<Notes> active = new ArrayList<>();
ArrayList<Notes> notesToRemove = new ArrayList<>();


// 4. RESSOURCES



// TEST
int z = 0;
int x = 50;
int y = 50;
int speedX = 2;
int speedY = 2;
float amplitude = 50;
float periode = 50;

//PORT USB
Serial myPort; 


void setup() {
  size(900, 700);  
  background(255);
  textAlign(CENTER, CENTER);
  noFill();
  stroke(0, 0, 0);
  println("Framerate: " + frameRate);
  for(int i; i > Serial.list().length; i++){
    println(Serial.list()[i]);
  }

  if(Serial.list().length>0){
    try{
      myPort = new Serial(this, Serial.list()[0], 9600);
      println("Connection au port: " + Serial.list()[0]);
    } catch (Exception e) {
      println("Erreur : Le port " + Serial.list()[0] + " est déjà utilisé ou inaccessible.");
    }
  }else{
    println("pas d'instrument connecté");
  }

  Partition partition = new Partition("text.abc");
  partition.clean();
  partition.metaData();
  active = partition.lecture();
  print("Touche:");
  for(Notes note : active){
    note.printN();
  }
  
}

void draw() {
  background(255);
  ellipse(x, y, 50, 50);  
  line(0, FIN_LIGNE + W_RECT, 500, FIN_LIGNE + W_RECT); 
  
  x += speedX;
  y += speedY;

  if (x > width - 25 || x < 25) {
    speedX *= -1;
  }
  if (y > height - 25 || y < 25) {
    speedY *= -1;
  }

  beginShape();
  for (int x = 0; x < width; x++) {
    float y = height/2 + amplitude * sin(x * TWO_PI / periode);
    vertex(x, y);
  }
  endShape();

  

  switch(ecranActif) {
    case 0:
      dessinerMenu();
      break;
    case 1:
      dessinerJeu();
      break;
    case 2:
      dessinerOptions();
      break;    
  }
}

void serialEvent(Serial p) { ////COde qui verifie la note 
  String[] StrNote = {"DO", "RE", "MI", "FA", "SOL", "LA", "SI", "DO"};

  for (int i = 0; i < 16; i += 2) {
    float frequence = 261.63 * pow(2, i / 12.0);
    int frequence_arrondie = int(round(frequence));
    
    int val = readUSBPort(); 

    if (val >= frequence_arrondie - 10 && val <= frequence_arrondie + 10) {
      testKey(i);
      println(StrNote[i]);/// affichage de verification
    }
  }
}




void keyPressed() {
  switch (keyCode) {
    case UP:
      periode += 5;
      break;
    case DOWN:
      periode -= 5;
      break;
    case 65: //'a'
      testKey(1);
      break;
    case 90://'z'
      testKey(2);
      break;
    case 69://'e'
      testKey(3);
      break;
  }
}

void testKey(int noteeee){
  println("Note: " + noteeee);
  for (Notes note : active) {
    if (note.y > FIN_LIGNE - note.r - 25 && note.n==noteeee) {
      println(note.n);
      note.touched = true;
    }   
  }
}

void mousePressed(){
  evenmentBouton();
}

void evenmentBouton(){
  int numeroBouton;
  for(int i=0; i < 3; i++){
    ecranActif = BoutonMenu[i].clic() ? i : ecranActif;
  }
  println("Bouton" + ecranActif);
}