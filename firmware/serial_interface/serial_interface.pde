#define LED 13
#define SENSE A0
#define DEFAULT_SETTLING_DELAY_US 1000

// A simple serial interface to the Arduino DUE's analog input and output ports.
// The interface supports two functions, W and D. Each command must end with a semicolon ';'. 
// W takes two arguments: the value to set to DAC0 and the value to set to DAC1.
//     both values should be integers between 0 and 4095, inclusive.
// W sets both analog outputs, waits for the settling delay, then returns the analog input 0 value
// 
// D takes one argument: the new settling time in microseconds (as an integer).
// D returns the new settling time
// 
// Examples:
// Set DAC0 to 500 (out of 4095) and DAC1 to 4095 (out of 4095):
// Input: W 500 4095;
// Output: 2221 
//
// Set delay to 100 microseconds:
// Input: D 100;
// Output: 100

void setup() {
	analogReadResolution(12);
	analogWriteResolution(12);

  Serial.begin(115200);
  Serial.println("Serial interface active. Write values with 'W' or set delay with 'D'");

}

char buffer[15];
String input_string;
int settling_delay_us;

void loop() {
  int bytes_read;
  if (Serial.available()) {
    bytes_read = Serial.readBytesUntil(';', buffer, 15);
    if (bytes_read > 0) {
      input_string = String(buffer);
      input_string = input_string.substring(0, bytes_read); 
      int space_index1 = input_string.indexOf(' ');
      int space_index2 = input_string.indexOf(' ', space_index1+1);

      if (input_string[0] == 'D') {
        String delay_str = input_string.substring(space_index1+1);
        settling_delay_us = delay_str.toInt();
        Serial.println(settling_delay_us);
      } else if (input_string[0] == 'W') {
        String dac0_str = input_string.substring(space_index1, space_index2);
        int dac0_val = dac0_str.toInt();
        // Serial.println(dac0_val);
        analogWrite(DAC0, dac0_val);

        String dac1_str = input_string.substring(space_index2+1);
        int dac1_val = dac1_str.toInt();
        // Serial.println(dac1_val);
        analogWrite(DAC1, dac1_val);

        delayMicroseconds(settling_delay_us);

        int ain_val = analogRead(SENSE);
        Serial.println(ain_val);
      }
    }
  }


}