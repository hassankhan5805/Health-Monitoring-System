class health {
  String? temp;
  String? heartRate;
  String? pulsePattern;
  String? oxygen;
  // String prediction;

  health({this.temp, this.heartRate, this.pulsePattern, this.oxygen});

  health.fromJson(Map<String, dynamic> json) {
    print(json);
    temp = json['temperature'] ?? "";
    heartRate = json['heart_rate'] ?? "";
    pulsePattern = json['pulse_pattern'] ?? "";
    oxygen = json['oxygen'] ?? "";
    // prediction = json['prediction'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temperature'] = this.temp;
    data['heart_rate'] = this.pulsePattern;
    data['pulse_pattern'] = this.heartRate;
    data['oxygen'] = this.oxygen;
    // data['prediction'] = this.prediction;
    return data;
  }
}
