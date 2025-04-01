
//http://trillian.mit.edu/~jc/music/abc/findtune.html


class Partition{
    String filename; // ça peut-être une url
    String title; //T:
    String compositeur; //C:
    String typeTune; //R:
    float[] mesure = {1, 1};//M:
    float[] lNote = {1, 1};//L:
    int start;
    String[] abcLines;
    ArrayList<Notes> listeNote;


    Partition(String filename){
        this.filename = filename;
        this.abcLines = loadStrings("text.abc");
    }

    void clean(){
        StringList filteredLines = new StringList();
        for (String ligne : abcLines) {
            if (!ligne.contains("w:") && !ligne.contains("%") && !ligne.contains("W:")) {
              filteredLines.append(ligne);
            }
            ligne.replaceAll(".*![A-Za-z]+!*.", "");
        }
        
        PrintWriter output = createWriter(filename);
        output.close();
        saveStrings(filename, filteredLines.array());
    }

    void metaData(){
        int i=0; 

        while ( i < abcLines.length-1 && !(abcLines[i].contains("|"))){

            switch(abcLines[i].charAt(0)){
                case 'T':
                    this.title = abcLines[i].replace("T:","");
                    break;
                case 'R':
                    this.typeTune = abcLines[i].replace("R:","");
                    break;
                case 'C':
                    this.compositeur = abcLines[i].replace("C:","");
                    break;
                case 'M':
                    String lineM = abcLines[i].trim();
                    int conc = 0;
                    for (char c : lineM.toCharArray()) {
                        if (c == '/') {
                            conc++;
                        } else if (c >= '0' && c <= '9') { 
                            //println("c: " + c);
                            this.mesure[conc]= c - '0';                                                    
                        }
                        
                    }
                case 'K':
                    String lineK = abcLines[i].trim();
                    conc = 0;
                    for (char c : lineK.toCharArray()) {
                        if (c == '/') {
                            conc++;
                        } else if (c >= '0' && c <= '9') { 
                            this.lNote[conc]= c - '0';                                                    
                        }
                        
                    }
                    break;
            }
            println(i);
            i++;
        }
        start = i;
    }

    ArrayList<Notes> lecture(){
        println("lecture...\n\n\n");
        int cont = 0;
        listeNote = new ArrayList<>();
        ArrayList<Notes> tempListe = new ArrayList<>();
        boolean stop = true;

        for (int j = start; j < abcLines.length; j++) {
            char[] ca = abcLines[j].toCharArray();
            for (int i = 0; i < ca.length; i++){
                Notes tempNote = null; 
                int alteration = 0; 
                int octave = 0;
                float[] duree = {1, 1};
                ///Do:1 , Re:2, Mi:3, Fa:4, Sol:5, La:6, Si:7;

               // print(ca[i]);
                if(ca[i] >= 'A' && ca[i] <= 'G' || ca[i]=='Z'){
                    //Note + Altération + Octave + Durée
                    
                    alteration = alteration(i, ca);
                    octave = octave(i, ca, alteration, octave);
                    time(i, ca, octave, duree);
    
                    println("Note spe: " + ca[i] + ", " + alteration + ", " + octave + ", " + duree[0]/duree[1]);
                    tempNote = new Notes(ca[i], octave, duree[0]/duree[1], alteration);                    


                }else if(ca[i]>='a' && ca[i]<='g' || ca[i]=='Z'){
                    octave++;

                    alteration = alteration(i, ca);
                    octave = octave(i, ca, alteration, octave);
                    //time(i, ca, alteration, octave-1, lNote);
    
                    println("Note spe: " + ca[i] + ", " + alteration + ", " + octave + ", " + duree[0]/duree[1]);
                    tempNote = new Notes(ca[i], octave, duree[0]/duree[1], alteration);     

                }

                if(ca[i]==':'){
                    println("Copie de la liste");
                    listeNote.addAll(tempListe);
                    tempListe.clear();
                    stop = !stop;
                }
                if (tempNote != null) {
                    if(!stop){
                        println("repetition");
                        tempListe.add(tempNote);                            
                    }else{
                        listeNote.add(tempNote);
                    }                    
                }            
            
            }         
        }

        println();
        for (Notes note : listeNote) {
            note.printN();   
        }
        println("\n\n\n\n");
        println("Mesure: "+ mesure[0] + '/' + mesure[1]);
        return listeNote;    
    }


}



int alteration(int i, char[] ca){
    int valAlteration = 0;
    if(i > 0){
        if(ca[i-1] == '^'){

            if(i-1 > 0 && ca[i-2] == '^'){
                valAlteration --;// ##diese
            }
            valAlteration --;// #diese
        }else if(ca[i-1]=='_'){

            if(i-1 > 0 && ca[i-2] == '_'){
            valAlteration ++;// #bbemol
            }            
            valAlteration ++;// bemol
        }
    }
    return valAlteration;
    
}

int octave(int i, char[] ca, int alteration, int octave){

    if(ca[i+1]==','){
        octave--;
        if(ca[i+2]==','){
            octave--;
        }
    }
    if(ca[i+1+alteration]==39){
        octave+=2;
    }
    return octave;
}

void time(int i, char[] ca, int octave, float lNote[]){
    if(i + abs(octave) < ca.length){
        if(ca[i+1+abs(octave)] >= '0' && ca[i+1+abs(octave)] <= '9'){
                lNote[0] = ca[i+1+abs(octave)] - '0';
                if(ca[i+2+abs(octave)] == '/'){
                    lNote[1] = ca[i+3+abs(octave)] - '0';
                }
        }else if(ca[i+1+abs(octave)]=='/' && ca[i+1+abs(octave)] >= '0' && ca[i+1+abs(octave)] <= '9'){
            lNote[1] = ca[i+2+abs(octave)] - '0';
        }
    }
}
