/* Test sketch for Fubarino SD board
   Written by Brian Schmalz of Schmalz Haus LLC
   07/11/2012
   version 1.0
*/

/* This sketch, along with the bootloader, is loaded as a single HEX file at manufacture time.
When the board is booted for the first time, it is done so in a speical test jig. This test
jig ties certain pins together, so that the code below may easily test the hardware of the board
automatically.

The test tiles are :
1) Power on LED test
2) All pins - no opens, shorts, or misconnections
3) USB test
4) MicroSD test
5) External power test
6) Bootloader entry test

The test procedure and test jig wiring is documented in the FubarinoSD Test Plan document.

This test sketch uses the SD card library that comes with MPIDE.

The latest MPIDE can be downloaded from http://www.chipkit.org/forum/viewforum.php?f=20

Test 1: Power on LED test-
  The board boots, the red power LED comes on, then the green LED blinks once quickly showing that the 
  bootloader has run and passed control to the sketch, which is then running.

Test 2: All pins test-
  The test sketch then runs through all I/O pins and confirms that they are connected properly 
  in the test jig. If any opens or shorts are detected, the test will blink the green LED with 2 long 
  blinks (for test 2) and then a number of short blinks from 0 to 45, where the number of blinks represents
  the first pin that's shorted or opened.
 
  If the test passes, then the LED will turn on.
 
Test 3: USB test-
  The test operator waits until the LED is on solid, then opens the serial port on the test computer
  with a terminal emulator. This test will print "Press Enter" to the serial port. When the test
  gets back an Enter press from the terminal emulator, the test prints "USB test PASSED". 
  
Test 4: MicroSD test-
  This test will print out "Insert microSD card and press Enter" to the USB serial connection, and wait for
  an Enter press from the PC. When this Enter is detected, the test will write a file to the microSD card
  and read it back, and print either "microSD test PASSED" or "microSD test FAILED" to the USB serial port.

Test 5: External Power test-
  The test operator must remove the micro USB B cable from the board, and then apply 5V to the Vin pin. 
  This will re-power the board and begin to re-run the test sequence. If the green LED blinks, then the board is
  being properly powered by the exernal 5V and this test has passed. No red power LED or blink of green LED
  indicates a test failure.
  
Test 6: Bootloader entry test-
  The test operator must press the PRG button, press and release the RESET button, then release the PRG button.
  This will place the board into bootloader mode. The red LED should be on, and the green LED should be
  blinking rapidly on and off. This indicates proper entry into bootloader mode.
  
  If the main test sketch is entered (green LED blinks once, then turns on) then this test has failed.
*/

#include <SD.h>
#define SD_CS 27    // Pin 27 is the chip select for the SD card on Fubarino SD
#define FILE_CONTENTS  "This is the contents of the file."
#define MAX_PINS_TO_TEST 44
File myFile;

// If a test fails, then we need to flash the LED a certain number of times slowly to show
// which test failed.
void Flash(int TimesToFlash, int DelayTime)
{
  int Counter = 0;
  pinMode(PIN_LED1, OUTPUT);
  for (Counter = 0; Counter < TimesToFlash; Counter++)
  {
    digitalWrite(PIN_LED1, HIGH);
    delay(DelayTime);
    digitalWrite(PIN_LED1, LOW);
    delay(DelayTime);
  }
  delay(1500);
}

// Failure output function for TestUnit (test 2)
// Blink green LED with 2 long blinks, then 'pin' short blinks
// forever.
void TestUnitFail(int pin)
{
  int i;
  
  while (1)
  {
    Flash(2, 750);
    Flash(pin, 250);
    delay(1000);
  }
}

