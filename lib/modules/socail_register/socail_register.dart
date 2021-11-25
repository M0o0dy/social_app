import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/socail_register/cubit/cubit.dart';
import 'package:social_app/modules/socail_register/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class SocialRegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
          listener: (context, state) {
            if(state is SocialRegisterErrorState){
              showToast(msg: state.error.toString(), state: ToastStates.ERROR);
            }
            if (state is SocialCreateUserSuccessState){
              CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
                SocialCubit.get(context).getUserData();
                navigateAndFinishTo(context, SocialLayout());
              }).catchError((error){print('Error is ${error.toString()}');});
            }
          },
          builder: (context, state) {
        SocialRegisterCubit cubit = SocialRegisterCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIGN UP',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To Communicate With Your Friends',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.black45),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: nameController,
                      label: 'User Name',
                      hintText: 'Enter your User Name',
                      prefixIcon: Icons.person,
                      keyboard: TextInputType.name,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'User Name can\'t be Empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: phoneController,
                      label: 'Phone Number',
                      hintText: 'Enter your Phone Number',
                      prefixIcon: Icons.smartphone,
                      keyboard: TextInputType.phone,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'Phone Number can\'t be Empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
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
                      height: 10,
                    ),
                    defaultFormField(
                      controller: passwordController,
                      label: 'Password',
                      hintText: 'Enter your Password',
                      prefixIcon: Icons.lock_outlined,
                      suffixIcon: cubit.passwordSuffixIcon,
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: confirmPasswordController,
                      label: 'Confirm Password',
                      hintText: 'Enter your Password again',
                      prefixIcon: Icons.lock_outlined,
                      suffixIcon: cubit.confirmedPasswordSuffixIcon,
                      suffixPressed: () {
                        cubit.changeConfirmVisibility();
                      },
                      isPassword: cubit.isConfirmPassword,
                      keyboard: TextInputType.visiblePassword,
                      validate: (String? value) {
                         if(value!.isEmpty){
                          return 'Please Confirm your Password';
                        }else
                        if (value != passwordController.text) {
                          return 'Your Password is wrong';

                        }
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Conditional.single(
                      context: context,
                      widgetBuilder: (context) => defaultButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.userRegister(
                                name: nameController.text,
                                phone: phoneController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          label: 'SIGN UP'),
                      conditionBuilder: (context) => state is! SocialRegisterLoadingState,
                      fallbackBuilder: (context) => Center(child: CircularProgressIndicator()),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
