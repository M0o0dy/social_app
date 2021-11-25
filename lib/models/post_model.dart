
class PostModel {
  String? name;
  String? uId;
  String? image;
  String? postImage;
  String? timeDate;
  String? text;
  bool? liked;


  PostModel({
    this.name,
    this.uId,
    this.image,
    this.postImage,
    this.timeDate,
    this.text,
    this.liked,
});

  PostModel.fromJson(Map<String,dynamic>json){
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    postImage = json['postImage'];
    timeDate = json['timeDate'];
    text = json['text'];
    liked = json['liked'];
  }

  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'uId':uId,
      'image':image,
      'postImage':postImage,
      'timeDate':timeDate,
      'text':text,
      'liked':liked,
    };
  }
}