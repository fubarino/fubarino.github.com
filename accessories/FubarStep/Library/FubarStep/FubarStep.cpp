#include "FubarStep."
#include <AccelStepper.h>
#include <SoftPWMServo.h> 



void begin()
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



