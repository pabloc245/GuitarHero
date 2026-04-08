void dessinerJeu(){
    ///GRAPHIQUE
    strokeWeight(1);
    rect(10, 10, MAX_SCORE, 15, 13);
    fill(blanc, 255);
    rect(11, 10, joueur1.score, 14, 16);
    textSize(15);
    text("Sore: " + joueur1.score, 30, 50);
    for(int i = 1; i < 10; i++){
        if(touched[i]){
            stroke(couleurLignes[i]);
            float r = random(10);
            strokeWeight(r);
        }
        line(f(0.0, i),
        80 / FIN_LIGNE * 3 + START_Y, 
        f(FIN_LIGNE, i), 
        FIN_LIGNE);
        stroke(blanc);  
        strokeWeight(2);
    }
    
    if(titreChanson !=null ){
        textSize(15);
        fill(blanc);
        text("Titre: " + titreChanson, width-(titreChanson.length()+ 7)*4, 25);
        noFill();
    }
    line(200, FIN_LIGNE, 760, FIN_LIGNE); 
    
    
    
    ///GESTION DES NOTES
    if(frameCount % (TEMPO*fact) == 0){
        if(!(z+1 > active.size())){
            touche.add(active.get(z)); 
            println("ajout: " + z +" "+ "size: " + active.size());

            if(z+1 < active.size()){
                fact = active.get(z+1).duree;
            }
            
            z++;
        }else{
            if(touche.size() == 0){
                for(Notes note : active){
                    note.y = 0;
                    note.touched = false;
                    note.x = note.n * START_X;
                    note.r = 10;
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
            if(ecranActif==1){
                if(note.touched){
                  animationQueue.add("+5");
                  joueur1.score+=5;
                }else{
                  if(joueur1.score > 0){
                    joueur1.score -= 5;
                    animationQueue.add("-5");
                  } 
                }
              }
            if(ecranActif==1){
                if(note.touched){
                  animationQueue.add("+5");
                  joueur1.score+=5;
                }else{
                  if(joueur1.score > 0){
                    joueur1.score -= 5;
                    animationQueue.add("-5");
                  } 
                }
              }
        }   
    }

    touche.removeAll(notesToRemove);
    notesToRemove.clear();
}

float f(float y, int n){// Pour determiner x
    float offset = START_X + 2 * n;
    int milieu = NB_NOTES/2;
    return (y + LIGNESX) * (n-milieu)/10 + offset;
}