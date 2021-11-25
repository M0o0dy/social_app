
class MessageModel {
  String? senderID;
  String? receiverId;
  String? dateTime;
  String? text;



  MessageModel({
    this.senderID,
    this.receiverId,
    this.dateTime,
    this.text,

});

  MessageModel.fromJson(Map<String,dynamic>json){
    senderID = json['senderID'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    text = json['text'];

  }

  Map<String,dynamic> toMap(){
    return{
      'senderID':senderID,
      'receiverId':receiverId,
      'dateTime':dateTime,
      'text':text,
    };
  }
}