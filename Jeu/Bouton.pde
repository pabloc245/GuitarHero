class Bouton{
    int x, y, w, h;

    color couleur;
    String txt;

    Bouton(int x, int y, int w, int h, color couleur, String txt){
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.couleur = couleur;
        this.txt = txt;
    }
    void dessiner(){
        stroke(couleur);
        rect(x, y, w, h, 3);
        fill(couleur);
        textSize(int(h*0.7));
        fill(couleur);
        text(txt, x + w/2, y + h/2, couleur);
        noFill();
    }
    boolean clic(){
        
        return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
    }

}