// Function to test on pair of pins.
// The OutputPin is made an output and set low
// And the InputPin should then read low. 
// All other pins should read high.
// Speical case is pin 44 - it's tied to pin 40, so we 
// need to ignore 40 if we get 44 for input or output
void PinTest(int OutputPin, int InputPin)
{
  int i;
  
  // Make our first pin an output and high
  pinMode(OutputPin, OUTPUT);
  digitalWrite(OutputPin, LOW);

  // Wait for everything to settle down
  delay(2);
  
  // See if all pins that aren't the input pin in are low
  for (i=0; i < MAX_PINS_TO_TEST; i++)
  {
    if (
      (i != OutputPin) 
      && 
      (i != InputPin) 
      && 
      !(
        (OutputPin == 44 || InputPin == 44)
        &&
        (i == 40)
      )
    )
    {
      if (digitalRead(i) == LOW)
      {
        TestUnitFail(i);
      }
    } 
  }
  if (digitalRead(InputPin) == HIGH)
  {
    TestUnitFail(InputPin);
  }
  if (digitalRead(OutputPin) == HIGH)
  {
    TestUnitFail(OutputPin);
  }
  
  // Always end with everything inputs again
  pinMode(InputPin, INPUT);
  pinMode(OutputPin, INPUT);
}


// Test one group of 4 I/O pins. The first and third pins are connected by the jig, and
// the second and fourth pins are connected by the jig. Each pin pair is pulled up to
// 3.3V with a 10K resisitor. 
// We set the first pin low. Only the third pin should go be low, all the rest
// should still be high.
// Then we set the first pin as an input, and the second pin as an output, and make it low.
// Only the fourth pin should go low - the rest should all be high.
// Then we reverse the directions - thrid pin output set low, then fourth pin output set low -
// and make sure that only the corresponding pins (first and second) go low.
// This test will identify if any two adjacent pins are shorted. It will identify if any
// pins are open. It will detect if any pin can't be set as an input or an output. It will
// detect if any pin can't read high or low when an input, and it will detect if any pin
// can't be made to go high as an output. 
void TestIOs(void)
{
  int i;
  // Start our with all pins as inputs
  for (i=0; i < NUM_DIGITAL_PINS; i++)
  {
    pinMode(i, INPUT);
  }

  // Pins 0,1,2,3
  PinTest(0, 2);      // 0 ouptut, 2 input
  PinTest(1, 3);      // 1 output, 3 input
  PinTest(2, 0);      // 2 output, 0 input
  PinTest(3, 1);      // 3 output, 1 input

  // Pins 4,5,6,7
  PinTest(4, 6);
  PinTest(5, 7);
  PinTest(6, 4);
  PinTest(7, 5);

  // Pins 8,9,10,11
  PinTest(8, 10);
  PinTest(9, 11);
  PinTest(10, 8);
  PinTest(11, 9);

  // Pins 12,13,14,15
  PinTest(12, 14);
  PinTest(13, 15);
  PinTest(14, 12);
  PinTest(15, 13);

  // Pins 16,17,18,21
  PinTest(16, 18);
  PinTest(17, 21);
  PinTest(18, 16);
  PinTest(21, 17);

  // Pins 19,20,22,23
  PinTest(19, 22);
  PinTest(20, 23);
  PinTest(22, 19);
  PinTest(23, 20);

  // Pins 24,25,30,31
  PinTest(24, 30);
  PinTest(25, 31);
  PinTest(30, 24);
  PinTest(31, 25);

  // Pins 26,27,32,33
  PinTest(26, 32);
  PinTest(27, 33);
  PinTest(32, 26);
  PinTest(33, 27);

  // Pins 34,35,36,37
  PinTest(34, 36);
  PinTest(35, 37);
  PinTest(36, 34);
  PinTest(37, 35);

  // Pins 38,39,28,29
  PinTest(38, 28);
  PinTest(39, 29);
  PinTest(28, 38);
  PinTest(29, 39);

  // Pins 40,41,42,43
  PinTest(40, 42);
  PinTest(41, 43);
  PinTest(42, 40);
  PinTest(43, 41);

  // Now test the last pin (since it's not in a unit of 4 pins)
  PinTest(42, 44);      // 42 ouptut, 44 input
  PinTest(44, 42);      // 44 ouptut, 42 input
}

