void dessinerJeu(){

    if(frameCount%32==0){
        
        if(active.size()-1 > z){
            z++;
            touche.add(active.get(z)); 
            println(z);
        }else{
            println("fin de la mElodie");
            ecranActif = 0;
        }        
    }
   
    for(int i = 0; i < touche.size(); i++){
        Notes note = touche.get(i);
        if (note.move()) {
            notesToRemove.add(note);
        }   
    }
    touche.removeAll(notesToRemove);
    active.removeAll(notesToRemove);
    notesToRemove.clear();
    
    
}