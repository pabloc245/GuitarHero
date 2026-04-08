 
int readUSBPort(){
    
  int lf = 10;
  
  // Expand array size to the number of bytes you expect:
  byte[] inBuffer = new byte[30];
  myPort.readBytesUntil(lf, inBuffer);

  if (inBuffer != null) {
    String myString = new String(inBuffer);
    myString = trim(myString);
    int myInt= int(trim(myString));
    println(myString);
    return myInt;
  }else{
    return 0;
  }
}