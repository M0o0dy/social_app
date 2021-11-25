import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icons.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    var postController = TextEditingController();
    var time = DateTime.now();


    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){
        if(state is SocialSuccessUploadPostState){
          SocialCubit.get(context).getPosts();
          navigateTo(context, SocialLayout());
        }
      },
      builder: (context,state){
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: defaultAppBar(context: context,title: 'Create Post',actions: [
            MaterialButton(onPressed: () {
              cubit.uploadPost(time: time.toString(), text:postController.text );

            },color: Colors.blue[300],elevation: 10,
                child: Text('post',style: TextStyle(fontSize: 22,color: Colors.white),)),
            SizedBox(width: 10,)
          ]),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if(state is SocialLoadingUploadPostState)
                LinearProgressIndicator(),
                if(state is SocialLoadingUploadPostState)
                  SizedBox(height: 10,),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          '${SocialCubit.get(context).userModel!.image}'),
                      radius: 25,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${SocialCubit.get(context).userModel!.name}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(height: 1),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.public,color: Colors.grey,size: 18,),
                              SizedBox(width: 5,),
                              Text(
                                'Public',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: SingleChildScrollView(
                      child: TextFormField(
                        controller: postController,
                        decoration: InputDecoration(
                            hintText: 'What\'s on your mind?',
                            border: InputBorder.none,
                        ),maxLines: 20,
                        minLines: 1,
                      ),
                    )),
                if(cubit.postImage != null)
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(cubit.postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey[300],
                        child: IconButton(
                          onPressed: () {
                            SocialCubit.get(context).closeImagePost();
                          },
                          icon: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  flex: 2,),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(onPressed: (){
                        cubit.getPostImage();
                      }, child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(IconBroken.Image),
                          SizedBox(width: 5,),
                          Text('Add Photo')
                        ],
                      )),
                    ),
                    Expanded(
                      child: TextButton(onPressed: (){}, child: Text('# Tags')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
