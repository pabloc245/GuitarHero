class Notes{
    float y = START_Y;
    float x = LIGNESX;
    float r = RAYON;
    boolean touched;
    int n;
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
        this.n = lNote[n-65];
        this.x = n * START_X;
    }
    double easeInSine(float x){
        return 1 - Math.pow(1 - x, 4);
      
    }

    boolean move(){     
        if(y < FIN_LIGNE - MAX_RAYON * 0.6){
            float centre = 500;
            x = f(y, n);
            r += r < MAX_RAYON ?  0.1 : 0;
            y += (y+80) / FIN_LIGNE * 3;


            if(!touched){
                noFill();
            }else{
                fill(rouge);
            }
            ellipse(x, y, r, r*0.6);

            noFill();
            return false;
        }else{
            println("delete");
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
            print(this.duree+" ");
        }
        
    }

}
