int x = 50;
int y = 50;
int speedX = 2;
int speedY = 2;
Joueur joueur1;
float amplitude = 50;
float periode = 50;
Bouton bouton1 = new Bouton(100, 100, 250, 150, color(0,255,0), "text");


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

  bouton1.dessiner();

  beginShape();
  for (int x = 0; x < width; x++) {
    float y = height/2 + amplitude * sin(x * TWO_PI / periode);
    vertex(x, y);
  }
  endShape();
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
  if(bouton1.clic()){
    println("Bouton");
  }
}