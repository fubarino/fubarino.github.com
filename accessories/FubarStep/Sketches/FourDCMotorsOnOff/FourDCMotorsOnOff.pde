#include <SoftPWMServo.h> 

int pos = 1000;         // variable to store the servo position, in microseconds

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

int TimeForServoChange;
unsigned long LastMillis = 0;

void setup()
{
    // Set up motor 1  
    pinMode(M1EN12, OUTPUT);
    digitalWrite(M1EN12, 1);
    pinMode(M1A1, OUTPUT);
    digitalWrite(M1A1, LOW);
    pinMode(M1A2, OUTPUT);
    digitalWrite(M1A2, LOW);

    // Set up motor 2
    pinMode(M1EN34, OUTPUT);
    digitalWrite(M1EN34, 1);
    pinMode(M1A3, OUTPUT);
    digitalWrite(M1A3, LOW);
    pinMode(M1A4, OUTPUT);
    digitalWrite(M1A4, LOW);
    
    // Set up motor 3
    pinMode(M2EN12, OUTPUT);
    digitalWrite(M2EN12, 1);
    pinMode(M2A1, OUTPUT);
    digitalWrite(M2A1, LOW);
    pinMode(M2A2, OUTPUT);
    digitalWrite(M2A2, LOW);

    // Set up motor 4
    pinMode(M2EN34,OUTPUT);
    digitalWrite(M2EN34, 1);
    pinMode(M2A3, OUTPUT);
    digitalWrite(M2A3, LOW);
    pinMode(M2A4, OUTPUT);
    digitalWrite(M2A4, LOW);
    
    TimeForServoChange = 25;
}

void loop()
{
    // Motor 1 on forward
    digitalWrite(M1A1, 1);
    digitalWrite(M1A2, 0);
    delay(1000);

    // Motor 2 on forward
    digitalWrite(M1A3, 1);
    digitalWrite(M1A4, 0);
    delay(1000);
  
    // Motor 3 on forward
    digitalWrite(M2A1, 1);
    digitalWrite(M2A2, 0);
    delay(1000);

    // Motor 4 on forward  
    digitalWrite(M2A3, 1);
    digitalWrite(M2A4, 0);
    delay(1000);
    
    // All motors off
    digitalWrite(M1A1, 0);
    digitalWrite(M1A2, 0);
    digitalWrite(M1A3, 0);
    digitalWrite(M1A4, 0);
    digitalWrite(M2A1, 0);
    digitalWrite(M2A2, 0);
    digitalWrite(M2A3, 0);
    digitalWrite(M2A4, 0);
    delay(1000);
    
    // Motor 1 on reverse
    digitalWrite(M1A1, 0);
    digitalWrite(M1A2, 1);
    delay(1000);

    // Motor 2 on reverse
    digitalWrite(M1A3, 0);
    digitalWrite(M1A4, 1);
    delay(1000);
  
    // Motor 3 on reverse
    digitalWrite(M2A1, 0);
    digitalWrite(M2A2, 1);
    delay(1000);

    // Motor 4 on reverse  
    digitalWrite(M2A3, 0);
    digitalWrite(M2A4, 1);
    delay(1000);
    
    // All motors off
    digitalWrite(M1A1, 0);
    digitalWrite(M1A2, 0);
    digitalWrite(M1A3, 0);
    digitalWrite(M1A4, 0);
    digitalWrite(M2A1, 0);
    digitalWrite(M2A2, 0);
    digitalWrite(M2A3, 0);
    digitalWrite(M2A4, 0);
    delay(1000);
  
#if 0
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
#endif
}
