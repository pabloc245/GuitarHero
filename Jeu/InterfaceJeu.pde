void dessinerJeu(){
        
    for (Notes note : touche) {
        note.print();
        if (note.move()) {
            notesToRemove.add(note);
        }   
    }
    touche.removeAll(notesToRemove);
    notesToRemove.clear();

    if(frameCount%32==0){
       //touche.add(new Notes(LIGNESX));
    }
}