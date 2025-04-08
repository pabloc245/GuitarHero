class Joueur{

    final int MAX_VIE= 5;
    int score, niveau;

    Joueur(int score, int niveau){
        this.score = score;
        this.niveau = niveau;
    }
    boolean enVie(){
        if(score > 0){
            // Code si le joueur a des points
        }
        return true;
    }

}