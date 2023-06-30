class Chapter {
  int id;
  String name;
  int subjectId;


  Chapter({required this.id,required this.name,required this.subjectId});

  factory Chapter.fromJson(Map<String,dynamic> json){
    return Chapter(
      id: json['chapterId'], 
      name: json['chapterName'],
      subjectId: json['subjectId']);
  }

}