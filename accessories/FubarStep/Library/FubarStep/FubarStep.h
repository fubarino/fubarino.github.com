#ifndef FubarStep_h
#define FubarStep_h
/*

	FubarStep Library
	This library enables all the default defines for the FubarStep Motor, Stepper, Servo shield.




*/

#include <SoftPWMServo.h> 
#include <AccelStepper.h>

extern AccelStepper stepper1; 
extern AccelStepper stepper2; 


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
#define SRV1    1   // "Pin12"     // NOTE: this is the same as the Fubar Mini's green LED
#define SRV2    2   // "Pin13"
// Note pin 14 and pin 15 are not available if using a crystal (default)
#define SRV3    14  // "Pin 14"
#define SRV4    15  // "Pin 15"
#define SRV5    16  // "Pin 16"
#define SRV6    24  // "Pin 17"
#define SRV7    23  // "Pin 18"
#define SRV8    22  // "Pin 19"
#define SRV9    21  // "Pin 20"
#define SRV10   19  // "Pin 21"
#endif

void FubarStepInit();
void motor1output(int state);
void motor2output(int state);
void forwardstep1();
void backwardstep1();
void forwardstep2();
void backwardstep2();

extern AccelStepper stepper1; 
extern AccelStepper stepper2; 


#endif



