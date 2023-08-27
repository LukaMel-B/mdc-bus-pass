// To parse this JSON data, do
//
//     final busPass = busPassFromJson(jsonString);

import 'dart:convert';

BusPass busPassFromJson(String str) => BusPass.fromJson(json.decode(str));

String busPassToJson(BusPass data) => json.encode(data.toJson());

class BusPass {
  String busPass;
  Student student;

  BusPass({
    required this.busPass,
    required this.student,
  });

  factory BusPass.fromJson(Map<String, dynamic> json) => BusPass(
        busPass: json["Bus_Pass"],
        student: Student.fromJson(json["student"]),
      );

  Map<String, dynamic> toJson() => {
        "Bus_Pass": busPass,
        "student": student.toJson(),
      };
}

class Student {
  String studentName;
  int yearOfJoin;
  DateTime validTill;
  String boardingPlace;
  int passId;

  Student({
    required this.studentName,
    required this.yearOfJoin,
    required this.validTill,
    required this.boardingPlace,
    required this.passId,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        studentName: json["student_name"],
        yearOfJoin: json["year_of_join"],
        validTill: DateTime.parse(json["valid_till"]),
        boardingPlace: json["boarding_place"],
        passId: json["pass_id"],
      );

  Map<String, dynamic> toJson() => {
        "student_name": studentName,
        "year_of_join": yearOfJoin,
        "valid_till":
            "${validTill.year.toString().padLeft(4, '0')}-${validTill.month.toString().padLeft(2, '0')}-${validTill.day.toString().padLeft(2, '0')}",
        "boarding_place": boardingPlace,
        "pass_id": passId,
      };
}
