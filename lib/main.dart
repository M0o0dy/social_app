
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/socail_login/socail_login.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constance.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{

   showToast(msg: 'background fcm', state: ToastStates.WARNING);

}
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  token = await FirebaseMessaging.instance.getToken();
  print(' token is :  $token');
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((event) {
    showToast(msg: 'Fcm', state: ToastStates.WARNING);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    showToast(msg: 'hi Fcm', state: ToastStates.WARNING);
  });
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  Widget widget;
   uId = CacheHelper.getData(key: 'uId')??CacheHelper.getData(key: 'uId');
  if(uId != null){
    widget = SocialLayout();
  }else{
    widget = SocialLoginScreen();
  }
  runApp(MyApp(
    startWidget: widget,
  ));
}
class MyApp extends StatelessWidget
{
  Widget? startWidget;
  MyApp({this.startWidget});


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context)=>SocialCubit()..getUserData()..getUsers(),
      child: BlocConsumer<SocialCubit, SocialStates>(
          listener: (context,state){

          },
          builder: (context,state) {

            return MaterialApp(
              theme:lightTheme,
              darkTheme:  darkTheme,
              themeMode: ThemeMode.light,
              debugShowCheckedModeBanner: false,
              home: startWidget,
            );
          }
      ),
    );
  }

}
