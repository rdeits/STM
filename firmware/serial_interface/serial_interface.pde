#define LED 13
#define SENSE A0
#define DEFAULT_SETTLING_DELAY_US 10

void setup() {
	analogReadResolution(12);
	analogWriteResolution(12);

  pinMode(LED, OUTPUT);

  Serial.begin(115200);
  Serial.print("Hello world\r\n");

}

char buffer[11];
String input_string;
int settling_delay_us;

void loop() {
  // analogWrite(DAC0, 4095);
  // digitalWrite(LED, HIGH);
  // delay(100);
  // digitalWrite(LED, LOW);
  // analogWrite(DAC0, 0);
  // delay(100);
  // long i;
  // for (i = 0; i < 4096; i++) {
  // 	analogWrite(DAC0, i);
  //   analogWrite(DAC1, 0);
  // 	delayMicroseconds(1);
  // }

  int bytes_read;
  if (Serial.available()) {
    bytes_read = Serial.readBytesUntil(';', buffer, 11);
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
        Serial.println(dac0_val);
        analogWrite(DAC0, dac0_val);

        String dac1_str = input_string.substring(space_index2+1);
        int dac1_val = dac1_str.toInt();
        Serial.println(dac1_val);
        analogWrite(DAC1, dac1_val);

        delayMicroseconds(settling_delay_us);

        int ain_val = analogRead(SENSE);
        Serial.println(ain_val);
      }
    }
  }


}