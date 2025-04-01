class Notes{
    float y = LIGNEY;
    float x = LIGNESX;
    float w = W_RECT;
    float h = H_RECT;
    boolean touched;
    char n;
    int octave = 1;
    int alteration = 0;// 1 = #(diese); 2 = xb(bemol)
    float duree =1;
    

    Notes(float x){
        this.n = n;
    }
    Notes(char n, int octave, float duree, int alteration){
        this.octave = octave;
        this.duree = duree;
        this.alteration = alteration;
        this.n = n;
        this.x = (n-64)*x;
        this.h = h*duree;
    }

    boolean move(){     
        if(y < FIN_LIGNE){
            y += VITESSE;

            pushMatrix(); // Sauvegarde l'état graphique
            pushStyle(); 
            if(!touched){
                noFill();
            }else{
                fill(204, 102, 0);
            }
            rect(x, y, w, h);

            popStyle();   // Restaure les attributs de style
            popMatrix();  

            noFill();
            //println("Note: " + n + " x: "+ x + " y: " + y );
            //println();
            return false;
        }else{
            return true;
        }
    }

    void printN(){
        String s;
        // A : La
        // B : Si
        // C : Do
        // D : Re
        // E : Mi
        // F : Fa
        // G : Sol
        
        if(n=='A' || n=='a'){
            s="La";
        }else if(n=='B'|| n=='b'){
            s="Si";
        }else if(n=='C'|| n=='c'){
            s="Do";
        }else if(n=='D' || n=='d'){
            s="Re";
        }else if(n=='E' || n=='e'){
            s="Mi";
        }else if(n=='F' || n=='f'){
            s="Fa";
        }else if(n=='G' || n=='g'){
            s="Sol";
        }else{
            s=str(n);
        }
        
        if(alteration>0){
            print("#"+this.duree+s+" ");
        }else if(alteration<0){
            print(this.duree+s+"b"+" ");
        }else{
            print(this.duree+s+" ");
        }
        
        //println();
    }

}
