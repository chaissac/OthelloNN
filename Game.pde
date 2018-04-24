class Game {
  // une partie
  int winner ;
  int scoreN, scoreB ;
  int[] move ;
  int[][] boards ;
  int tour ;
  int nbCoups ;

  Game() {
    boards = new int[60][64];
    move = new int[60];
    for (int i=0; i<4; i++) boards[0][27+floor(i/2)+8*(i%2)]=1+(i/2+i%2)%2;
    scoreN=0;
    scoreB=0;
    winner=0;
    tour=2;
    nbCoups = 0;
  }
  void move(int m) {
    move[nbCoups]=m;
    if (m>0) {
      tour = play(nbCoups, floor(m/10), m % 10, tour, true);
      nbCoups++;
    } else {
      for (int b : boards[nbCoups]) {
        scoreN+=(b==2)?1:0;
        scoreN+=(b==1)?1:0;
      }
      if (scoreN>scoreB) {
        winner = 2;
      } else if (scoreB>scoreN) {
        winner = 1;
      } else winner = 0;
    }
  }
  int play(int b, int x, int y, int c, boolean p) {
    int[] board = boards[b].clone();
    int cpt = 0 ;
    for (int i=-1; i<2; i++) 
      for (int j=-1; j<2; j++) 
        if (i!=0 || j!=0) 
          if ((x+i)>=0 && (x+i)<8 && (y+j)>=0 && (y+j)<8) 
            if (board[x+i+8*(y+j)]==3-c) 
              for (int k=2; k<8; k++) 
                if ((x+i*k)>=0 && (x+i*k)<8 && (y+j*k)>=0 && (y+j*k)<8) {
                  if (board[x+i*k+8*(y+j*k)]<=0) break;
                  if (board[x+i*k+8*(y+j*k)]==c) {
                    if (p) {
                      for (int l=k-1; l>0; l--) board[x+i*l+8*(y+j*l)]=c;
                      cpt+=k-1;
                    } else cpt++;
                    break;
                  }
                } else break ;
    if (p) {
      board[x+8*y]=c;
      boards[b+1]=board;
    }
    return cpt;
  }
}