// Wait for user to press Enter, with an optional prompt
void Prompt(char * Message)
{
  int PressedEnter = false;
  while (!PressedEnter) 
  {
    if (Message != NULL)
    {
      Serial.println(Message);
    }
    delay(250);
    if (Serial.available())
    {
      if (Serial.read() == 0x0D)
      {
        PressedEnter = true;
      }   
    }
  }
}

void setup()
{
  char FileContents[100];
  int FileLocation = 0;
  int Unit = 0;
  
  // Test 1: LED power on test
  // Set LED as output, and blink a short blink
  // This test shows that the bootloader has transfered control to the sketch, that power
  // is OK, and that the green LED works.
  delay(1000);
  pinMode(PIN_LED1, OUTPUT);
  digitalWrite(PIN_LED1, HIGH);
  delay(500);
  digitalWrite(PIN_LED1, LOW);
  delay(1000);
  
  // Test2: I/O pin test
  // This test uses the test jig wiring to confirm that all I/O pins are properly connected
  // and none are opened or shorted.
  // The pins are handled 4 at a time. Each 4 is called a 'unit'. We walk around the edge
  // of the board with these units except for the last one which only has 1 pin and needs
  // special attention.
  TestIOs();
    
  pinMode(PIN_LED1, OUTPUT);
  digitalWrite(PIN_LED1, HIGH);
  
  // Test3: USB test:
  // The test operator waits until the LED is on solid, then opens the serial port on the test computer
  // with a terminal emulator. This test will print "Press Enter" to the serial port. When the test
  // gets back an Enter press from the terminal emulator, the test passes.
  // 
  // If no Enter is received from the PC within 10 seconds, the test has failed, and the green LED will blink
  // 3 long blinks to indicate a test 3 failure.
  
  Serial.begin(9600);
  Prompt("Press Enter");
  Serial.println("USB test PASSED");

  // Test 4: MicroSD test-
  // This test will print out "Insert microSD card and press Enter" to the USB serial connection, and wait for
  // an Enter press from the PC. When this Enter is detected, the test will write a file to the microSD card
  // and read it back, and print either "microSD test PASSED" or "microSD test FAILED" to the USB serial port.

  delay(250);
  Serial.println("Insert microSD card and press Enter");
  Prompt(NULL);

  pinMode(SD_CS, OUTPUT);
   
  if (!SD.begin(SD_CS)) 
  {
    Serial.println("microSD test FAILED - could not initalize card");
    while(1)
    {
      Flash(4, 750);
    }
  }
  
  // If the file exists, delete it to begin with
  SD.remove("test.txt");
  
  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  myFile = SD.open("test.txt", FILE_WRITE);
  
  // if the file opened okay, write to it:
  if (myFile) 
  {
    myFile.println(FILE_CONTENTS);
    // close the file:
    myFile.close();
  } 
  else 
  {
    // if the file didn't open, print an error:
    Serial.println("microSD test FAILED - could not open file for writing");
    while(1)
    {
      Flash(4, 750);
    }
  }
  
  // re-open the file for reading:
  myFile = SD.open("test.txt");
  if (myFile) 
  {
    FileLocation = 0;
    // read from the file until there's nothing else in it:
    while (myFile.available()) 
    {
      FileContents[FileLocation++] = myFile.read();
    }
    FileContents[FileLocation] = 0x00;
    // close the file:
    myFile.close();
    if (strncmp(FileContents, FILE_CONTENTS, strlen(FILE_CONTENTS)) != 0)
    {
      Serial.println("microSD test FAILED - file conents incorrect");
      Serial.println(FILE_CONTENTS);
      Serial.println(FileContents);
      while(1)
      {
        Flash(4, 750);
      }
    }
  } 
  else 
  {
    // if the file didn't open, print an error:
    Serial.println("microSD test FAILED - could not open file for reading");
    while(1)
    {
        Flash(4, 750);
    }
  }
  Serial.println("microSD test PASSED");
}

void loop()
{
}

