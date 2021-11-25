import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {
          if (SocialCubit.get(context).userModel == null) {
            SocialCubit.get(context).getUserData();
          }
        }, builder: (context, state) {
          var model = SocialCubit.get(context).userModel;
          var profileImage = SocialCubit.get(context).profileImage;
          var coverImage = SocialCubit.get(context).coverImage;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is SocialSuccessProfileImagePickedState)
                    LinearProgressIndicator(),
                  if (state is SocialSuccessProfileImagePickedState)
                    SizedBox(
                      height: 10,
                    ),
                  Container(
                    height: 230,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: coverImage == null
                                        ? NetworkImage('${model!.cover}')
                                        : FileImage(coverImage)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.grey[300],
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => SimpleDialog(
                                              title: Text(
                                                  'Change cover picture',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              children: [
                                                SimpleDialogOption(
                                                  padding: EdgeInsets.only(
                                                      left: 55, bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Select from gallery',
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.image,
                                                        color: Colors.blueGrey,
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    SocialCubit.get(context)
                                                        .getCoverImageFromGallery();
                                                  },
                                                ),
                                                SimpleDialogOption(
                                                  padding: EdgeInsets.only(
                                                      left: 80, top: 10),
                                                  child: Row(
                                                    children: [
                                                      Text('Open camera',
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.camera_sharp,
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    SocialCubit.get(context)
                                                        .getCoverImageFromCamera();
                                                  },
                                                ),
                                                SimpleDialogOption(
                                                  padding: EdgeInsets.only(
                                                      left: 110, top: 10),
                                                  child: Row(
                                                    children: [
                                                      Text('Cancel',
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ));
                                  },
                                  icon: Icon(
                                    IconBroken.Camera,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 65,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                backgroundImage: profileImage == null
                                    ? NetworkImage('${model!.image}')
                                    : FileImage(profileImage) as ImageProvider,
                                radius: 62,
                              ),
                            ),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey[300],
                              child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => SimpleDialog(
                                              title: Text(
                                                  'Change profile picture',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              children: [
                                                SimpleDialogOption(
                                                  padding: EdgeInsets.only(
                                                      left: 55, bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Select from gallery',
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.image,
                                                        color: Colors.blueGrey,
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    SocialCubit.get(context)
                                                        .getProfileImageFromGallery();
                                                  },
                                                ),
                                                SimpleDialogOption(
                                                  padding: EdgeInsets.only(
                                                      left: 80, top: 10),
                                                  child: Row(
                                                    children: [
                                                      Text('Open camera',
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.camera_sharp,
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    SocialCubit.get(context)
                                                        .getProfileImageFromCamera();
                                                  },
                                                ),
                                                SimpleDialogOption(
                                                  padding: EdgeInsets.only(
                                                      left: 110, top: 10),
                                                  child: Row(
                                                    children: [
                                                      Text('Cancel',
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ));
                                  },
                                  icon: Icon(
                                    IconBroken.Camera,
                                    size: 20,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${model!.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    '${model.bio}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  'Posts',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  '0',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  'Photos',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  '0',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  'Followers',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  '0',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  'Followings',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  '0',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  defaultButton(
                    label: 'Edit Profile',
                    color: Colors.blue,
                    onPressed: () {
                      navigateTo(context, EditProfileScreen());
                    },
                  )
                  // child: Expanded(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Text('Edit Profile',style: TextStyle(fontSize: 25, color: Colors.white),),
                  //       SizedBox(width: 80,),
                  //       Icon(IconBroken.Edit,size: 30,color: Colors.white,),
                  //     ],
                  //   ),
                  // )),
                ],
              ),
            ),
          );
        });


  }
}
