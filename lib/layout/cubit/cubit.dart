import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/modules/Users/users_screen.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/new_post_screen/new_post_screen.dart';
import 'package:social_app/modules/profile/profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constance.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);



  SocialUserModel?
      userModel; // ==> my json model that i use to receive data from Firestore

  void getUserData() {
    uId = CacheHelper.getData(key: 'uId')??CacheHelper.getData(key: 'uId');
    emit(SocialLoadingGetUserDataState());
      FirebaseFirestore.instance
          .collection('users') // ==> my Firestore collection
          .doc(uId)
          .get()
          .then((value) {
        userModel = SocialUserModel.fromJson(value.data()!);

        // print(value.data()!.toString());
        emit(SocialSuccessGetUserDataState());
      }).catchError((error) {
        print('Error is ${error.toString()}');
        emit(SocialErrorGetUserDataState());
      });

  }

  int currentIndex = 0;

  void changeNavBar(int index) {
    if(index == 3){
      getUsers();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeNavBarState());
    }
  }

  List<Widget> screens = [
    HomeScreen(),
    UsersScreen(),
    NewPostScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];
  List<String> titles = [
    'News Feed',
    'Users',
    'New Post',
    'Chat',
    'Profile',
  ];


  var picker = ImagePicker();

  File? profileImage;

  void getProfileImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      uploadProfileImage();
      emit(SocialSuccessProfileImagePickedState());
    } else {
      emit(SocialErrorProfileImagePickedState());
    }
  }

  void getProfileImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      uploadProfileImage();
      emit(SocialSuccessProfileImagePickedState());
    } else {
      emit(SocialErrorProfileImagePickedState());
    }
  }

  File? coverImage;

  void getCoverImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      uploadCoverImage();
      emit(SocialSuccessCoverImagePickedState());
    } else {
      emit(SocialErrorCoverImagePickedState());
    }
  }

  void getCoverImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      uploadCoverImage();
      emit(SocialSuccessCoverImagePickedState());
    } else {
      emit(SocialErrorCoverImagePickedState());
    }
  }


  void uploadProfileImage() {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateProfileImage(imageUrl: value);
        emit(SocialSuccessUploadProfileImageState());
      }).catchError((e) {
        emit(SocialErrorUploadProfileImageState());
      });
    }).catchError((e) {
      emit(SocialErrorUploadProfileImageState());
    });
  }


  void uploadCoverImage() {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateCoverImage(coverUrl: value);
        emit(SocialSuccessUploadCoverImageState());
      }).catchError((e) {
        emit(SocialErrorUploadCoverImageState());
      });
    }).catchError((e) {
      emit(SocialErrorUploadCoverImageState());
    });
  }


  void updateUserDate({
  required String name,
  required String bio,
  required String phone,
}) {
      SocialUserModel model = SocialUserModel(
        bio: bio,
        uId: userModel!.uId,
        isEmailVerified: userModel!.isEmailVerified,
        email: userModel!.email,
        phone: phone,
        name: name,
        cover: userModel!.cover,
        image: userModel!.image,
      );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((e) {
      print('Error is ${e.toString()}');
      emit(SocialErrorUpdateUserDataState());
    });
  }

  void updateProfileImage({required String imageUrl}) {
      SocialUserModel model = SocialUserModel(
        bio: userModel!.bio,
        uId: userModel!.uId,
        isEmailVerified: userModel!.isEmailVerified,
        email: userModel!.email,
        phone: userModel!.phone,
        name: userModel!.name,
        cover: userModel!.cover,
        image: imageUrl,
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(userModel!.uId)
          .update(model.toMap())
          .then((value) {
        getUserData();
      }).catchError((e) {
        print('Error is ${e.toString()}');
        emit(SocialErrorUpdateUserDataState());
      });

  }


  void updateCoverImage({required String coverUrl}) {
      SocialUserModel model = SocialUserModel(
        bio: userModel!.bio,
        uId: userModel!.uId,
        isEmailVerified: userModel!.isEmailVerified,
        email: userModel!.email,
        phone: userModel!.phone,
        name: userModel!.name,
        cover: coverUrl,
        image: userModel!.image,
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(userModel!.uId)
          .update(model.toMap())
          .then((value) {
        getUserData();
      }).catchError((e) {
        print('Error is ${e.toString()}');
        emit(SocialErrorUpdateUserDataState());
      });

  }


  PostModel? postModel;
  File? postImage;

  void getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialSuccessPostImagePickedState());
    } else {
      emit(SocialErrorPostImagePickedState());
    }
  }

  void uploadPost({required String text,required String time}) {
    emit(SocialLoadingUploadPostState());
    if(postImage != null){
      firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(postImageUrl: value, time:time, text: text,);
        closeImagePost();
        getPosts();

        emit(SocialSuccessUploadPostState());
      }).catchError((e) {
        emit(SocialErrorUploadPostState());
      });
    }).catchError((e) {
      emit(SocialErrorUploadPostState());
    });
    }
    else {
      createPost(
        postImageUrl: '',
        time: time,
        text: text,
      );
      emit(SocialSuccessUploadPostState());
    }
  }

  void createPost({required String postImageUrl,required String text,required String time}) {
    PostModel model = PostModel(
      uId: userModel!.uId,
      name: userModel!.name,
      image: userModel!.image,
      postImage: postImageUrl,
      text: text,
      timeDate: time,
      liked: false,

    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialSuccessCreatePostState());
    }).catchError((e) {
      print('Error is ${e.toString()}');
      emit(SocialErrorCreatePostState());
    });

  }

  void closeImagePost(){
    postImage = null;
    emit(SocialClosePostImageState());
  }

  List<PostModel> posts =[];
  List<String> postId =[];
  List<int> likesCount =[];
  List<int> commentsCount =[];
  List<CommentModel> comments =[];


  void getPosts()async{

    emit(SocialLoadingGetPostsState());

     await FirebaseFirestore.instance
        .collection('posts').orderBy('timeDate')
        .get()
        .then((value){
      emit(SocialLoadingGetPostsState());
      value.docs.forEach((element) async {
            posts =[];
            postId =[];
            // element.reference
            //     .collection('likes')
            // .get().
            // then((value) {
            //   posts.add(PostModel.fromJson(element.data()));
            //   postId.add(element.id);
            //   likes.add(value.docs.length);
            //   emit(SocialSuccessGetLikesState());
            // }).catchError((e){
            //   print('Error is ${e.toString()}');
            //   emit(SocialErrorGetLikesState());
            // });
            await element.reference.snapshots().listen((event) {
            postId.add(element.id);
             posts.add(PostModel.fromJson(element.data()));

        });
            emit(SocialLoadingGetCommentsState());

            commentsCount = [];
            await element.reference.collection('comments').doc(userModel!.uId)
               .collection('comments').snapshots().listen((event) {
            commentsCount.add(event.docs.length);

        });



           comments = [];
            await element.reference.collection('comments').doc(userModel!.uId)
               .collection('comments').get().then((value) {
                 value.docs.forEach((element) {
              comments.add(CommentModel.fromJson(element.data()));

          });
           });
            emit(SocialLoadingGetLikesState());
             likesCount =[];
            await element.reference.collection('likes').snapshots().listen((event) {
            likesCount.add(event.docs.length);

        });


          });
            emit(SocialSuccessGetPostsState());
    }).catchError((e){
          print('Error is${e.toString()}');
          emit(SocialErrorGetPostsState());

    });
  }
  void getComments(String postId)async{

    emit(SocialLoadingGetCommentsState());

    await FirebaseFirestore.instance
        .collection('posts').doc(postId)
        .get()
        .then((value){
      value.reference.snapshots().listen((event)async {
        event.reference.collection('comments')
            .doc(userModel!.uId)
            .collection('comments').get().then((value) {
              value.docs.forEach((element) {
                  comments = [];
                element.reference.snapshots().listen((event) {
                comments.add(CommentModel.fromJson(event.data()!));
              print(comments.length.toString());
                });
              });
            });
      });
            emit(SocialSuccessGetCommentsState());
    }).catchError((e){
          print('Error is${e.toString()}');
          emit(SocialErrorGetCommentsState());

    });
  }








    bool isNotLiked = true;

  void likePost(String postId) {
    if(isNotLiked) {
      emit(SocialLoadingLikePostState());

       FirebaseFirestore.instance
          .collection('posts')
          .doc(postId).update({'liked': true}).then((value){
            FirebaseFirestore.instance
                .collection('posts')
                .doc(postId).collection('likes')
                .doc(userModel!.uId)
                .set({'like':isNotLiked})
                .then((value) {
              isNotLiked=false;
              getPosts();
              emit(SocialSuccessLikePostState());
            }).catchError((e) {
              print('Error is${e.toString()}');
              emit(SocialErrorLikePostState());
            });
      });
    }else{
      emit(SocialLoadingDeleteLikePostState());
       FirebaseFirestore.instance
          .collection('posts')
          .doc(postId).update({'liked': false}).then((value){
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId).collection('likes')
            .doc(userModel!.uId)
            .delete()
            .then((value) {
          isNotLiked=true;
          getPosts();
          emit(SocialSuccessDeleteLikePostState());
        }).catchError((e) {
          print('Error is${e.toString()}');
      emit(SocialErrorDeleteLikePostState());
        });

      });
    }
  }

  void commentOnChanged(TextEditingController controller){
    if(controller.text.isNotEmpty) {
      emit(SocialWritingCommentState());
    }else emit(SocialNoCommentState());
  }

  void commentPost({required String postId,required String comment,required String time}) {
    CommentModel model = CommentModel(
      timeDate: time,
      comment: comment
    );

     FirebaseFirestore.instance
    .collection('posts').doc(postId)
    .collection('comments').doc(
      userModel!.uId
    ).collection('comments')
    .add(model.toMap()).then((value){
      getPosts();
      getComments(postId);
        emit(SocialSuccessCommentPostState());
    }).catchError((e){
            print('Error is${e.toString()}');
        emit(SocialErrorCommentPostState());
      });
    // FirebaseFirestore.instance
    //     .collection('posts').doc(postId)
    //     .collection('comments').doc(userModel!.uId)
    //     .set({'comment': comment}).then((value)  {
    //      getPosts();
    //   emit(SocialSuccessCommentPostState());
    // })
    //     .catchError((e){
    //       print('Error is${e.toString()}');
    //   emit(SocialErrorCommentPostState());
    // });
  }

  List<SocialUserModel> users =[];

  void getUsers(){
    emit(SocialLoadingGetAllUserDataState());
    if(users.length == 0)
    FirebaseFirestore.instance
        .collection('users').get()
        .then((value){
          value.docs.forEach((element) {
            if(element.data()['uId'] != userModel!.uId)
            users.add(SocialUserModel.fromJson(element.data()));
          });
          emit(SocialSuccessGetAllUserDataState());

    }).catchError((e){print('Error is ${e.toString()}');});
    users = [];
         emit(SocialErrorGetAllUserDataState());
  }

  void sendMessage({required String receiverId,required String text,required String dateTime}){
    MessageModel model = MessageModel(
      text: text,
      receiverId: receiverId,
      senderID: userModel!.uId,
      dateTime: dateTime,
    );

    // set my message
    FirebaseFirestore.instance
    .collection('users')
    .doc(uId)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .add(model.toMap())
    .then((value){
      DioHelper.postData(data: {
        'to': token,
        'notification':{
          'title':'Message From : ${userModel!.name}',
          'sound':'default'
        }
      });
      emit((SocialSuccessSendMessageState()));
    })
    .catchError((e){
      emit(SocialErrorSendMessageState());
    });

    // set receiver message
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(model.toMap())
        .then((value){
      emit((SocialSuccessSendMessageState()));
    })
        .catchError((e){
      emit(SocialErrorSendMessageState());
    });
  }


  List<MessageModel> messages =[];

  void getMessages({required String receiverId}){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
    .orderBy('dateTime')
        .snapshots()
    .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialSuccessGetMessageState());
    });
  }




}
