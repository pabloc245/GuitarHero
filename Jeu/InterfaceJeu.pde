void dessinerJeu(){
        
    println(touche.size());
    for (Notes note : touche) {
        if (note.move()) {
            notesToRemove.add(note);
        }   
    }
    touche.removeAll(notesToRemove);
    notesToRemove.clear();

    if(frameCount%32==0){
       touche.add(new Notes(LIGNESX, touche, int(random(3))));
    }
}