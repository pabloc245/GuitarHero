class Notes{
    float y=LIGNESX;
    float x;
    float w = 20;
    float h = 20;
    boolean touched;
    int n;
    int octave = 1;
    int alteration = 0;// 1 = #(diese); 2 = xb(bemol)
    float duree=1;
    

    Notes(float x){
        this.n = n;
    }
    Notes(int n, int octave, float duree, int alteration){
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
    void print(){
        String s;
        switch(n){
            case 1:
                s="DO";
                break;
            case 2:
                s="RE";
                break;
            case 3:
                s="MI";
                break;
            case 4:
                s="FA";
                break;
            case 5:
                s="SOL";
                break;
            case 6:
                s="LA";
                break;
            case 7:
                s="SI";
                break;
            default:
                s="None";
                break;

        }
        println(s);
    }

}
