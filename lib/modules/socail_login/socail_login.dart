import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/socail_login/cubit/cubit.dart';
import 'package:social_app/modules/socail_login/cubit/states.dart';
import 'package:social_app/modules/socail_register/socail_register.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
class SocialLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
          listener: (context, state) {
            if (state is SocialLoginErrorState) {
              showToast(msg: state.error.toString(), state: ToastStates.ERROR);
            }
            if (state is SocialLoginSuccessState) {
              CacheHelper.saveData(key: 'uId', value: state.uId).then((
                  value) async {
                // SocialCubit.get(context).getUserData();
                navigateAndFinishTo(context, SocialLayout());
              }).catchError((error) {
                print('Error is ${error.toString()}');
              });
            }
          },
          builder: (context, state) {
            var cubit = SocialLoginCubit.get(context);
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Council',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                      color: Colors.blueGrey[700],
                                      fontWeight: FontWeight.w900),
                                ),
                                SizedBox(width: 20,),
                                CircleAvatar(
                                  child: Icon(
                                    Icons.connect_without_contact, size: 40,),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'SIGN IN',
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(

                                children: [
                                  Text(
                                    'Or',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(color: Colors.black45),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      navigateTo(context, SocialRegisterScreen());
                                    },
                                    child: Text(
                                      'SIGN UP',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(color: Colors.blue,
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                              Text(
                                ', To Communicate With Your Friends',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(color: Colors.black45),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                            controller: emailController,
                            label: 'Email Address',
                            hintText: 'Enter your Email Address',
                            prefixIcon: Icons.email_outlined,
                            keyboard: TextInputType.emailAddress,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Email Address can\'t be Empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                            controller: passwordController,
                            hintText: 'Enter your Password',
                            label: 'Password',
                            prefixIcon: Icons.lock_outlined,
                            suffixIcon: cubit.suffixIcon,
                            suffixPressed: () {
                              cubit.changeVisibility();
                            },
                            isPassword: cubit.isPassword,
                            keyboard: TextInputType.visiblePassword,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Password is too short';
                              }
                              return null;
                            },
                            onSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(

                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Conditional.single(
                            context: context,
                            widgetBuilder: (context) =>
                                defaultButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        cubit.userLogin(
                                            email: emailController.text,
                                            password: passwordController.text);
                                      }
                                    },
                                    label: 'SIGN IN'),
                            conditionBuilder: (
                                context) => state is! SocialLoginLoadingState,
                            fallbackBuilder: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(
                            height: 30,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
