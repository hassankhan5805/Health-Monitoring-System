
#include <Wire.h>
#include <MAX30105.h>
#include <spo2_algorithm.h>
#include <heartRate.h>
#define debug Serial
#include <Adafruit_MLX90614.h>
#define MUX_adress  0x70
#include <FirebaseESP32.h>
#include <WiFi.h>

#define FIREBASE_HOST "health-monitoring-system-0623-default-rtdb.firebaseio.com"       // "YOUR FIREBASE HOST COPIED" //Do not include https:// in FIREBASE_HOST
#define FIREBASE_AUTH "57Z67US5coolCOKtRwS8mlFbsfBWfLauWXMmvVfa"

#define WIFI_SSID "Khan Pro"
#define WIFI_PASSWORD "khan5805"


// Define Firebase Data Object
FirebaseData firebaseData;

// Root Path
String path = "/123";
long IR_change;

//---------------- variables for finger detection --------------------

MAX30105 sensor;
long Startup_IRvalue;
long samples_taken = 0;
long startTime;

//--------------- variables for spo2 measurement ---------------------

uint32_t irBuffer[100];  // for IR LED sensor data
uint32_t redBuffer[100];  // for red LED sensor data

int32_t buffer_length; // length of data message
int32_t spo2;
int8_t validSPO2;
int32_t heartRate;
int8_t validHeartRate;

//------------- variables for heart rate measurement ------------------
int32_t bufferLength;
const byte rate_size = 5;
byte rates[rate_size];
byte rate_spot = 0;
long last_beat = 0;

float bpm;
int beat_avg;
//------------------ variables for pulse pattren-------------------------
  const byte avgAmount = 64;
  long baseValue = 0;

//----------------------------------------------------------------------
  byte ledBrightness;
  byte sampleAverage;
  byte ledMode;
  byte sampleRate;
  int pulseWidth;
  int adcRange;

  Adafruit_MLX90614 mlx = Adafruit_MLX90614();
  void TCA9548A(uint8_t bus){
  Wire.beginTransmission(MUX_adress);  // TCA9548A address is 0x70
  Wire.write(1 << bus);          // send byte to select bus
  Wire.endTransmission();
  Serial.print(bus);
}

void setup()
{
  Serial.begin(115200);
  Wire.begin();
   Serial.print("Connecting to ");
  Serial.println(WIFI_SSID);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  // Print local IP address and start web server
  Serial.println("");
  Serial.println("WiFi connected.");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());


  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);

  //Set database read timeout to 1 minute (max 15 minutes)
  Firebase.setReadTimeout(firebaseData, 1000 * 60);
  //tiny, small, medium, large and unlimited.
  //Size and its write timeout e.g. tiny (1s), small (10s), medium (30s) and large (60s).
  Firebase.setwriteSizeLimit(firebaseData, "tiny");

 if (sensor.begin(Wire, I2C_SPEED_FAST) == false)
  {
    debug.println("Sensor not found!");
    while (1);
  }
 
     if (!mlx.begin(0x5A)) {
    Serial.println("Error connecting to MLX sensor. Check wiring.");
    while (1);
  }
  
  
  ledBrightness = 0xFF; //Options: 0=Off to 255=50mA
  sampleAverage = 4; //Options: 1, 2, 4, 8, 16, 32
  ledMode = 2; //Options: 1 = Red only, 2 = Red + IR, 3 = Red + IR + Green
  sampleRate = 400; //Options: 50, 100, 200, 400, 800, 1000, 1600, 3200
  pulseWidth = 411; //Options: 69, 118, 215, 411
  adcRange = 2048;

  sensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange);

  Startup_IRvalue = 0;
  for (byte x = 0; x < 32; x++)
  {
    Startup_IRvalue += sensor.getIR();
  }

  Startup_IRvalue /= 32;

  startTime = millis();
  Serial.println("Press any key to start");
  while (Serial.available() == 0) ; //wait until user presses a key
  Serial.read();
}

