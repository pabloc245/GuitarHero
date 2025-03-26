class Notes{
    ArrayList<Notes> touche;
    float y=LIGNESX;
    float x;
    float w = 20;
    float h = 20;
    boolean touched;
    int n;
    Notes(float x, ArrayList<Notes> touche, int n){
        this.n = n;
        this.x = x*n;
        this.touche = touche;
        println("New note");
    }
    boolean move(){        
        if(y < FIN_LIGNE){
            y += VITESSE;
            if(!touched){
                noFill();
            }else{
                fill(204, 102, 0);
            }
            rect(x, y, w, h);
            noFill();
            return false;
        }else{
            return true;
        }
    }

}
