# OPENGL Gems
require 'opengl'
require 'glu'
require 'glut'
require 'serialport'

include Gl,Glu,Glut

# Separating line constants
SEPARATING_LINE_WIDTH = 0.025
SEPARATING_LINE_HEIGHT = 5

# Ball constants
BALL_RADIUS = 0.1
BALL_SEGMENTS = 30

# Player rectangle constants
PLAYER_RECT_WIDTH = 0.1
PLAYER_RECT_HEIGHT = 0.4

# Borders for player 1
BORDER_BACK_1 = -4.5
BORDER_FORWARD_1 = -0.5
BORDER_UP_1 = 2
BORDER_DOWN_1 = -2 

# Borders for player 2
BORDER_BACK_2 = 4.5
BORDER_FORWARD_2 = 0.5
BORDER_UP_2 = 2
BORDER_DOWN_2 = -2 

# Movement steps
STEP = 0.15
BALL_STEP = 0.023

# Constants for calculating data from USB
LEFT_MOVE = 432
RIGHT_MOVE = 592
UP_MOVE = 592
DOWN_MOVE = 432

# Player positions
$player1X = -3.0
$player1Y = 0.0
$player2X = 3.0
$player2Y = 0.0

# Ball position
$ballPositionX = 0
$ballPositionY = 0
$ballDirectionAngle = 0.785

# Players score
$player1Wins = 0
$player2Wins = 0

# Additional consts
CONTACT_DIFFERENCE = PLAYER_RECT_WIDTH*0.5 + BALL_RADIUS
HEIGHT_DIFFERENCE = PLAYER_RECT_HEIGHT*0.5 + BALL_RADIUS
TOTAL_WINS = 3

$connection = SerialPort.open("/dev/ttyArduino")

serialPort = Thread.new {
    # Flushing input buffer before using
    if($connection.flush_input == false)
        puts 'Error: flush_input'
    end

    while true
        lineIn = $connection.gets.to_s

        coordinatesReceived = lineIn.split(';')
        #puts "#{coordinatesReceived[1]}  #{coordinatesReceived[2]}  #{coordinatesReceived[4]}  #{coordinatesReceived[5]} "
        if coordinatesReceived.size == 0
            next
        end

        # Move first player
        if coordinatesReceived[1].to_f < LEFT_MOVE && $player1X - STEP >= BORDER_BACK_1
            $player1X -= STEP
        elsif coordinatesReceived[1].to_f > RIGHT_MOVE && $player1X + STEP <= BORDER_FORWARD_1
            $player1X += STEP
        end
        if coordinatesReceived[2].to_f < DOWN_MOVE && $player1Y - STEP >= BORDER_DOWN_1
            $player1Y -= STEP
        elsif coordinatesReceived[2].to_f > UP_MOVE && $player1Y + STEP <= BORDER_UP_1
            $player1Y += STEP
        end

        # Move second player
        if coordinatesReceived[4].to_f < LEFT_MOVE && $player2X - STEP >= BORDER_FORWARD_2
            $player2X -= STEP
        elsif coordinatesReceived[4].to_f > RIGHT_MOVE && $player2X + STEP <= BORDER_BACK_2
            $player2X += STEP
        end
        if coordinatesReceived[5].to_f < DOWN_MOVE && $player2Y - STEP >= BORDER_DOWN_2
            $player2Y -= STEP
        elsif coordinatesReceived[5].to_f > UP_MOVE && $player2Y + STEP <= BORDER_UP_2
            $player2Y += STEP
        end
    
        sleep(0.1)
    end
}

def initialize
    glClearColor(0.0, 0.0, 0.0, 0.0)
    glEnable(GL_DEPTH_TEST)
end

