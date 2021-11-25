
class SocialUserModel {
  String? email;
  String? name;
  String? bio;
  String? uId;
  String? phone;
  String? image;
  String? cover;
  bool? isEmailVerified;


  SocialUserModel({
    this.email,
    this.name,
    this.bio,
    this.uId,
    this.phone,
    this.image,
    this.cover,
    this.isEmailVerified,
});

  SocialUserModel.fromJson(Map<String,dynamic>json){
    email = json['email'];
    name = json['name'];
    bio = json['bio'];
    uId = json['uId'];
    phone = json['phone'];
    image = json['image'];
    cover = json['cover'];
    isEmailVerified = json['isEmailVerified'];
  }
  Map<String,dynamic> toMap(){
    return{
      'email':email,
      'name':name,
      'bio':bio,
      'uId':uId,
      'phone':phone,
      'image':image,
      'cover':cover,
      'isEmailVerified':isEmailVerified,
    };
  }
}