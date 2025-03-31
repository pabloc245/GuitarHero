import processing.serial.*;
// 1. DÉCLARATION DES CONSTANTES
//COORDONNE GRAPHIQUE
final int MENU = 0;
final int POS_MENU = 190;

final float TEMPO = 32;

final float LIGNESX = 80;
final float LIGNEY = 30;
final float FIN_LIGNE = 600;
final int H_RECT = 20;
final int W_RECT = 20;
final int VITESSE = 2;

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

  if(Serial.list().length>0 ){
    try{
      myPort = new Serial(this, Serial.list()[0], 9600);
    } catch (Exception e) {
      println("Erreur : Le port " + Serial.list()[0] + " est déjà utilisé ou inaccessible.");
    }
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

void serialEvent(Serial p) { 
  println(readUSBPort());
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
      testKey('A');
      break;
    case 90://'z'
      testKey('B');
      break;
    case 69://'e'
      testKey('C');
      break;
  }
}

void testKey(char noteeee){
  println("Note: " + noteeee);
  for (Notes note : touche) {
    if (note.y > FIN_LIGNE-40 && note.n==noteeee) {
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