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
        
        switch(n){
            case 'A':
                s="La";
                break; 
            case 'B':
                s="Si";
                break;
            case 'C':
                s="Do";
                break;
            case 'D':
                s="Re";
                break;
            case 'E':
                s="Mi";
                break;
            case 'F':
                s="Fa";
                break;
            case 'G':
                s="Sol";
                break;
            default:
                s="None";
                break;

        }
        
        if(alteration>0){
            print("#"+s+" ");
        }else if(alteration<0){
            print(s+"b"+" ");
        }else{
            print(s+" ");
        }
        
        //println();
    }

}
