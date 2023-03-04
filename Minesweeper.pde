import de.bezier.guido.*;

//Declare and initialize constants NUM_ROWS and NUM_COLS
public final static int NUM_ROWS = 40;
public final static int NUM_COLS = 40;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS]; //minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean gameover = false;

void setup ()
{
  size(600, 650);
  textAlign(CENTER,CENTER);
  
  // make the manager
  Interactive.make(this);
  
  for(int i = 0; i < buttons.length; i++) {
    for(int j = 0; j < buttons[i].length; j++) {
      buttons[i][j] = new MSButton(i, j);
    }
  }
  
  for(int i = 0; i < (int)(Math.random()*40) + 120; i++) {
    setMines();
  }
}
public void setMines()
{
  int row = (int)(Math.random()*40);
  int col = (int)(Math.random()*40);
  if(!mines.contains(buttons[row][col])) {
    mines.add(buttons[row][col]);
  }
}

public void draw () {
    background(0);
    if(isWon() == true) {
        displayWinningMessage();
        gameover = true;
    }
        
}
public boolean isWon()
{
  for(int i = 0; i < buttons.length; i++) {
    for(int j = 0; j < buttons[i].length; j++) {
      if(mines.contains(buttons[i][j])) {
        if (!buttons[i][j].isFlagged()) 
          return false;
      } else {
        if(!buttons[i][j].isClicked())
          return false;
      }
    }
  }
  return true;
}

public void displayLosingMessage() { 
  for(int i = 0; i < mines.size(); i++) {
    if(!mines.get(i).isClicked()) {
      mines.get(i).mousePressed();
    }
  }
  fill(0);
  rect(0, 600, 600, 50);
  fill(255);
  textSize(20);
  text("You lost!", 300, 625);
}
public void displayWinningMessage() {
  fill(0);
  rect(0, 600, 600, 50);
  fill(255);
  textSize(20);
  text("You won!", 300, 625);
}
public boolean isValid(int r, int c)
{
  return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for(int i = row - 1; i <= row + 1; i++) {
    for(int j = col - 1; j <= col + 1; j++) {
      if(isValid(i, j) && !(i == row && j == col)) {
        if(mines.contains(buttons[i][j])) 
          numMines++;
      }
    }
  }
  return numMines;
}
public class MSButton {
  private int myRow, myCol;
  private float x,y, width, height;
  private boolean clicked, flagged;
  private String myLabel;
  
  public MSButton (int row, int col) {
      width = 600/NUM_COLS;
      height = 600/NUM_ROWS;
      myRow = row;
      myCol = col; 
      x = myCol*width;
      y = myRow*height;
      myLabel = "";
      flagged = clicked = false;
      Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    if(!gameover) {
      clicked = true;
      if(mouseButton == RIGHT) {
        clicked = false;
        flagged = !flagged;
      } else if (mines.contains(this)){
        displayLosingMessage();
        gameover = true;
      } else if (countMines(myRow, myCol) > 0) {
        myLabel = "" + countMines(myRow, myCol);
      } else {
        for(int r = myRow - 1; r <= myRow + 1; r++) {
          for(int c = myCol - 1; c <= myCol + 1; c++) {
            if(isValid(r, c) && !buttons[r][c].clicked && !(r == myRow && c == myCol)) {
              buttons[r][c].mousePressed();
            }
          }
        }
      }
    }
  }
  public void draw() {
    if (flagged)
        fill(0);
    else if( clicked && mines.contains(this) ) {
        displayLosingMessage();
        fill(255,0,0);
    }
    else if(clicked)
        fill( 200 );
    else 
        fill( 100 );

    rect(x, y, width, height);
    fill(0);
    textSize(12);
    text(myLabel,x+width/2,y+height/2);
  }
  public void setLabel(String newLabel) {
      myLabel = newLabel;
  }
  public void setLabel(int newLabel) {
      myLabel = ""+ newLabel;
  }
  public boolean isFlagged() {
      return flagged;
  }
  public boolean isClicked() {
    return clicked;
  }
}

public void keyPressed() {
  if(key == 'r') {
    gameover = false;
    for(int i = 0; i < buttons.length; i++) {
      for(int j = 0; j < buttons[i].length; j++) {
        buttons[i][j] = new MSButton(i, j);
      }
    }
    mines.clear();
    for(int i = 0; i < (int)(Math.random()*40) + 120; i++) {
      setMines();
    }
  }
}
