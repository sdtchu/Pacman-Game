// PA4_sChu.pde
// Seth Chu
// 4/12/2022
// COMP 101
// li22854@umbc.edu*
// The player can move pacman with the arrow keys or WASD to eat dots,
// scoring points. If Pacman eats all dots, the game ends and 
// the player wins. The ghost chases Pac-Man and, if they catch 
// Pacman, the game ends and the player loses.
 
//variables
//declares pacman size and starting coordinates
float pacmanX = 600;
float pacmanY = 250;
final float PACMAN_SIZE = 70;
float pacMove = 5;

//declares ghost size, a random are for the ghost to be in and the ghost speed and body parts
PShape ghost, body, head, p1, p2, p3, eyeR, eyeL, pupR, pupL;
float GHOST_SIZE = 70;
float ghostX = random(200, 1000);
float ghostY = random(100, 400);
float move = 1;

//declares number of dots and the score
int numOfDots = 50;
int score = 0;
float[] xDotPos = new float[numOfDots];
float[] yDotPos = new float[numOfDots];
float dotSizes = 5;

void setup() {
  //set canvas size and color
  size(1200, 500);
  background(0);
  frameRate(60);
  noStroke();
  assignDotPositions();
}

void draw() {
  if (score <= 50){
    background(0);
    
    //draws pacman
    drawPacman();
    //move Pacman
    movePacman();
    
    //draws ghost and sets bounds
    drawGhost();
    
    //draws dots
    drawDots();
    
    //shows the score on top left of screen
    fill(255, 0 , 0);
    textSize(40);
    text("Score: ", 1000, 40);
    text(score, 1150, 40);
    winOrLose();
  }
}

//DrawPacman - draws a packman a the given x, y
void drawPacman() {
  fill(255, 255, 0);
  arc(pacmanX, pacmanY, PACMAN_SIZE, PACMAN_SIZE, radians(50), radians(320));
}

//Moves pacman when WASD or arrow keys are pressed
void movePacman(){
  pacmanBounds();
  makePacmanWrap();
  if (keyPressed || key == CODED){
    if (key == 'w' || keyCode == UP){
      pacmanY -= pacMove;
    } else if (key == 's' || keyCode == DOWN){
      pacmanY += pacMove;
    } else if (key == 'a' || keyCode == LEFT){
      pacmanX -= pacMove;
    } else if (key == 'd' || keyCode == RIGHT){
      pacmanX += pacMove;
    }
  }
}

//pacmanBounds - does not let pacman go past the upper and lower limits of the window
void pacmanBounds() {
  if (pacmanY > height - PACMAN_SIZE/2){    
    pacmanY = height - PACMAN_SIZE/2;
  } else if (pacmanY < PACMAN_SIZE/2){
    pacmanY = PACMAN_SIZE/2;
  }
}

//makePacmanWrap - puts pacman on left when it reaches right & vice versa
void makePacmanWrap() {
  if(pacmanX == width + PACMAN_SIZE/2){
    pacmanX = 0;
  } else if(pacmanX < 0){
    pacmanX = width;
  }
}

