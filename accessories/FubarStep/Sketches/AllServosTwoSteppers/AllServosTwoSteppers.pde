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

void forwardstep1()
{
  state1++;
  if (state1 >= 4)
  {
    state1 = 0;
  }
  
  switch(state1)
  {
    case 0:
      digitalWrite(2,1);
      digitalWrite(0,0);
      digitalWrite(1,1);
      digitalWrite(3,0);      
      break;
      
    case 1:
      digitalWrite(2,1);
      digitalWrite(0,0);
      digitalWrite(1,0);
      digitalWrite(3,1);      
      break;

    case 2:
      digitalWrite(2,0);
      digitalWrite(0,1);
      digitalWrite(1,0);
      digitalWrite(3,1);      
      break;

    case 3:
      digitalWrite(2,0);
      digitalWrite(0,1);
      digitalWrite(1,1);
      digitalWrite(3,0);      
      break;
  }
}

void backwardstep1()
{
  state1--;
  if (state1 < 0)
  {
    state1 = 3;
  }
  
  switch(state1)
  {
    case 0:
      digitalWrite(2,1);
      digitalWrite(0,0);
      digitalWrite(1,1);
      digitalWrite(3,0);      
      break;
      
    case 1:
      digitalWrite(2,1);
      digitalWrite(0,0);
      digitalWrite(1,0);
      digitalWrite(3,1);      
      break;

    case 2:
      digitalWrite(2,0);
      digitalWrite(0,1);
      digitalWrite(1,0);
      digitalWrite(3,1);      
      break;

    case 3:
      digitalWrite(2,0);
      digitalWrite(0,1);
      digitalWrite(1,1);
      digitalWrite(3,0);      
      break;
  }
}


void forwardstep2()
{
  state2++;
  if (state2 >= 4)
  {
    state2 = 0;
  }
  
  switch(state2)
  {
    case 0:
      digitalWrite(5,1);
      digitalWrite(6,0);
      digitalWrite(11,1);
      digitalWrite(4,0);      
      break;
      
    case 1:
      digitalWrite(5,1);
      digitalWrite(6,0);
      digitalWrite(11,0);
      digitalWrite(4,1);      
      break;

    case 2:
      digitalWrite(5,0);
      digitalWrite(6,1);
      digitalWrite(11,0);
      digitalWrite(4,1);      
      break;

    case 3:
      digitalWrite(5,0);
      digitalWrite(6,1);
      digitalWrite(11,1);
      digitalWrite(4,0);      
      break;
  }
}

void backwardstep2()
{
  state2--;
  if (state2 < 0)
  {
    state2 = 3;
  }
  
  switch(state2)
  {
    case 0:
      digitalWrite(5,1);
      digitalWrite(6,0);
      digitalWrite(11,1);
      digitalWrite(4,0);      
      break;
      
    case 1:
      digitalWrite(5,1);
      digitalWrite(6,0);
      digitalWrite(11,0);
      digitalWrite(4,1);      
      break;

    case 2:
      digitalWrite(5,0);
      digitalWrite(6,1);
      digitalWrite(11,0);
      digitalWrite(4,1);      
      break;

    case 3:
      digitalWrite(5,0);
      digitalWrite(6,1);
      digitalWrite(11,1);
      digitalWrite(4,0);      
      break;
  }
}

// Define some steppers and the pins the will use
AccelStepper stepper1(forwardstep1, backwardstep1); 
AccelStepper stepper2(forwardstep2, backwardstep2); 

int TimeForServoChange;
unsigned long LastMillis = 0;

void setup()
{  
    // Set up enable pins to be output, high
    pinMode(7, OUTPUT);
    pinMode(8, OUTPUT);
    pinMode(9, OUTPUT);
    pinMode(10,OUTPUT);
    digitalWrite(7, 1);
    digitalWrite(8, 1);
    digitalWrite(9, 1);
    digitalWrite(10, 1);

    pinMode(0, OUTPUT);
    pinMode(1, OUTPUT);
    pinMode(2, OUTPUT);
    pinMode(3,OUTPUT);
    
    pinMode(4, OUTPUT);
    pinMode(5, OUTPUT);
    pinMode(6, OUTPUT);
    pinMode(11,OUTPUT);
    
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
    SoftPWMServoServoWrite(12, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(13, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(14, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(15, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(16, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(17, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(18, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(19, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(20, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(21, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(22, pos);     // tell servo to go to position in variable 'pos' 
    SoftPWMServoServoWrite(23, pos);     // tell servo to go to position in variable 'pos' 
    TimeForServoChange = 25;
    pos += 10;
    if (pos > 2000)
    {
      pos = 1000;
    }
  }
}
