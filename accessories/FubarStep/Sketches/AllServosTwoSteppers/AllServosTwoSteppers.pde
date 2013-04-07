// MultiStepper.pde
// -*- mode: C++ -*-
//
// Shows how to multiple simultaneous steppers
// Runs one stepper forwards and backwards, accelerating and decelerating
// at the limits. Runs other steppers at the same time
//
// Copyright (C) 2009 Mike McCauley
// $Id: MultiStepper.pde,v 1.1 2011/01/05 01:51:01 mikem Exp mikem $

#include <AccelStepper.h>
#include <SoftPWMServo.h> 

int pos = 1000;         // variable to store the servo position, in microseconds

static int state1 = 0;
static int state2 = 0;

// For Fubarino SD
#if defined(_BOARD_FUBARINO_SD_)
#define M1EN12  7
#define M1EN34  8

#define M1A1    2
#define M1A2    0
#define M1A3    1
#define M1A4    3

#define M2EN12  9
#define M2EN34  10

#define M2A1    5
#define M2A2    6
#define M2A3    11
#define M2A4    4
// SD has all 12 servos hooked up
#define SRV1    12
#define SRV2    13
#define SRV3    14
#define SRV4    15
#define SRV5    16
#define SRV6    17
#define SRV7    18
#define SRV8    19
#define SRV9    20
#define SRV10   21
#define SRV11   22
#define SRV12   23
#endif

// For Fubarino Mini
#if defined(_BOARD_FUBARINO_MINI_)
#define M1EN12  7
#define M1EN34  8

#define M1A1    30
#define M1A2    32
#define M1A3    31
#define M1A4    29

#define M2EN12  9
#define M2EN34  10

#define M2A1    27
#define M2A2    26
#define M2A3    25
#define M2A4    28
// Mini only has 10 servos hooked up
#define SRV1    1
#define SRV2    2
// Note pin 14 and pin 15 are not available if using a crystal (default)
#define SRV3    14
#define SRV4    15
#define SRV5    16
#define SRV6    24
#define SRV7    23
#define SRV8    22
#define SRV9    21
#define SRV10   19
#endif


void motor1output(int state)
{
  switch(state)
  {
    case 0:
      digitalWrite(M1A1,1);
      digitalWrite(M1A2,0);
      digitalWrite(M1A3,1);
      digitalWrite(M1A4,0);      
      break;
      
    case 1:
      digitalWrite(M1A1,1);
      digitalWrite(M1A2,0);
      digitalWrite(M1A3,0);
      digitalWrite(M1A4,1);      
      break;

    case 2:
      digitalWrite(M1A1,0);
      digitalWrite(M1A2,1);
      digitalWrite(M1A3,0);
      digitalWrite(M1A4,1);      
      break;

    case 3:
      digitalWrite(M1A1,0);
      digitalWrite(M1A2,1);
      digitalWrite(M1A3,1);
      digitalWrite(M1A4,0);      
      break;
  }
}

void motor2output(int state)
{
  switch(state)
  {
    case 0:
      digitalWrite(M2A1,1);
      digitalWrite(M2A2,0);
      digitalWrite(M2A3,1);
      digitalWrite(M2A4,0);      
      break;
      
    case 1:
      digitalWrite(M2A1,1);
      digitalWrite(M2A2,0);
      digitalWrite(M2A3,0);
      digitalWrite(M2A4,1);      
      break;

    case 2:
      digitalWrite(M2A1,0);
      digitalWrite(M2A2,1);
      digitalWrite(M2A3,0);
      digitalWrite(M2A4,1);      
      break;

    case 3:
      digitalWrite(M2A1,0);
      digitalWrite(M2A2,1);
      digitalWrite(M2A3,1);
      digitalWrite(M2A4,0);      
      break;
  }
}

void forwardstep1()
{
  state1++;
  if (state1 >= 4)
  {
    state1 = 0;
  }
  motor1output(state1);  
}

void backwardstep1()
{
  state1--;
  if (state1 < 0)
  {
    state1 = 3;
  }  
  motor1output(state1);  
}


void forwardstep2()
{
  state2++;
  if (state2 >= 4)
  {
    state2 = 0;
  }
  motor2output(state2);  
}

void backwardstep2()
{
  state2--;
  if (state2 < 0)
  {
    state2 = 3;
  }
  motor2output(state2);  
}

// Define some steppers and the pins the will use
AccelStepper stepper1(forwardstep1, backwardstep1); 
AccelStepper stepper2(forwardstep2, backwardstep2); 

int TimeForServoChange;
unsigned long LastMillis = 0;


void setup()
{  
    // Set up enable pins to be output, high
    pinMode(M1EN12, OUTPUT);
    pinMode(M1EN34, OUTPUT);
    pinMode(M2EN12, OUTPUT);
    pinMode(M2EN34,OUTPUT);
    digitalWrite(M1EN12, 1);
    digitalWrite(M1EN34, 1);
    digitalWrite(M2EN12, 1);
    digitalWrite(M2EN34, 1);

    pinMode(M1A1, OUTPUT);
    pinMode(M1A2, OUTPUT);
    pinMode(M1A3, OUTPUT);
    pinMode(M1A4,OUTPUT);
    
    pinMode(M2A1, OUTPUT);
    pinMode(M2A2, OUTPUT);
    pinMode(M2A3, OUTPUT);
    pinMode(M2A4,OUTPUT);
    
    stepper1.setMaxSpeed(1000.0);
    stepper1.setAcceleration(500.0);
    stepper1.moveTo(200);
    
    stepper2.setMaxSpeed(300.0);
    stepper2.setAcceleration(100.0);
    stepper2.moveTo(762);
    
    TimeForServoChange = 25;
}

void loop()
{
  // Change direction at the limits
  if (stepper1.distanceToGo() == 0)
	stepper1.moveTo(-stepper1.currentPosition());
  stepper1.run();
  if (stepper2.distanceToGo() == 0)
	stepper2.moveTo(-stepper2.currentPosition());
  stepper2.run();
  if (millis() != LastMillis)
  {
    TimeForServoChange--;  
    LastMillis = millis();
  }
  if (TimeForServoChange <= 0)
  {
    SoftPWMServoServoWrite(SRV1, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(SRV2, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(SRV3, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(SRV4, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(SRV5, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(SRV6, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(SRV7, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(SRV8, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(SRV9, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(SRV10, pos);     // tell servo to go to position in variable 'pos' 
    #if defined(_BOARD_FUBARINO_SD_)
    SoftPWMServoServoWrite(SRV11, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(SRV12, pos);     // tell servo to go to position in variable 'pos' 
    #endif 
    TimeForServoChange = 25;
    pos += 10;
    if (pos > 2000)
    {
      pos = 1000;
    }
  }
}
