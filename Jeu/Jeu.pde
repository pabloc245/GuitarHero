// 1. DÉCLARATION DES CONSTANTES
final int MENU = 0;

// 2. VARIABLES D'ÉTAT GÉNÉRALES
int ecranActif = MENU;
boolean partieEnCours = false;

// 3. VARIABLES UI REGROUPÉES PAR FONCTION
// Interface Menu
String[] textesBoutons = {"Jouer", "Options", "Quitter"};


// Interface Jeu
Joueur joueur1;

// 4. RESSOURCES



// TEST
int x = 50;
int y = 50;
int ecranActif = 0;
int speedX = 2;
int speedY = 2;
float amplitude = 50;
float periode = 50;


init();

void setup() {
  size(900, 700);  
  background(255);
  noFill();
  stroke(0, 200, 255);
  println(frameRate);

}

void draw() {
  background(255);
  ellipse(x, y, 50, 50);  
  
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




void keyPressed() {
  switch (keyCode) {
    case UP:
      periode += 5;
      break;
    case DOWN:
      periode -= 5;
      break;
  }
}

void mousePressed(){
  // if(bouton1.clic()){
  //   println("Bouton");
  // }
}