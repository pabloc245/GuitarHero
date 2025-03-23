class Rectangle{

    boolean vie = true;
    float x = DEPART_LIGNE;
    float y,w,h;
    Rectangle(float y, float w, float h){
        this.y = y;
        this.w = w;
        this.h = h;
    }
    void move(){
        
        if(x < FIN_LIGNE){
            x += 5;
        }else{
            vie = false;
        }
        rect(x, y, w, h);
    }
}