int x = 50;
int y = 50;
int speedX = 2;
int speedY = 2;

void setup() {
  size(400, 400);  // Taille de la fenêtre
}

void draw() {
  background(255);  // Efface l'écran à chaque frame
  ellipse(x, y, 50, 50);  // Dessine un cercle de diamètre 50 pixels

  // Met à jour la position du cercle
  x += speedX;
  y += speedY;

  // Change la direction du mouvement lorsque le cercle atteint les bords
  if (x > width - 25 || x < 25) {
    speedX *= -1;
  }
  if (y > height - 25 || y < 25) {
    speedY *= -1;
  }
}
