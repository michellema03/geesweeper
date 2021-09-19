int numRows = 10;
int numColumns = 10;
int gooseProb = 25; //percent
color gooseCol = color(83, 203, 207);
color unCol = color(160, 226, 189);
color revCol = color(251, 173, 177);
boolean firstClick = true;
boolean gameOver = false;
PImage goosePic;
boolean cheats = true; //toggle to show geese cells

float cellWidth;
int numCells;
int[][] cellState; //1=goose, 0=safe
int[][] revealed;
color[][] colours;
int[][] numGeese;

void initialValues() {
  textSize(20);
  textAlign(CENTER);
  for (int i=0; i<numRows; i++) {
    for (int a=0; a<numColumns; a++) {
      revealed[i][a] = 0;
      if (random(0, 100)<=gooseProb) {
        cellState[i][a] = 1;
        if (cheats == true)
          colours[i][a] = gooseCol;
        else
          colours[i][a] = unCol;
      } else {
        cellState[i][a] = 0;
        colours[i][a] = unCol;
      }
    }
  }
}

void secretValues() {
  int geese;
  for (int i=0; i<numRows; i++) {
    for (int j=0; j<numColumns; j++) {
      //assign each cell with num of geese around it
      geese = 0;
      for (int a=-1; a<=1; a++) {
        for (int b=-1; b<=1; b++) {
          try {
            if ((a!=0||b!=0) && (cellState[i+a][j+b]==1)) { 
              geese += 1;
            }
          }
          catch(Exception e) {
          }
        }
      }
      numGeese[i][j] = geese;
    }
  }
}

void expansion(int row, int column) {
  for (int a=-1; a<=1; a++) {
    for (int b=-1; b<=1; b++) {
      try {
        if ((a!=0||b!=0) && (cellState[row+a][column+b]==0))
          revealed[row+a][column+b] = 1;
        //if((a!=0||b!=0) && (cellState[row+a][column+b]==0)&&(numGeese[row+a][column+b]==0){
        //  expansion(row+a, column+b); //TOO MUCH RECURSION!!!
      }
      catch(Exception e) {
      }
    }
  }
}

void drawState() {
  stroke(170, 162, 159);
  cellWidth = height/numRows;
  float yVal = height-cellWidth;
  for (int i=0; i<numRows; i++) {
    float xVal = 0;
    for (int a=0; a<numColumns; a++) {
      fill(colours[i][a]);
      if (revealed[i][a]==1)
        fill(revCol);
      square(xVal, yVal, cellWidth);
      xVal += cellWidth;
    }
    yVal -=cellWidth;
  }

  float yVal2 = height-cellWidth;
  for (int i=0; i<numRows; i++) {
    float xVal2 = 0;
    for (int a=0; a<numColumns; a++) {
      fill(232, 56, 144);
      if (revealed[i][a] == 1) {
        text(str(numGeese[i][a]), xVal2+(cellWidth/2), yVal2+(cellWidth/2)+4);
      }
      xVal2 += cellWidth;
    }
    yVal2 -=cellWidth;
  }
}

void setup() {
  frameRate(30);
  size(800, 800);
  goosePic = loadImage("honk.jpeg");
  cellState = new int[numRows][numColumns];
  colours = new color[numRows][numColumns];
  revealed = new int[numRows][numColumns];
  numGeese = new int[numRows][numColumns];
  initialValues();
  secretValues();
}

void draw() {
  if (gameOver == false)
    drawState();
}

void mouseClicked() {
  int[] whichCell = whichCell(mouseX, mouseY);
  int cellX = whichCell[0];
  int cellY = whichCell[1];
  if (firstClick == true) {
    cellState[cellX][cellY] = 0;
    secretValues();
    firstClick = false;
  } else if (cellState[9-cellY][cellX] == 1) { //lol same logic
    gooseBomb();
  }
  if (cellState[9-cellY][cellX] == 0) {
    revealed[9-cellY][cellX] = 1; //since in the arrays y was subtracted
  }
  if (numGeese[9-cellY][cellX] == 0) {
    expansion(9-cellY, cellX); //recursion
  }
}

int[] whichCell(int x, int y) {
  int xNum = 0;
  int yNum = 0;
  int[] answer;
  for (int i=1; i<10; i++) {
    for (int j=1; j<10; j++) {
      if (0<(x-(i*80))&&(x-(i*80))<(i*80))
        xNum = i;
      if (0<(y-(j*80))&&(y-(j*80))<(j*80)) //REDO THIS MATH
        yNum = j;
    }
  }
  answer = new int[] {xNum, yNum};
  return answer;
}

void gooseBomb() {
  gameOver = true;
  fill(107, 123, 232);
  square(0, 0, 800);
  fill(251, 173, 177);
  textSize(80);
  text("HONK!", width/2, 660);
  image(goosePic, 150, 100);
}
