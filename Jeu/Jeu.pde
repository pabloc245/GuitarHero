int x = 50;
int y = 50;
int speedX = 2;
int speedY = 2;
Joueur joueur1;


void setup() {
  size(900, 700);  
}

void draw() {
  background(255);  
  ellipse(x, y, 50, 50);  
  joueur1 = new Joueur(255,4);
  
  x += speedX;
  y += speedY;

  if (x > width - 25 || x < 25) {
    speedX *= -1;
  }
  if (y > height - 25 || y < 25) {
    speedY *= -1;
  }
}
