class Wthor {
  // une classe pour lire les fichiers THOR (base WTHOR) en .wtb, voir rép wthor du projet pour les fichiers + la doc du format
  int nb ;
  byte[] b;
  Wthor(String file) {
    b = loadBytes(file);
    if (b.length<16) exit();
    int taille = readByte(12);
    int type = readByte(13);
    if (taille!=8 || type!=0) exit();
    int nb = readInt(4);
    if (b.length<68*nb+16) exit();
  }
  Game readGame(int n) {
    Game g = new Game();
    if (n<0 || n>=nb) return g;
    int index = 16+(n*68) ;
    for (int j=0; j<60; j++) {
      g.move(readByte(index+8+j));
    }
    return g;
  }
  void debug() {
    println("Lu : "+b.length+" octets");
    println("Date de création : " + readDate(0));
    println("N1 : " + readInt(4));
    println("N2 : " + readWord(8));
    println("Année : "+readWord(10));
    println("Taille : "+readByte(12));
    println("Type : "+readByte(13));
    println("Profondeur : "+readByte(14));
    println("Reservé : "+readByte(15));
    int index = 16;
    for (int i=0; i<nb; i++) {
      println("****** Partie N° "+(i+1)+" - "+index+" ********");
      println("Tournoi : " + readWord(index) + " / Joueur N : "+readWord(index+2)+ " / Joueur B : "+readWord(index+4));
      println("Score réel : "+readByte(index+6)+" / théorique : "+readByte(index+7));
      for (int j=0; j<60; j++) {
        print("#"+(j+1)+" : "+readByte(index+8+j)+" / ");
      }
      println("\n*********************************");
      index+=68;
    }
    println("*** FIN "+index+" *****");
  }
  String readDate(int i) {
    return readByte( i+3)+"/"+readByte(i+2)+"/"+readByte(i)+readByte(i+1);
  }
  int readWord(int i) {
    return readByte(i) + readByte(i+1) * 256 ;
  }  
  int readInt(int i) {
    return readByte(i) + readByte(i+1) * 256 + readByte(i+2) * 256 * 256 + readByte(i+3) * 256 * 256 * 256 ;
  }
  int readByte(int i) {
    return (int) b[i] &0xff ;
  }
}