class Bouton{
    int x, y, w, h;

    color Couleur;
    String txt;

    Bouton(int x, int y, int w, int h, color couleur, String txt){
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.Couleur = couleur;
        this.txt = txt;
    }
    void dessiner(){
        rect(x, y, w, h, 10);
        fill(Couleur);
        textSize(int(h*0.7));
        text(txt, x + w/2, y + h/2, couleurBouton);
        noFill();
    }
    boolean clic(){
        return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;   
    }
}