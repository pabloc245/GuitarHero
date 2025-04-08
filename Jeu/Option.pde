void dessinerOptions(){
    textSize(45);
    fill(blanc);
    text(str(joueur1.dificutle),height/2, width/2);
    for(int i = 0; i < BoutonOption.length; i++){
        BoutonOption[i].dessiner();
    }    
}