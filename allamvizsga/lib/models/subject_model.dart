

class Subject {
  int id;
  String name;

  Subject({required this.id,required this.name});

  factory Subject.fromJson(Map<String,dynamic> json){
    return Subject(
      id: json['subjectId'], 
      name: json['subjectName']);
  }

}