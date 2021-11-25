
import 'package:social_app/modules/socail_login/socail_login.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

void socialSignOut(context) {

    CacheHelper.removeData(key:'uId').then((value){
      uId = CacheHelper.getData(key: 'uId');
      if(value){
        navigateAndFinishTo(context, SocialLoginScreen());
      }
    });
}


String? uId;
String? token;


