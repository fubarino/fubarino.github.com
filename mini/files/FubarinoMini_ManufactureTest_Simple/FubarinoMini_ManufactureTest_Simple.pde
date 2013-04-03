/* Test sketch for Fubarino Min board
   Written by Brian Schmalz of Schmalz Haus LLC
   03/17/2013
   version 1.1 - super short version (with no test jig)
*/

/* This sketch, along with the bootloader, is loaded as a single HEX file at manufacture time.
When the board is booted for the first time, it is done so in a speical test jig. This test
jig ties certain pins together, so that the code below may easily test the hardware of the board
automatically.

The test tiles are :
1) Power on LED test
2) USB test
3) Button/LED test
4) Bootloader entry test

The test procedure and test jig wiring is documented in the FubarinoMini Test Plan document.

The latest MPIDE can be downloaded from http://www.chipkit.org/forum/viewforum.php?f=20

Test 1: Power on LED test-
  The board boots, the red power LED comes on, then the green LED blinks once quickly showing that the 
  bootloader has run and passed control to the sketch, which is then running.
  
Test 2: USB test-
  The test operator waits until the LED is on solid, then opens the serial port on the test computer
  with a terminal emulator. This test will print "Press Enter" to the serial port. When the test
  gets back an Enter press from the terminal emulator, the test prints "USB test PASSED". 
  
Test 3: Button/LED test
  The test operator now pushes the PRG button, and sees if the green LED turns off when the button is 
  pushed. If so, this test passes.
  
Test 4: Bootloader entry test-
  The test operator must press the PRG button, press and release the RESET button, then release the PRG button.
  This will place the board into bootloader mode. The red LED should be on, and the green LED should be
  blinking rapidly on and off. This indicates proper entry into bootloader mode.
  
  If the main test sketch is entered (green LED blinks once, then turns on) then this test has failed.
  
  After Test 5 has passed, the USB cable can be removed from the Fubarino Mini and the testing is complete.
*/

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
      
  pinMode(PIN_LED1, OUTPUT);
  digitalWrite(PIN_LED1, HIGH);
  
  // Test2: USB test:
  // The test operator waits until the LED is on solid, then opens the serial port on the test computer
  // with a terminal emulator. This test will print "Press Enter" to the serial port. When the test
  // gets back an Enter press from the terminal emulator, the test passes.
  // 
  // If no Enter is received from the PC within 10 seconds, the test has failed
  Serial.begin(9600);
  Prompt("Press Enter");
  digitalWrite(PIN_LED1, LOW);
  Serial.println("USB test PASSED");
  
  // Test3: Button/LED test
  // Test operator pushes down on PRG button to turn off green LED
  pinMode(PIN_BTN1, INPUT);
  while(1)
  {
    int i;
    
    for (i=0; i < 8; i++)
    {
      if (digitalRead(PIN_BTN1) == HIGH)
      {
        digitalWrite(PIN_LED1, HIGH);
      }
      else
      {
        digitalWrite(PIN_LED1, LOW);
      }
      delay(100);
    }
    digitalWrite(PIN_LED1, LOW);
    delay(200);
  }
}

void loop()
{
}

