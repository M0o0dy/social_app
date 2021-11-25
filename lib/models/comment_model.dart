
class CommentModel {

  String? timeDate;
  String? comment;


  CommentModel({

    this.timeDate,
    this.comment,
});

  CommentModel.fromJson(Map<String,dynamic>json){

    timeDate = json['timeDate'];
    comment = json['comment'];
  }

  Map<String,dynamic> toMap(){
    return{

      'timeDate':timeDate,
      'comment':comment,
    };
  }
}