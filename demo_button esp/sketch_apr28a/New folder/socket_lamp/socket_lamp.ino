#include <WiFi.h>
#include <String.h>
#include <stdint.h>
#include <WiFi.h>
const char *ssid =  "Khan Pro";   //Wifi SSID (Name)
const char *pass =  "khan5805"; //wifi password



WiFiServer wifiServer(1669);
void setup() {
  Serial.begin(115200);

  delay(100);
int a = 3;
  IPAddress apIP(a, 168, 43, 230); //Static IP for wifi gateway
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0)); //set Static IP gateway on NodeMCU
  WiFi.begin(ssid, pass); //turn on WIFI



  wifiServer.begin();

}
bool once = true;
void loop() {

  WiFiClient client = wifiServer.available();
  String command = "";

bool getSSID = false;
bool getPAss = false;
  if (client) {
    while (client.connected()) {
      while (client.available() > 0) {
        if(once){
          Serial.println("Connected to device");
          once= false;
          }
        char c = client.read();
        if (c == '\n') {
          break;
        }
        command += c;
        Serial.write(c);
      }
      char cmd[command.length()];
      command.toCharArray(cmd, command.length());
      if(command=="ssid"){
        getSSID = true;
        command = "";
        client.write("recieved");
      
      }
      if(command=="pass"){
        getPAss = true;
        command = "";
        client.write("recieved");
      
      }
      if(getSSID){
        Serial.print(command);
        getSSID = false;
      }
      if(getPAss){
        Serial.print(command);
        getPAss = false;
      }
      
      command = "";
      delay(10);
    }
    client.stop();
    Serial.println("Client disconnected");
  }
}
