import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constance.dart';
import 'package:social_app/shared/styles/icons.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var bioController = TextEditingController();
    var phoneController = TextEditingController();

    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var model = SocialCubit.get(context).userModel;
          nameController.text = model!.name!;
          bioController.text = model.bio!;
          phoneController.text = model.phone!;
          return Scaffold(
            appBar: defaultAppBar(
              context: context,
              title: 'Edit Profile',
              actions: [
                TextButton(
                    onPressed: () {
                      SocialCubit.get(context).updateUserDate(
                        name: nameController.text,
                        bio: bioController.text,
                        phone: phoneController.text,
                      );
                    },
                    child: Text(
                      'Update',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.blue),
                    )),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (state is SocialLoadingGetUserDataState)
                      LinearProgressIndicator(),
                    if (state is SocialLoadingGetUserDataState)
                      SizedBox(
                        height: 10,
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    defaultFormField(
                      controller: nameController,
                      label: 'Name',
                      prefixIcon: IconBroken.User,
                      keyboard: TextInputType.name,
                      validate: (String? v) {
                        if (v!.isEmpty) {
                          return 'Name must not be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: bioController,
                      label: 'Bio',
                      prefixIcon: Icons.info_outlined,
                      keyboard: TextInputType.text,
                      validate: (String? v) {
                        if (v!.isEmpty) {
                          return 'Bio must not be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: phoneController,
                      label: 'Phone',
                      prefixIcon: IconBroken.Call,
                      keyboard: TextInputType.phone,
                      validate: (String? v) {
                        if (v!.isEmpty) {
                          return 'Phone Number must not be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(onPressed: (){                    
                      socialSignOut(context);
                    },
                      child: Text('Sign Out'),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
