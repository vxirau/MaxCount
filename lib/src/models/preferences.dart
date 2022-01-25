import 'dart:convert';

Preferences preferencesFromJson(String str) =>
    Preferences.fromJson(json.decode(str));

String preferencesToJson(Preferences data) => json.encode(data.toJson());

class Preferences {
  Preferences({
    required this.wantsAudio,
    required this.hasOnboarded,
  });

  bool wantsAudio;
  bool hasOnboarded;

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
        wantsAudio: json["wantsAudio"],
        hasOnboarded: json["hasOnboarded"],
      );

  Map<String, dynamic> toJson() => {
        "wantsAudio": wantsAudio,
        "hasOnboarded": hasOnboarded,
      };
}
