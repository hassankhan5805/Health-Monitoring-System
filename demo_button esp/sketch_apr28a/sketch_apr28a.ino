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

const int ledPin = 2;


void setup() {

  Serial.begin(115200);

  pinMode(ledPin, OUTPUT);
  // Set outputs to LOW
  digitalWrite(ledPin, LOW);

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

}

void loop() {

    Firebase.setString(firebaseData, path + "/temperature","1456");
//     printResult(firebaseData , "customModel1");
    Firebase.getString(firebaseData, path + "/temperature");
     printResult(firebaseData , "temperature");
     Serial.print(firebaseData.errorReason());
//    Firebase.getString(firebaseData, path + "/customMode3");
//     printResult(firebaseData , "customModel3");
//    Firebase.getString(firebaseData, path + "/lampStatus");
//     printResult(firebaseData , "lampStatus");
//    Firebase.getString(firebaseData, path + "/lampBrightness");
//     printResult(firebaseData , "lampBrightness");
//    Firebase.getString(firebaseData, path + "/lampGradient");
//     printResult(firebaseData , "lampGradient");
//    Firebase.getString(firebaseData, path + "/voiceCmd");
//     printResult(firebaseData , "voiceCmd");
//    Firebase.getString(firebaseData, path + "/textCmd");
//     printResult(firebaseData , "textCmd");


}


void printResult(FirebaseData &data , String cmd)
{

 if (data.dataType() == "string"){
    Serial.println(cmd +data.stringData());}

}
