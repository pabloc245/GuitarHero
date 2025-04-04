void dessinerJeu(){
    for(int i = 1; i < 10; i++){
        line(f(0.0, i),
        80 / FIN_LIGNE * 3, 
        f(FIN_LIGNE, i), 
        FIN_LIGNE);
    }
        
    if(frameCount % (TEMPO*fact) == 0){
        if(!(z+1 > active.size())){
            touche.add(active.get(z)); 
            println("ajout: " + z +" "+ "size: " + active.size());

            if(z+1 < active.size()){
                fact = active.get(z+1).duree;
                println("fact2: " + fact);
            }
            
            z++;
        }else{
            if(touche.size() == 0){
                for(Notes note : active){
                    note.y = 0;
                    note.touched = false;
                    note.x = note.n * START_X;;
                }
                touche.clear();
                println("fin de la melodie");
                ecranActif = 0;
                z=0;
            }                
        }        
    }
   
    for(Notes note : touche){
        if (note.move()) {
            notesToRemove.add(note);
            if(note.touche){
                sonNotePastouche();
            }
        }   
    }

    touche.removeAll(notesToRemove);
    notesToRemove.clear();
}

float f(float y, int n){// Pour determiner x
    float offset = START_X +  2*n;
    int milieu = NB_NOTES/2;
    return (y + START_Y) * (n-milieu)/10 + offset;
}