
 class Paddle//Paddle class
{
    float x,y,w,h; //positions, width and height

    //Paddle constructor
    Paddle (float paddleX, float paddleY, float paddleWidth, float paddleHeight)  
    {
        //initializations
        x = paddleX;
        y = paddleY;
        w = paddleWidth;
        h = paddleHeight;
    }

    //Displays the paddle
    void display() 
    {
        fill (191,205, 233); //set color
        rect (x, y, w, h); //draw paddle
    }
}

//game class
class Game
{
  boolean gameOn;
  int lScore; //leftScore
  int rScore; //rightScore
  Game()
  {
    lScore=0;
    rScore=0;
  }
  //starting game if mouse is pressed
  void setGameMode()
  {
    if (mousePressed)
    {
      gameOn= true;
    }
  }
  //displaying 
  void displayScore()
  {
    
    text(rScore,width/2+width/5, height/2);
    
    text(lScore,width/2-width/5,height/2);
  }
  void incrementLeftScore()
  {
    lScore+=1;
  }
  void incrementRightScore ()
  {
    rScore+=1;
  }
  void movePaddles(Paddle lPd, Paddle rPd)
  {
    if (mouseX<width/2)
    {
      lPd.y=constrain(mouseY,0,height-lPd.h);
    }
    else
    {
      rPd.y=constrain(mouseY,0,height-rPd.h);
    }
  }
}

//ball class
class Ball
{
  float x,y,d; //center coordinates and diameter of ball
  float xSpeed, ySpeed;
  //constructor
  Ball(float BallX, float BallY, float diameter)
  {
    x=BallX;
    y=BallY;
    d=diameter;
    ySpeed=random(-5,5);
    xSpeed=random(-5,5);
  }
  
  //display method
  void display()
  {
    fill(225,120,100);
    ellipse(x,y,d,d);
  }
  
  void move (Game game)
  {
    game.setGameMode();
    if (game.gameOn)
    {
      x +=xSpeed;
      y +=ySpeed;
    }
  }
  
  void checkWall (Game game)
  {
    //reversing direction if ball hits top or down wall
    if(y-(d/2) < 0 || y+d/2 >height)
    {
      ySpeed*=-1;
      
    }
    
    //restarting game if ball hits left wall
    if(x-(d/2) < 0)
    {
      game.gameOn = false;
      x=width/2;
      y = height/2;
      game.incrementRightScore(); //increase right score
    }
    //restarting game if ball hits right 
    if(x+d/2>width)
    {
      game.gameOn=false;
      x=width/2;
      y= height/2;
      game.incrementLeftScore(); //increase left score
    }
  }
  
  void checkPaddles(Paddle lPd, Paddle rPd)
  {
    if ((x+d/2>=rPd.x && x+d/2<=rPd.x+5 && x-d/2<= (rPd.x+rPd.w) && y+d/2>=rPd.y && y-d/2<=(rPd.y+rPd.h))||
     (x+d/2>=lPd.x && x-d/2<= (lPd.x+lPd.w) && x-d/2>= (lPd.x+lPd.w-5) && y+d/2>=lPd.y && y-d/2<=(lPd.y+lPd.h)))
    {
      xSpeed*=-1;
    }
    
  }
}


Paddle rPd,lPd;
Ball [] ball;
Game game;
void setup()
{
  float pHeight = height/3;
  float pWidth = width/20;
  float diameter = width/25;
  float ballX= width/2;
  float ballY = height/2;
  int noOfBalls =5;
  textSize (width/25);
  fullScreen();
  stroke (0);
  rPd = new Paddle(width-width/20, height/2, pWidth, pHeight);
  lPd = new Paddle(0, height/2, pWidth, pHeight);
  //creating multiple balls
  ball = new Ball[noOfBalls];
  for (int i=0; i<5; i++)
  {
    ball[i]=new Ball (random(0,width) , random (0,height), diameter);
  }
  game= new Game();
}

void draw()
{
  background (0);
  rPd.display();
  lPd.display();
  game.displayScore();
  game.movePaddles(lPd,rPd);
  for (int i=0; i<5; i++)
  {
    ball[i].display();
    ball[i].move(game);
    ball[i].checkWall(game);
    ball[i].checkPaddles(lPd,rPd);
  }
}
