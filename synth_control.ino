int xVal = 0; //joystick x value
int yVal = 0; //joystick y value
int buttonState = 0; //joystick buttonstate
int grnBState = 0; //green button state
int swtchState = 0; //switch state
void setup() {

  Serial.begin(9600); //open serial port
  pinMode(32, INPUT);
  pinMode(33, INPUT);

}

void loop() {
  if(analogRead(12) == 0) { //joystick button was being weird & digital read was not working for it so I set up this to generally tell if it is pressed
    buttonState = 1;
  } else {
    buttonState = 0;
  }
  if(digitalRead(32) == 0) {
    grnBState = 1;
  } else {
    grnBState = 0;
  }
    if(digitalRead(33) == 0) {
    swtchState = 1;
  } else {
    swtchState = 0;
  }
  xVal = analogRead(34);
  yVal = analogRead(35);
  Serial.printf("x%d\r\ny%d\r\nb%d\r\nd%d\r\ns%d\r\n", xVal, yVal, buttonState, grnBState, swtchState); 

}
