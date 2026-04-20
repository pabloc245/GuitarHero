import processing.serial.*;
//music
import ddf.minim.*;


// 1. DÉCLARATION DES CONSTANTES
//Menu
final int MENU = 0;
final int POS_MENU = 190;

final float LIGNESX = 80;
final float START_Y = 0;
final int START_X = 400;
final float FIN_LIGNE = 600;
final float MAX_RAYON = 50;
final int VITESSE = 6;
final float RAYON = 5; 
final int MAX_SCORE = 300;
final int DELAI_EXTINCTION = 10; // éteint après 10 frames sans signal

final int NB_NOTES = 8;
final float TEMPO = 30;
final int[] lNote = {6, 7, 1, 2, 3, 4, 5};

//music
//Minim minim = new Minim(this);

// 2. VARIABLES D'ÉTAT GÉNÉRALES
int frequenceAffichee = 0;
int[] noteValue = {645, 700, 760, 830, 915, 990, 1110, 1190}; 
int ecranActif = MENU;
boolean partieEnCours = false;
int noteDetectee = -1;
int framesDepuisDerniereNote = 0;

// 3. VARIABLES UI REGROUPÉES PAR FONCTION

// Interface Menu
int newNote = 0; 
int lastNote;
color blanc = color(204, 204, 204);
color vert = color(76, 250, 154);
color rouge = color(255, 17, 54);
color couleurBouton = blanc;
Bouton[] BoutonMenu = {
  new Bouton(300, POS_MENU, 200, 50, couleurBouton, "Jouer"),
  new Bouton(300, POS_MENU + 65, 200, 50, couleurBouton, "Options"),
  new Bouton(300, POS_MENU + 65*2, 200, 50, couleurBouton, "Quitter")
};

Bouton[] BoutonOption = {
  new Bouton(300, 400, 50, 50, couleurBouton, "+"),
  new Bouton(400, 400, 50, 50, couleurBouton, "-"),
  new Bouton(300, 500, 150, 50, couleurBouton, "Retour")
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
color couleurTitre = blanc;
color couleurFond = color(31, 31, 31);

color[] couleurLignes = {
  color(255, 50, 50), 
  color(50, 255, 100), 
  color(255, 255, 50), 
  color(50, 200, 255), 
  color(200, 50, 255), 
  color(255, 120, 40), 
  color(255, 60, 160), 
  color(0, 255, 255),
  color(255, 0, 200),
  color(255, 0, 200)
};

boolean[] touched = new boolean[10]; 
float fact = 1;
Joueur joueur1= new Joueur(2, 1);
String titreChanson;
ArrayList<Notes> touche = new ArrayList<>();
ArrayList<Notes> active = new ArrayList<>();
ArrayList<Notes> notesToRemove = new ArrayList<>();


float posY = 400;
float posX = 100;
float tailleFont = 0;
float opacitiy = 0;
boolean animating = true;
ArrayList<String> animationQueue = new ArrayList<String>();
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


///SETUP
void setup() {
  size(900, 700);  
  textAlign(CENTER, CENTER);
  noFill();
  println("Framerate: " + frameRate);
  for(int i=0; i < Serial.list().length; i++){
    println("Port" + i + ": " + Serial.list()[i]);
  }

  if(Serial.list().length>0){
    try{
      myPort = new Serial(this, "COM8", 9600);
      println("Connection au port: " + Serial.list()[0]);
      float tempo1 = (1/(frameRate/TEMPO))*1000;
      println("temp: " + tempo1);
      myPort.write(str(tempo1));
    } catch (Exception e) {
      println("Erreur : Le port " + Serial.list()[0] + " est déjà utilisé ou inaccessible.");
    }
  }else{
    println("pas d'instrument connecte");
  }
  Partition partition = new Partition("text.abc");
  partition.clean();
  partition.metaData();
  titreChanson = partition.title; 
  active = partition.lecture();
}


///DRAW
void draw() {
  background(couleurFond);

  if (!animationQueue.isEmpty()) {
    animation(animationQueue.get(0));
  }

  menuePrincipal();

  if (ecranActif == 1 && noteDetectee >= 0) {
    testKey(noteDetectee);
    noteDetectee = -1;
    framesDepuisDerniereNote = 0; // reset le compteur
  } else {
    framesDepuisDerniereNote++;
    if (framesDepuisDerniereNote >= DELAI_EXTINCTION) {
      resetLigne(); // éteint seulement si silence prolongé
      framesDepuisDerniereNote = DELAI_EXTINCTION; // plafonne pour éviter overflow
    }
  }
}

void animation(String points){
  color couleur = points.equals("+5") ?  vert : rouge;

  if (animating) {
    posY = lerp(posY, 150, 0.3);
    tailleFont = lerp(tailleFont, 30, 0.2);
    opacitiy += 2;
    if (opacitiy > 255) opacitiy = 255;

    fill(couleur, opacitiy);
    textSize(tailleFont);
    text(points, posX, posY);
    noFill();

    // Condition d'arrêt 
    if (abs(posY - 0) < 151 && abs(tailleFont - 30) < 0.5 ) {
      posY = 400;
      posX = 100;
      tailleFont = 0;
      opacitiy = 0;
      animationQueue.remove(0);
    }
  }
}

// Correspondance fréquence → index noteValue (0-7)
// puis → colonne visuelle via lNote
int freqVersColonne(int freq) {
  int[] noteValue = {645, 700, 760, 830, 915, 960, 1110, 1150};
  // Ordre des notes : Do, Ré, Mi, Fa, Sol, La, Si, Do
  // lNote mappe : A=La→6, B=Si→7, C=Do→1, D=Ré→2, E=Mi→3, F=Fa→4, G=Sol→5
  // On reconstruit le mapping fréquence → colonne directement :
  int[] freqVersLigne = {1, 2, 3, 4, 5, 6, 7, 8}; // Do→1, Ré→2, Mi→3, Fa→4, Sol→5, La→6, Si→7, Do→8
  
  for (int i = 0; i < noteValue.length; i++) {
    if (freq > (noteValue[i] - 40) && freq < (noteValue[i] + 40)) {
      return freqVersLigne[i];
    }
  }
  return -1;
}

void serialEvent(Serial p) {
  int val = readUSBPort();
  if (val > 0) {
    frequenceAffichee = val;
    noteDetectee = freqVersColonne(val); // retourne directement 1-8
  }
}

int checkNote() {
  return noteDetectee; // utilise ce qui a déjà été lu
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
    case 82://'r'
      testKey(4);
      break;
  }
}