display = Proc.new do
  glClear(GL_COLOR_BUFFER_BIT)

  #Drawing middle separating line 
  glColor(1, 1, 1)
  glBegin(GL_POLYGON)
    glVertex3f(-SEPARATING_LINE_WIDTH, -SEPARATING_LINE_HEIGHT, 0)
    glVertex3f(SEPARATING_LINE_WIDTH, -SEPARATING_LINE_HEIGHT, 0)
    glVertex3f(SEPARATING_LINE_WIDTH, SEPARATING_LINE_HEIGHT, 0)
    glVertex3f(-SEPARATING_LINE_WIDTH, SEPARATING_LINE_HEIGHT, 0)
  glEnd()

  #Drawing player 1 
  glColor(1,0,0)
  glBegin(GL_POLYGON)
    glVertex3f($player1X - PLAYER_RECT_WIDTH, $player1Y + PLAYER_RECT_HEIGHT, 0) # Top left
    glVertex3f($player1X + PLAYER_RECT_WIDTH, $player1Y + PLAYER_RECT_HEIGHT, 0) # Top right
    glVertex3f($player1X + PLAYER_RECT_WIDTH, $player1Y - PLAYER_RECT_HEIGHT, 0) # Bottom right
    glVertex3f($player1X - PLAYER_RECT_WIDTH, $player1Y - PLAYER_RECT_HEIGHT, 0) # Bottom left
  glEnd()

  #Drawing player 2 
  glColor(0,0,1)
  glBegin(GL_POLYGON)
    glVertex3f($player2X - PLAYER_RECT_WIDTH, $player2Y + PLAYER_RECT_HEIGHT, 0) # Top left
    glVertex3f($player2X + PLAYER_RECT_WIDTH, $player2Y + PLAYER_RECT_HEIGHT, 0) # Top right
    glVertex3f($player2X + PLAYER_RECT_WIDTH, $player2Y - PLAYER_RECT_HEIGHT, 0) # Bottom right
    glVertex3f($player2X - PLAYER_RECT_WIDTH, $player2Y - PLAYER_RECT_HEIGHT, 0) # Bottom left
  glEnd()

  #Drawing ball
  glColor(0,1,0)
  glBegin(GL_POLYGON)
    for i in 0...BALL_SEGMENTS do
      theta = 6.28 * i.to_f / BALL_SEGMENTS.to_f
      x = BALL_RADIUS * Math.cos(theta)
      y = BALL_RADIUS * Math.sin(theta)
      glVertex3f($ballPositionX + x, $ballPositionY + y, 0)
    end
  glEnd()

  glColor(1,0,0)
  glRasterPos3f(-1,2.3,0)
  glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24, 48 + $player1Wins);

  glColor(0,0,1)
  glRasterPos3f(1,2.3,0)
  glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24, 48 + $player2Wins);

  glutSwapBuffers()
end

reshape = Proc.new do |w, h|
    glViewport(0, 0,  w,  h)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    gluPerspective(60.0,  w.to_f/h.to_f, 1.0, 20.0)
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
    gluLookAt(0.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
end

animation = Proc.new do |s|

  if $player2Wins == TOTAL_WINS
    sleep(2)
    exit(0)
  end

  if $player1Wins == TOTAL_WINS
    sleep(2)
    exit(0)
  end

  if $ballPositionX <= BORDER_BACK_1 
    $player2Wins += 1
    $ballPositionX = 0
    $ballPositionY = 0
    $ballDirectionAngle = 0.785
  end

  if $ballPositionX >= BORDER_BACK_2 
    $player1Wins += 1
    $ballPositionX = 0
    $ballPositionY = 0
    $ballDirectionAngle = 0.785
  end

  # Contact ball with Player1
  $ballPositionX - BALL_RADIUS - $player1X 
  if ($ballPositionX - $player1X).abs <= CONTACT_DIFFERENCE
    if ($ballPositionY-$player1Y).abs <= HEIGHT_DIFFERENCE
      $ballDirectionAngle = 3.14 - $ballDirectionAngle
    end
  end

  # Contact ball with Player2
  if ($player2X - $ballPositionX).abs <= CONTACT_DIFFERENCE
    if ($ballPositionY-$player2Y).abs <= HEIGHT_DIFFERENCE
      $ballDirectionAngle = 3.14 - $ballDirectionAngle
    end
  end

  if $ballPositionY >= BORDER_UP_1 
    $ballDirectionAngle = 6.28 - $ballDirectionAngle
  end

  if $ballPositionY <= BORDER_DOWN_1 
    $ballDirectionAngle = 6.28 - $ballDirectionAngle
  end


  $ballPositionX += Math.cos($ballDirectionAngle)*BALL_STEP
  $ballPositionY += Math.sin($ballDirectionAngle)*BALL_STEP

  glutPostRedisplay()
  glutTimerFunc(5, animation, 0)
end

keyboard = Proc.new do |key, x, y|
    case (key)
      when ?w
        if $player1Y + STEP <= BORDER_UP_1
            $player1Y += STEP
        end
        glutPostRedisplay()
      when ?s
        if $player1Y - STEP >= BORDER_DOWN_1
            $player1Y -= STEP
        end
        glutPostRedisplay()
      when ?d
        if $player1X + STEP <= BORDER_FORWARD_1
            $player1X += STEP
        end
        glutPostRedisplay()
      when ?a
        if $player1X - STEP >= BORDER_BACK_1
            $player1X -= STEP
        end
        glutPostRedisplay()
      when ?i
        if $player2Y + STEP <= BORDER_UP_2
            $player2Y += STEP
        end
        glutPostRedisplay()
      when ?k
        if $player2Y - STEP >= BORDER_DOWN_2
            $player2Y -= STEP
        end
        glutPostRedisplay()
      when ?l
        if $player2X + STEP <= BORDER_BACK_2
            $player2X += STEP
        end
        glutPostRedisplay()
      when ?j
        if $player2X - STEP >= BORDER_FORWARD_2
            $player2X -= STEP
        end
        glutPostRedisplay()
      when ?x 
        Thread.kill(serialPort)
        exit(0)
    end
end

glutInit
glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB)
glutInitWindowSize(1200, 800)
glutInitWindowPosition(100, 100)
glutCreateWindow($0)
initialize()
glutDisplayFunc(display)
glutReshapeFunc(reshape)
glutKeyboardFunc(keyboard)
glutTimerFunc(5,animation, 0)
glutMainLoop()
