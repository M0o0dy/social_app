import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/modules/socail_register/cubit/states.dart';
import 'package:social_app/shared/components/constance.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  IconData passwordSuffixIcon = Icons.visibility;
  IconData confirmedPasswordSuffixIcon = Icons.visibility;
  bool isPassword = true;

  void changeVisibility() {
    isPassword = !isPassword;

    passwordSuffixIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(SocialRegisterVisibilityState());
  }

  bool isConfirmPassword = true;

  void changeConfirmVisibility() {
    isConfirmPassword = !isConfirmPassword;

    confirmedPasswordSuffixIcon = isConfirmPassword ? Icons.visibility : Icons.visibility_off;
    emit(SocialRegisterVisibilityState());
  }



  Future<void> userRegister({
    required String name,
    required String phone,
    required String email,
    required String password,
  })async {
    emit(SocialRegisterLoadingState());
   await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(
        name: name,
        email: email,
        uId: value.user!.uid,
        phone: phone,
      );
    }).catchError((error) {
      emit(SocialRegisterErrorState(error.toString()));
      print('Error is ${error.toString()}');
    });
  }



  Future<void> userCreate({
    required String name,
    required String phone,
    required String email,
    required String uId,
  }) async{
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      bio: 'Write your bio',
      image: 'https://image.flaticon.com/icons/png/512/748/748128.png',
      cover: 'https://image.freepik.com/free-vector/vector-hands-taking-photos_53876-18034.jpg',
      phone: phone,
      uId: uId,
      isEmailVerified: false,
    );
   await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(SocialCreateUserSuccessState(uId,));
    }).catchError((error) {
      emit(SocialCreateUserErrorState(error.toString()));
      print('Error is ${error.toString()}');
    });
  }



}
