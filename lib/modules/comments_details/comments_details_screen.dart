import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icons.dart';

class CommentsDetailsScreen extends StatelessWidget {

  PostModel model;
  String postId;

CommentsDetailsScreen({required this.model, required this.postId});
  var commentController = TextEditingController();
  var time = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
         SocialCubit.get(context).getComments(postId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var comments = SocialCubit
                .get(context)
                .comments;
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(IconBroken.Arrow___Left_2)),
                titleSpacing: 0,
                title: Text('Comments'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Conditional.single(
                  context: context,
                  conditionBuilder: (context) => comments.length > 0,
                  widgetBuilder: (context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              return buildCommentItem(comments[index],context);
                            },
                            separatorBuilder: (BuildContext context, int index) =>
                                SizedBox(height: 5,),
                            itemCount: comments.length,
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          height: 50,
                          padding: EdgeInsetsDirectional.only(
                            start: 15, end: 0,),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey,
                              )),
                          width: double.infinity,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    '${SocialCubit
                                        .get(context)
                                        .userModel!
                                        .image}'),
                                radius: 18,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: commentController,
                                  maxLines: 999,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Write a comment ...',
                                    suffixIcon: MaterialButton(
                                      onPressed: () {
                                        SocialCubit.get(context).commentPost(
                                          time: time,
                                          comment: commentController.text,
                                          postId: postId
                                        );
                                        commentController.clear();
                                        FocusScope.of(context).unfocus();

                                        /// to close keyboard after post comment
                                      },
                                      child: Icon(
                                        IconBroken.Arrow___Right_Circle,
                                        color: Colors.white,
                                      ),
                                      color: Colors.blue[300],
                                      elevation: 10,
                                      minWidth: 1,
                                    )
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  fallbackBuilder: (context) =>
                  comments.length == 0 ? Column(
                    children: [
                      Spacer(),
                      Center(
                        child: Text('No comments yet'),
                      ),
                      Spacer(),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        height: 50,
                        padding: EdgeInsetsDirectional.only(start: 15, end: 0,),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey,
                            )),
                        child: TextFormField(
                          controller: commentController,
                          maxLines: 999,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write a comment ...',
                            suffixIcon: MaterialButton(
                              height: 10,
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                SocialCubit.get(context).commentPost(
                                  postId: postId,
                                  comment: commentController.text,
                                  time: time,
                                );
                                commentController.clear();
                              },
                              color: Colors.blue,
                              elevation: 10,
                              minWidth: 1,
                              child: Icon(
                                IconBroken.Send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ) :
                  Center(child: CircularProgressIndicator()),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildCommentItem(CommentModel model,context) =>
      Container(
        child: Row(
          children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      '${SocialCubit.get(context).userModel!.image}'),
                  radius: 25,
                ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 10,
                ),
                child: Container(

                   clipBehavior: Clip.antiAliasWithSaveLayer,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(25),
                      topEnd: Radius.circular(25),
                      topStart: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${SocialCubit.get(context).userModel!.name}',
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900),),

                       Text(model.comment!,maxLines: 999,),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      );
}