//drawGhost - draws all aspects of the ghost (body, eye whites, pupils, optional skirt)
void drawGhost(){
  ghost = createShape(GROUP);
  
  //creates 'body' to put in 'ghost' group; body is just a rect
  rectMode(CENTER);
  body = createShape(RECT, 0, 0, GHOST_SIZE, GHOST_SIZE/2);
  body.setFill(#2F21CE);
  
  //creates top arc
  ellipseMode(CENTER);
  head = createShape(ARC, 0, -17.3, GHOST_SIZE, GHOST_SIZE, PI, TWO_PI);
  head.setFill(#2F21CE);
  
  //creates tentacles
  p1 = createShape(TRIANGLE, -GHOST_SIZE/2, 17, -GHOST_SIZE/2, 42, (-GHOST_SIZE/2)+20, 17);
  p1.setFill(#2F21CE);
  p2 = createShape(TRIANGLE, (-GHOST_SIZE/2)+20, 17, (-GHOST_SIZE/2)+35, 42, (-GHOST_SIZE/2)+50, 17);
  p2.setFill(#2F21CE);
  p3 = createShape(TRIANGLE, (-GHOST_SIZE/2)+50, 17, (-GHOST_SIZE/2)+70, 42, (-GHOST_SIZE/2)+70, 17);
  p3.setFill(#2F21CE);
  
  //creates eyes
  eyeL = createShape(ELLIPSE, -17, -15, 20, 20);
  eyeL.setFill(255);
  eyeR = createShape(ELLIPSE, 17, -15, 20, 20);
  eyeR.setFill(255);
  
  //creates pupils in eye
  pupR = createShape(ELLIPSE, -17, -15, 10, 10);
  pupR.setFill(#2F21CE);
  pupL = createShape(ELLIPSE, 17, -15, 10, 10);
  pupL.setFill(#2F21CE);  
  
  addParts();

  moveGhost();
}

//adds shape to the pShape ghost
void addParts(){
  //Adds body, tentacles, eyes, and head to 'ghost' group
  ghost.addChild(body);
  ghost.addChild(head);
  ghost.addChild(p1);  
  ghost.addChild(p2);  
  ghost.addChild(p3);
  ghost.addChild(eyeR);
  ghost.addChild(eyeL);
  ghost.addChild(pupL);
  ghost.addChild(pupR);
}

void moveGhost(){
  shape(ghost, ghostX, ghostY);  
  
  //moves ghost towards where pacman is
  if (ghostX > pacmanX - PACMAN_SIZE/2){
    ghostX -= move;
  }
  if (ghostX < pacmanX + PACMAN_SIZE/2){
    ghostX += move;
  }
  if (ghostY > pacmanY + PACMAN_SIZE/2){
    ghostY -= move;
  }
  if (ghostY < pacmanY - PACMAN_SIZE/2){
    ghostY += move;
  }
  
  //sets bounds for the ghost
  if (ghostX >= width - 70){
    ghostX = width - 70;
  } else if(ghostX < 0){
    ghostX = 0;
  } else if (ghostY >= height - 60) {
    ghostY = height - 60;
  } else if(ghostY <= 35){
    ghostY = 35;
  }else{
    shape(ghost, ghostX, ghostY);
  }
}

void assignDotPositions(){
  //assigns the x and y coordinates for each of the 50 dots
  for (int i = 0; i < 50; i++){
    xDotPos[i] = random(10, 1199);
    yDotPos[i] = random(10, 499);
  }
}

void drawDots(){
  //draws dots/makes dots disappear when pacmanX & pacmanY == xDotPos[i] & yDotPos[i]
  fill(255);
  for (int i = 0; i < 50; i++){
    ellipse(xDotPos[i], yDotPos[i], dotSizes, dotSizes);
    float dist = sqrt((pacmanX - xDotPos[i]) * (pacmanX - xDotPos[i]) + (pacmanY - yDotPos[i]) * (pacmanY - yDotPos[i]));
    if (dist <= 35){  
      xDotPos[i] = -100;
      yDotPos[i] = -100;
      numOfDots -= 1;
      score += 1;
    }
  }
}

//If the ghost is within dist of pacman then the game is over, if the score is greater than 50 or equal to 50 then you win
void winOrLose(){
  float dist = sqrt((pacmanX - ghostX) * (pacmanX - ghostX) + (pacmanY - ghostY) * (pacmanY - ghostY));
  if(dist <= PACMAN_SIZE){
    background(0);
    fill(255);
    textSize(90);
    text("that thang is not thangin", (width/4)-150, height/2);
    pacmanX = ghostX;
    pacmanY = ghostY;
  } else if (score >= 50){
    background(0);
    fill(255);
    textSize(120);
    text("you got a fat booty!", (width/4)-150, height/2);
    pacmanX = width;
    pacmanY = height;
  }
}