void loop()
{
  //---------------------------------------FINGER DETECTION-------------------------------------------
 
 Serial.print("Startup_IRvalue[");
 Serial.print(Startup_IRvalue);
 Serial.print("] ");

 samples_taken++;
 Serial.print("IR[");
 Serial.print(sensor.getIR());
 Serial.print("] ");

 long IR_change = sensor.getIR() - Startup_IRvalue;

 Serial.print("IR Change = [");
 Serial.print(IR_change);
 Serial.print("] ");
 delay(1000);

 if (IR_change > (long)9000)                                              //
 
{ Serial.print("Finger Detected");
   Serial.println();
   Serial.print("Spo2 Detection, Please wait...");
   Serial.println();

   // once the finger is detected, measure parameters
    spo2_detection();
    Serial.println();
    Serial.print("Heart rate Detection, Please wait...");
      Firebase.setString(firebaseData, path + "/oxygen",spo2);
    Serial.println();
    BPM_detection();
    Serial.println();

    Serial.print("pulse pattren Detection, Please wait...");
    Serial.println();
    pulse_pattern();
    Serial.println();

    Serial.print("Temperature Detection, Please wait...");
    Serial.println();
    Temp_detection();
    Serial.println();
}
  else
  {
    Serial.print("Finger Out");
    delay(100);
    Serial.println();
  
  }
  
  }
  // Serial.println();


/* else
   {
   if(IR_change == 0)
   delay(3000);
   {esp_deep_sleep_start();}
   }*/

//----------------------Functions -------------------------


