int readUSBPort() {
  if (myPort != null && myPort.available() > 0) {
    try {
      // On lit toute la ligne envoyée par l'Arduino jusqu'au saut de ligne
      String message = myPort.readStringUntil('\n');
      if (message != null) {
        message = trim(message); // On nettoie les espaces et caractères invisibles
        if (message.length() > 0) {
          return int(message); // On transforme le texte en nombre
        }
      }
    } catch (Exception e) {
      // En cas d'erreur de lecture, on ne fait rien
    }
  }
  return 0;
}
