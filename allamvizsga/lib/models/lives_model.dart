class Lives{
  int id;
  int userId;
  int livesNumber;

Lives({required this.id,required this.userId,required this.livesNumber});

factory Lives.fromJson(Map<String,dynamic> json){
  return Lives(
    id:json['id'],
    userId:json['userId'],
    livesNumber: json['livesNumber']
  );
}
}