void spo2_detection()
{
  ledBrightness = 60; //Options: 0=Off to 255=50mA
  sampleAverage = 4; //Options: 1, 2, 4, 8, 16, 32
  ledMode = 2; //Options: 1 = Red only, 2 = Red + IR, 3 = Red + IR + Green
  sampleRate = 100; //Options: 50, 100, 200, 400, 800, 1000, 1600, 3200
  pulseWidth = 411; //Options: 69, 118, 215, 411
  adcRange = 4096; //Options: 2048, 4096, 8192, 16384
  delay(5000);

  sensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange); //Configure sensor with these settings
  bufferLength=100;
  for (byte i = 0 ; i < bufferLength ; i++)
  {
    while (sensor.available() == false) //do we have new data?
      sensor.check(); //Check the sensor for new data

    redBuffer[i] = sensor.getRed();
    irBuffer[i] = sensor.getIR();
    sensor.nextSample(); //We're finished with this sample so move to next sampl
  }

  //calculate heart rate and SpO2 after first 100 samples (first 4 seconds of samples)
  maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);

  //Continuously taking samples from MAX30102.  Heart rate and SpO2 are calculated every 1 second
    //dumping the first 25 sets of samples in the memory and shift the last 75 sets of samples to the top
    for (byte i = 25; i < 100; i++)
    {
      redBuffer[i - 25] = redBuffer[i];
      irBuffer[i - 25] = irBuffer[i];
    }

    //take 25 sets of samples before calculating the heart rate.
    for (byte i = 75; i < 100; i++)
    {
      while (sensor.available() == false) //do we have new data?
        sensor.check(); //Check the sensor for new data

//      digitalWrite(readLED, !digitalRead(readLED)); //Blink onboard LED with every data read

      redBuffer[i] = sensor.getRed();
      irBuffer[i] = sensor.getIR();
      sensor.nextSample(); //We're finished with this sample so move to next samp

      //send samples and calculation result to terminal program through UART
      Serial.print(F("red="));
      Serial.print(redBuffer[i], DEC);
      Serial.print(F(", ir="));
      Serial.print(irBuffer[i], DEC);

      Serial.print(F(", HR="));
      Serial.print(heartRate, DEC);

      Serial.print(F(", HRvalid="));
      Serial.print(validHeartRate, DEC);

      Serial.print(F(", SPO2="));
      Serial.print(spo2, DEC); // 1
       

      Serial.print(F(", SPO2Valid="));
      Serial.println(validSPO2, DEC);
    }

    //After gathering 25 new samples recalculate HR and SP02
    maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);
 }
  void BPM_detection()
  {
  
   sensor.setup(); //Configure sensor with default settings
   //sensor.setPulseAmplitudeRed(0x0A); //Turn Red LED to low to indicate sensor is running
   //sensor.setPulseAmplitudeGreen(0); //Turn off Green LED


    ledBrightness = 0xFF; //Options: 0=Off to 255=50mA
    sampleAverage = 4; //Options: 1, 2, 4, 8, 16, 32
    ledMode = 1; //Options: 1 = Red only, 2 = Red + IR, 3 = Red + IR + Green
    sampleRate = 400; //Options: 50, 100, 200, 400, 800, 1000, 1600, 3200
    pulseWidth = 411; //Options: 69, 118, 215, 411
    adcRange = 2048;
    //sensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange);
    for(int i=0; i<500; i++){
    long ir_value = sensor.getIR();

    if (checkForBeat(ir_value) == true)
    {
      //We sensed a beat!
      long delta = millis() - last_beat;
      last_beat = millis();
  
      bpm = 60 / (delta / 1000.0);

    if (bpm < 255 && bpm > 20)
    {
      rates[rate_spot++] = (byte)bpm; //Store this reading in the array
      rate_spot %= rate_size; //Wrap variable

      //Take average of readings
      beat_avg = 0;
      for (byte x = 0 ; x < rate_size ; x++)
        beat_avg += rates[x];
      beat_avg /= rate_size;
    }
  }

//  Serial.print("IR=");
//  Serial.print(ir_value);
  if(i>400 && i<499){
  Serial.print(", BPM=");
  Serial.print(bpm);
  Serial.print(", Avg BPM=");
  Serial.print(beat_avg); //2
     Firebase.setString(firebaseData, path + "/heart_rate",beat_avg);
  Serial.println();

  
  }}}


  void pulse_pattern()
  {
   // TCA9548A(0);
    ledMode = 3; //Options: 1 = Red only, 2 = Red + IR, 3 = Red + IR + Green
    ledBrightness = 0x1F; //Options: 0=Off to 255=50mA
    sampleAverage = 8; //Options: 1, 2, 4, 8, 16, 32
    sampleRate = 100; //Options: 50, 100, 200, 400, 800, 1000, 1600, 3200
    pulseWidth = 411; //Options: 69, 118, 215, 411
    adcRange = 4096;
    sensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange);

  const byte avgAmount = 64;
  long baseValue = 0;
  for (byte x = 0 ; x < avgAmount ; x++)
  {
    baseValue += sensor.getIR(); //Read the IR value
  }
  baseValue /= avgAmount;

  //Pre-populate the plotter so that the Y scale is close to IR values
  for (int x = 0 ; x < 200 ; x++)
    Serial.println(baseValue);



for(int i=0;i<500;i++){
while(i<500 && i>200){
  Serial.println(sensor.getIR()); //Send raw data to plotter // 3
    Firebase.setString(firebaseData, path + "/pulse_pattern",sensor.getIR());
i++;
    
    
} }};
void Temp_detection(){


  mlx.begin(0x5A);
  for(int i=0;i<20;i++) {
  Serial.print("Ambient = "); Serial.print(mlx.readAmbientTempC());
  Serial.print("*C\tObject = "); Serial.print(mlx.readObjectTempC());//4
  Serial.println("*C");
  Serial.print("Ambient = "); Serial.print(mlx.readAmbientTempF());
  Serial.print("*F\tObject = "); Serial.print(mlx.readObjectTempF());//4; 
   Firebase.setString(firebaseData, path + "/temperature",mlx.readObjectTempF());
  Serial.println("*F");

  Serial.println();
  delay(500);
}};