void testKey(int noteeee){
  touched[noteeee]=true;
  boolean hit=false;
  for (Notes note : touche) {
    if (note.y > FIN_LIGNE - note.r - 25 && note.n==noteeee) {
      note.touched = true;
      hit=true;
      println("toucher");
    }   
  }
}

void keyReleased() {
  resetLigne();

}

void resetLigne(){
  //println("released");
  for (int i = 0; i < touched.length; i++) {
    touched[i] = false;
  }
}

void mousePressed(){
  evenmentBouton();
}

void evenmentBouton(){
  if(ecranActif == MENU){
    // Vérification du bouton "Jouer"
    if(BoutonMenu[0].clic()){
      ecranActif = 1; // Lance le JEU
      println("Lancement du Jeu");
    }
    // Vérification du bouton "Options"
    else if(BoutonMenu[1].clic()){
      ecranActif = 2; // Ouvre les OPTIONS
      println("Ouverture des Options");
    }
    // Vérification du bouton "Quitter"
    else if(BoutonMenu[2].clic()){
      exit(); // Ferme le programme proprement
    }
  } else if(ecranActif == 2){ // Menu Options
    for(int i = 0; i < BoutonOption.length; i++){
        if(BoutonOption[i].clic()){
            if(i == 0) joueur1.dificutle += 1;
            else if(i == 1) joueur1.dificutle -= 1;
            else if(i == 2) ecranActif = 0; // ICI : on repasse à l'écran MENU
        }
    }
}
}



  // ellipse(x, y, 50, 50);  
  
  // x += speedX;
  // y += speedY;

  // if (x > width - 25 || x < 25) {
  //   speedX *= -1;
  // }
  // if (y > height - 25 || y < 25) {
  //   speedY *= -1;
  // }
  // 
  // beginShape();
  // for (int x = 0; x < width; x++) {
  //   float y = height/2 + amplitude * sin(x * TWO_PI / periode);
  //   vertex(x, y);
  // }
  // endShape();
