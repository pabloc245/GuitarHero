void dessinerMenu(){
    for(int i = 0; i < BoutonMenu.length; i++){
        BoutonMenu[i].dessiner();
    }
}
void menuePrincipal(){
    switch(ecranActif) {
        case 0:
        dessinerMenu();
        break;
        case 1:
        dessinerJeu();
        break;
        case 2:
        dessinerOptions();
        break;    
    }
}
    