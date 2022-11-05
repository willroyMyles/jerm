// ignore_for_file: ignore-data
import 'dart:convert';

class CodeParent {
  String id;
  String title;
  List<Codes> codes;
  CodeParent({
    required this.id,
    required this.title,
    required this.codes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'codes': codes.map((x) => x.toMap()).toList(),
    };
  }

  factory CodeParent.fromMap(Map<String, dynamic> map) {
    return CodeParent(
      id: map['id'] as String,
      title: map['title'] as String,
      codes: List<Codes>.from(
        (map['codes']).map<Codes>(
          (x) => Codes.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CodeParent.fromJson(String source) =>
      CodeParent.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Codes {
  bool shared;
  int maxRedeemTimes;
  int timesRedeemed;
  bool isCompleted;
  String path;
  String id;
  String parentId;
  bool isEditing = false;
  Codes({
    this.shared = false,
    this.maxRedeemTimes = 1,
    this.timesRedeemed = 0,
    this.isCompleted = false,
    required this.path,
    required this.id,
    required this.parentId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shared': shared,
      'maxRedeemTimes': maxRedeemTimes,
      'timesRedeemed': timesRedeemed,
      'isCompleted': isCompleted,
      'path': path,
      'id': id,
      'parentId': parentId,
    };
  }

  Map<String, dynamic> toMiniMap() {
    return <String, dynamic>{
      'path': path,
      'id': id,
      'parentId': parentId,
    };
  }

  factory Codes.fromMap(Map<String, dynamic> map) {
    return Codes(
      shared: map['shared'] as bool,
      maxRedeemTimes: map['maxRedeemTimes'] as int,
      timesRedeemed: map['timesRedeemed'] as int,
      isCompleted: map['isCompleted'] as bool,
      path: map['path'] as String,
      id: map['id'] as String,
      parentId: map['parentId'] as String,
    );
  }

  String toJson() => json.encode(toMiniMap());

  factory Codes.fromJson(String source) =>
      Codes.fromMap(json.decode(source) as Map<String, dynamic>);
}
