class health {
  String? temp;
  String? heartRate;
  String? pulsePattern;
  String? oxygen;
  String? date;
  String? name;
  String? ID;
  String? notes;
  String? docID;
  String? predictions;
  // String prediction;

  health({
    this.temp,
    this.heartRate,
    this.pulsePattern,
    this.oxygen,
    this.date,
    this.notes,
    this.name,
    this.predictions,
    this.ID,
    this.docID,
  });

  health.fromJson(Map<String, dynamic> json) {
    print(json);
    temp = json['temperature'] ?? "";
    date = json['date'] ?? "";
    name = json['name'] ?? "";
    ID = json['ID'] ?? "";
    notes = json['notes'] ?? "";
    docID = json['docID'] ?? "";
    heartRate = json['heart_rate'] ?? "";
    predictions = json['predictions'] ?? "";
    pulsePattern = json['pulse_pattern'] ?? "";
    oxygen = json['oxygen'] ?? "";

    // prediction = json['prediction'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temperature'] = this.temp;
    data['name'] = this.name;
    data['ID'] = this.ID;
    data['docID'] = this.docID;
    data['notes'] = this.notes;
    data['predictions'] = this.predictions;
    data['date'] = this.date;
    data['heart_rate'] = this.heartRate;
    data['pulse_pattern'] = this.pulsePattern;
    data['oxygen'] = this.oxygen;
    // data['prediction'] = this.prediction;
    return data;
  }
}
