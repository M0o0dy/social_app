import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/comments_details/comments_details_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constance.dart';
import 'package:social_app/shared/styles/icons.dart';

class HomeScreen extends StatelessWidget {
  List<TextEditingController> commentController = [];
  var time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getUserData();
        SocialCubit.get(context).getUsers();
        SocialCubit.get(context).getPosts();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) { },
          builder: (context, state) {


            return Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                     SocialCubit.get(context).userModel != null
                         &&
                    SocialCubit.get(context).posts.length > 0,
                widgetBuilder: (context) => SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Card(
                            margin: EdgeInsetsDirectional.all(8),
                            elevation: 5,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomStart,
                              children: [
                                Image(
                                  image: NetworkImage(
                                      'https://image.freepik.com/free-vector/social-share-concept-illustration_114360-3325.jpg'),
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: double.infinity,
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Colors.greenAccent.withOpacity(.4),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        bottom: 5, start: 5),
                                    child: Text(
                                      'Communicate with the world',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(color: Colors.black38),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: SocialCubit.get(context).posts.length,
                            itemBuilder: (context, index) {

                              commentController.add(TextEditingController());
                              return buildPostItem(
                                SocialCubit.get(context).posts[index],
                                context,
                                index,
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 8,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                fallbackBuilder: (context)
                {
                   // SocialCubit.get(context).getPosts();
                  return Center(
                      child: Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 30,),
                            // Text(
                            //   'No posts, Pull to refresh ',
                            //   style: TextStyle(
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.w900,
                            //     color: Colors.black54,
                            //   ),
                            // )
                          ],
                        ),
                      ));

                }
            );
          },
        );
      },
    );
  }

  Widget buildPostItem(
    PostModel model,
    context,
    index,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8),
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('${model.image}'),
                  radius: 25,
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${model.name}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(height: 1),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 18,
                          )
                        ],
                      ),
                      Text(
                        '${model.timeDate}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      IconBroken.More_Circle,
                      color: Colors.grey,
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '${model.text}',
                style: TextStyle(fontSize: 16, height: 1.2),
              ),
            ),
            // Container(
            //   width: double.infinity,
            //   child: Wrap(
            //     spacing: 5,
            //     children: [
            //       Container(
            //         height: 22,
            //         child: MaterialButton(
            //           onPressed: () {},
            //           child: Text(
            //             '#Flutter',
            //             style: TextStyle(color: Colors.blue),
            //           ),
            //           padding: EdgeInsets.zero,
            //           minWidth: 0,
            //         ),
            //       ),
            //       Container(
            //         height: 22,
            //         child: MaterialButton(
            //           onPressed: () {},
            //           child: Text(
            //             '#Android_Studio',
            //             style: TextStyle(color: Colors.blue),
            //           ),
            //           padding: EdgeInsets.zero,
            //           minWidth: 0,
            //         ),
            //       ),
            //       Container(
            //         height: 22,
            //         child: MaterialButton(
            //           onPressed: () {},
            //           child: Text(
            //             '#IOS',
            //             style: TextStyle(color: Colors.blue),
            //           ),
            //           padding: EdgeInsets.zero,
            //           minWidth: 0,
            //         ),
            //       ),
            //       Container(
            //         height: 22,
            //         child: MaterialButton(
            //           onPressed: () {},
            //           child: Text(
            //             '#Android',
            //             style: TextStyle(color: Colors.blue),
            //           ),
            //           padding: EdgeInsets.zero,
            //           minWidth: 0,
            //         ),
            //       ),
            //       Container(
            //         height: 22,
            //         child: MaterialButton(
            //           onPressed: () {},
            //           child: Text(
            //             '#Mobile_Developer',
            //             style: TextStyle(color: Colors.blue),
            //           ),
            //           padding: EdgeInsets.zero,
            //           minWidth: 0,
            //         ),
            //       ),
            //       Container(
            //         height: 22,
            //         child: MaterialButton(
            //           onPressed: () {},
            //           child: Text(
            //             '#Programming',
            //             style: TextStyle(color: Colors.blue),
            //           ),
            //           padding: EdgeInsets.zero,
            //           minWidth: 0,
            //         ),
            //       ),
            //       Container(
            //         height: 22,
            //         child: MaterialButton(
            //           onPressed: () {},
            //           child: Text(
            //             '#Coding',
            //             style: TextStyle(color: Colors.blue),
            //           ),
            //           padding: EdgeInsets.zero,
            //           minWidth: 0,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            if (model.postImage != '')
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        '${model.postImage}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          model.liked! ? Icons.favorite : IconBroken.Heart,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        // if (SocialCubit.get(context).likesCount[index] > 0)
                          Text(
                            '${SocialCubit.get(context).likesCount[index]}',
                            // SocialCubit.get(context).likes[index] >0 ?
                            // '${SocialCubit.get(context).likes[index]}' : '',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      navigateTo(context, CommentsDetailsScreen(model: model,postId: SocialCubit.get(context).postId[index],));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          IconBroken.Chat,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        if (SocialCubit.get(context).commentsCount[index] > 0)
                          Text(
                            '${SocialCubit.get(context).commentsCount[index]}',
                            // SocialCubit.get(context).comments[index] >0 ?
                            // '${SocialCubit.get(context).comments[index]}' :
                            // '',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        '${SocialCubit.get(context).userModel!.image}'),
                    radius: 18,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: TextFormField(
                        onChanged: (value) {
                          SocialCubit.get(context).commentOnChanged(
                            commentController[index],
                          );
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write a comment ...'),
                        controller: commentController[index],
                        maxLines: 3,
                        minLines: 1,
                      ),
                    ),
                  ),
                  if (commentController[index].text.isEmpty)
                    InkWell(
                      onTap: () {
                        SocialCubit.get(context)
                            .likePost(SocialCubit.get(context).postId[index]);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Like',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (commentController[index].text.isNotEmpty)
                    MaterialButton(
                      onPressed: () {
                        SocialCubit.get(context).commentPost(
                            postId: SocialCubit.get(context).postId[index],
                            comment: commentController[index].text,
                            time: time.toString());
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
