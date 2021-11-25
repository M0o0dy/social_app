import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/modules/socail_login/cubit/states.dart';
import 'package:social_app/shared/components/constance.dart';


class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);


  IconData suffixIcon = Icons.visibility;
  bool isPassword = true;

  void changeVisibility() {
    isPassword = !isPassword;

    suffixIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(SocialLoginVisibilityState());
  }


  void userLogin({
    required String email,
    required String password,
  }) {
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value){
      emit(SocialLoginSuccessState(value.user!.uid));
      print(value.user!.email);
    })
        .catchError((error){
      emit(SocialLoginErrorState(error.toString()));
          print('Error is ${error.toString()}');
        });
  }


}
