int[] board;
int[][] isLegal ;
int avail, tour, scoreN, scoreB, ia ;
boolean over, pass, hint ;
PFont fontBig, fontSmall;

Wthor wthor;

void setup() {
  size(500, 560);
  frameRate(100);
  fontBig = loadFont("Present-Bold-30.vlw");
  fontSmall = loadFont("Calibri-14.vlw");
  textAlign(CENTER, CENTER);
  hint = true;
  wthor = new Wthor("wthor/WTH_2018.wtb");
  newGame();
}

void draw() {
  if (drawBoard()==0) {
    tour=3-tour;
    if (drawBoard()==0) {
      over = true ;
    }
    if (ia<3) pass=true;
    drawBoard();
  }
  if ((tour==ia || ia==3) && !over && !pass) {
    iaPlay();
  }
}

void mouseReleased() {
  int x, y;
  if (!over) loop();
  if (!over && !pass) {
    x = (mouseX-10)/60;
    y = (mouseY-50)/60;
    if (x>=0 && x<8 && y>=0 && y<8 && mouseX>10 && mouseY>50 && mouseX<490 && mouseY<530) {
      int c = play(x, y, tour, false);
      if (c>0) {
        play(x, y, tour, true);
        pass=false;
        tour=3-tour;
      }
    }
  } else if (over) {
    newGame();
  } else {
    pass=false;
  }
}

void keyReleased() {
  switch(key) {
  case 'h' :
  case 'H' : 
    hint=!hint; 
    break;
  case 'n' :
  case 'N' : 
    newGame();
    break;  
  case 'q' :
  case 'Q' : 
    exit();
  case '0' :
  case '1' :
  case '2' :
  case '3' :
    ia=Integer.parseInt(key+"");
    loop();
    break;
  }
}
void newGame() {
  board = new int[64];
  for (int i=0; i<4; i++) board[27+floor(i/2)+8*(i%2)]=1+(i/2+i%2)%2;
  tour = 2; // Noir commence toujours !!!
  over = pass = false;
  loop();
}
int play(int x, int y, int c, boolean p) {
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
    if (p) board[x+8*y]=c;
    return cpt;
  }
void iaPlay() {
  final float coefPOS = 2 ;
  final float coefGAIN = 1 ;
  final float coefRANDOM = 0.1 ;
  int[] S = {20, -3, 11, 8, 8, 11, -3, 2, -3, -7, -4, 1, 1, -4, -7, -3, 11, -4, 2, 2, 2, 2, -4, 11, 8, 1, 2, -3, -3, 2, 1, 8, 8, 1, 2, -3, -3, 2, 1, 8, 11, -4, 2, 2, 2, 2, -4, 11, -3, -7, -4, 1, 1, -4, -7, -3, 20, -3, 11, 8, 8, 11, -3, 20};
  int c = 0;
  for (int i=0; i<avail; i++) {
    if (S[isLegal[i][0]]*coefPOS+isLegal[i][1]*coefGAIN+random(20)*coefRANDOM>S[isLegal[c][0]]*coefPOS+isLegal[c][1]*coefGAIN) c=i;
  }
  int y = int(isLegal[c][0]/8);
  int x = int(isLegal[c][0]%8);
  play(x, y, tour, true);
  pass=false;
  tour=3-tour;
  loop();
}
int drawBoard() {
  noLoop();
  if (over) {
    fill(0, 180);
    rect(60, height/2-40, width-120, 120);
    fill(255);
    textFont(fontBig);
    switch(int(Math.signum(scoreB-scoreN))) {
    case 0 : 
      text("Match Nul !", width/2, height/2); 
      break;
    case 1 : 
      text("Les Blancs gagnent", width/2, height/2); 
      break;
    case -1 :  
      text("Les Noirs gagnent", width/2, height/2); 
      break;
    }
    fill(200);
    textFont(fontSmall);
    text("Cliquez pour rejouer", width/2, height/2+30);
    return 1;
  } else if (pass) {
    fill(0, 180);
    rect(60, height/2-60, width-120, 120);
    fill(255);
    textFont(fontBig);
    switch(tour) {
    case 2 : 
      text("Les Blancs passent", width/2, height/2); 
      break;
    case 1 :  
      text("Les Noirs passent", width/2, height/2); 
      break;
    }
    return 1;
  } else {
    scoreN = 0;
    scoreB = 0;
    avail = 0;
    isLegal = new int[64][2];
    background(145, 127, 127);
    stroke(1);
    textFont(fontSmall);
    for (int i=0; i<8; i++) {
      for (int j=0; j<8; j++) {
        fill(0, 90, 20);
        rect(i*60+10, j*60+50, 60, 60);
        switch(board[i+8*j]) {
        case 1 : 
          fill(255); 
          ellipse(i*60+40, j*60+80, 50, 50); 
          scoreB++; 
          break;
        case 2 : 
          fill(10); 
          ellipse(i*60+40, j*60+80, 50, 50); 
          scoreN++ ; 
          break;
        default : 
          int sc = play(i, j, tour, false);
          if (sc>0) {
            fill(255-245*(tour-1));
            if (hint) {
              //ellipse(i*60+40, j*60+80, 10, 10);
              text((i+1)*10+j+1, i*60+40, j*60+80);
            }
            isLegal[avail][0] = i+j*8;
            isLegal[++avail][1] = sc;
            //avail++;
          }
        }
      }
    }
    fill(255);
    textFont(fontSmall);
    text("Keys <N> New  |  <H> Hints  |  <0> H-H  |  <1> C-H  |  <2> H-C  |  <3> C-C  |  <Q> Quit", width/2, height-18);
    textFont(fontBig);
    text("O T H E L L O", width/2, 18);
    ellipse(25, 25, 30, 30); 
    String p = (ia==0 || ia==2)?"H":"C";
    text(p+" : "+scoreB, 90, 20);
    fill(10); 
    ellipse(width-25, 25, 30, 30); 
    p = (ia==0 || ia==1)?"H":"C";
    text(p+" : "+scoreN, width-90, 20);
    fill(127, 0, 0);
    ellipse(25+(tour-1)*(width-50), 25, 12, 12);
    return avail;
  }
}