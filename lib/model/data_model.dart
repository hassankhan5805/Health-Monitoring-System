class health {
  String? temp;
  String? heartRate;
  String? pulsePattern;
  String? oxygen;
  String? date;
  // String prediction;

  health({this.temp, this.heartRate, this.pulsePattern, this.oxygen,this.date});

  health.fromJson(Map<String, dynamic> json) {
    print(json);
    temp = json['temperature'] ?? "";
    date = json['date'] ?? "";
    heartRate = json['heart_rate'] ?? "";
    pulsePattern = json['pulse_pattern'] ?? "";
    oxygen = json['oxygen'] ?? "";
    // prediction = json['prediction'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temperature'] = this.temp;
    data['date'] = this.date;
    data['heart_rate'] = this.heartRate;
    data['pulse_pattern'] = this.pulsePattern;
    data['oxygen'] = this.oxygen;
    // data['prediction'] = this.prediction;
    return data;
  }
}
