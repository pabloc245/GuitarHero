void dessinerJeu(){

    if(frameCount% (int)(TEMPO*fact) == 0){
        if(!(z+1 > active.size())){
            touche.add(active.get(z)); 
            println("ajout: " + z + active.size());

            if(z+1>  active.size()){
                fact = active.get(z+1).duree;
            }
            

            z++;
        }else{
            println(touche.size());
            if(touche.size() == 0){
                println("fin de la melodie");
                ecranActif = 0;
                z=0;
            }                
        }        
    }
   
    for(Notes note : touche){
        if (note.move()) {
            notesToRemove.add(note);
        }   
    }

    touche.removeAll(notesToRemove);
    notesToRemove.clear();
}