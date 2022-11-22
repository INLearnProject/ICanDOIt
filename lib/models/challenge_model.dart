enum UnityChallenge { kg, km }

class ChallengeModel {
  final String name;
  final int target;
  final UnityChallenge unity;

  ChallengeModel(
      {required this.name, required this.target, required this.unity});

  ChallengeModel.fromJSON(Map<String, dynamic> json)
      : name = json['name'],
        target = json['target'],
        unity = json['unity'] == "UnityChallenge.kg"
            ? UnityChallenge.kg
            : UnityChallenge.km;

  Map<String, dynamic> toJSON() {
    return {"name": name, "target": target, "unity": unity.toString()};
  }
}
