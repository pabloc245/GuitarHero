class Notes{
    float y=LIGNESX;
    float x;
    float w = 20;
    float h = 20;
    boolean touched;
    char n;
    int octave = 1;
    int alteration = 0;// 1 = #(diese); 2 = xb(bemol)
    float duree=1;
    

    Notes(float x){
        this.n = n;
    }
    Notes(char n, int octave, float duree, int alteration){
        this.octave = octave;
        this.duree = duree;
        this.alteration = alteration;
        this.n = n;
    }
    boolean move(){        
        if(y < FIN_LIGNE){
            y += VITESSE;
            if(!touched){
                noFill();
            }else{
                fill(204, 102, 0);
            }
            rect(x*n, y, w, h);
            noFill();
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
