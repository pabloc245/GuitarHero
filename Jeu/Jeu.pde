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

final int NB_NOTES = 8;
final float TEMPO = 30;
final int[] lNote = {6, 7, 1, 2, 3, 4, 5};

//music
//Minim minim = new Minim(this);

// 2. VARIABLES D'ÉTAT GÉNÉRALES
int[] noteValue = {262, 294, 330, 349, 392, 440, 494, 523}; 
int ecranActif = MENU;
boolean partieEnCours = false;

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
  new Bouton(400, 400, 50, 50, couleurBouton, "-")
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
      myPort = new Serial(this, Serial.list()[0], 9600);
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

  if(newNote != lastNote){
    println("new: "+ newNote);
    println("last: "+ lastNote);
    resetLigne();
    lastNote = newNote;
    println("ne note");
  }
  //musiqueFond();
  
  if(!animationQueue.isEmpty()){
    animation(animationQueue.get(0));
  }
  menuePrincipal();
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

void serialEvent(Serial p){
  String[] strNote = {"DO","RE","MI","FA","SOL","LA","SI","DO"};
  int val = checkNote();
  newNote = val > 0 ? val : newNote;
  if(ecranActif == 1){
    testKey(newNote);
    //println(StrNote[newNote]);/// affichage de verification 
  }else if(ecranActif==0){
    ecranActif = newNote < 3 ? newNote : 0;
    //println("ecran: " + i);
  }else if(ecranActif==2){
    println("c'est bien");
  }

}

int checkNote(){
  int val = readUSBPort(); 
  if(val > 0){
    for (int i = 0; i < noteValue.length; i++) {
      float note = noteValue[i];
      
      if (val > (note - 10) && val < (note + 10)) {
        return i;
      }
    } 
  }
  return -1;
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
  int numeroBouton;
  if(ecranActif==0){
    for(int i=0; i < BoutonMenu.length; i++){
      ecranActif = BoutonMenu[i].clic() ? i : ecranActif;
    }
    println("Bouton" + ecranActif);
  }else if(ecranActif==2){
    for(int i=0; i < BoutonOption.length; i++){
      if(BoutonOption[i].clic() && i == 0){
        joueur1.dificutle += 1;
        println("bouton");
      }else if(BoutonOption[i].clic() && i == 1){
        joueur1.dificutle -= 1;
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
