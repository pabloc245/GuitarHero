
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
        println("lecture...");
        int cont = 0;
        listeNote = new ArrayList<>();


        for (int j = start; j < abcLines.length; j++) {
            char[] ca = abcLines[j].toCharArray();
            for (int i = 0; i < ca.length; i++){
                Notes tempNote = null; 
                int alteration = 0; 
                int octave = 0;
                float duree = 1;
                int note; ///Do:1 , Re:2, Mi:3, Fa:4, Sol:5, La:6, Si:7;

                print(ca[i]);
                if(ca[i] >= 'A' && ca[i] <= 'Z'){
                    if(ca[i+1] != ' '){
                        if(ca[abs(i-1)] == '^'){
                            alteration = 1;// #diese
                        }else if(ca[abs(i-1)]=='_'){
                            alteration = 2;// bemol
                        }
                        if(ca[i+1]==','){
                            octave++;
                            if(ca[i+2]==','){
                                octave++;
                            }
                        }
    
                    }else{
                        println(ca[i]-'A'+1);
                        tempNote = new Notes(ca[i]-'A'+1, octave, duree, alteration); // n,  octave, duree,  alteration
                    }
                    
                    
                }else if(ca[i]>='a' && ca[i]<='z'){
                    octave++;
                    if(ca[i+1] !=' '){
                        if(ca[abs(i-1)]=='^'){
                            alteration = 1;// #diese
                        }else if(ca[abs(i-1)]=='_'){
                            alteration = 2;// bemol
                        }
                        if(ca[i+1]==','){
                            octave++;
                        }
    
                    }else{
                        tempNote = new Notes(ca[i]-'a'+1, octave, duree, alteration); // n,  octave, duree,  alteration     
                        
                    }              
                }


                if (tempNote != null) {
                    listeNote.add(tempNote);
                } else {
                    println("pas de note");
                }               
            
            }         
        }

        for (Notes note : listeNote) {
            //println("Tialle: "+listeNote.length());
            note.print();   
        }
        return listeNote;    
    }
}
