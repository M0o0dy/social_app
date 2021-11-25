import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/styles/icons.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel model;

  ChatDetailsScreen({required this.model});

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(receiverId: model.uId!);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var messages = SocialCubit.get(context).messages;
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(IconBroken.Arrow___Left_2)),
                titleSpacing: 0,
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage('${model.image}'),
                      radius: 20,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      '${model.name}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(height: 1),
                    ),
                  ],
                ),
              ),
              body:
              Conditional.single(
                context: context,
                conditionBuilder: (context) => messages.length > 0,
                widgetBuilder: (context) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                                var message = messages[index];
                                if(SocialCubit.get(context).userModel!.uId == message.senderID)
                                  return buildMyMessageItem(message);

                                  return buildMessageItem(message);

                          },
                          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 15,),
                          itemCount: messages.length,
                        ),
                      ),
                      Padding(

                        padding: const EdgeInsets.all(20.0),
                        child: Container(

                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          height: 50,
                          padding: EdgeInsetsDirectional.only(start: 15, end: 0,),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey,
                              )),
                          child: TextFormField(
                            controller: messageController,
                            maxLines: 999,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Aa',
                              suffixIcon: MaterialButton(
                                height: 10,
                                padding: EdgeInsets.zero,
                                onPressed: ()async {
                                   SocialCubit.get(context).sendMessage(
                                    receiverId: model.uId!,
                                    text: messageController.text,
                                    dateTime: TimeOfDay.now().toString(),

                                  );

                                   messageController.clear();

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
                      ),
                    ],
                  );
                },
                fallbackBuilder: (context) => messages.length == 0 ? Column(
                  children: [
                    Spacer(),
                    Center(
                      child: Text('No Messages yet'),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(

                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        height: 50,
                        padding: EdgeInsetsDirectional.only(start: 15, end: 0,),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey,
                            )),
                        child: TextFormField(
                          controller: messageController,
                          maxLines: 999,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Aa',
                            suffixIcon: MaterialButton(
                              height: 10,
                              padding: EdgeInsets.zero,
                              onPressed: ()async {
                                SocialCubit.get(context).sendMessage(
                                  receiverId: model.uId!,
                                  text: messageController.text,
                                  dateTime: TimeOfDay.now().toString(),
                                );
                                messageController.clear();

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
                    ),
                  ],
                ) :
                    Center(child: CircularProgressIndicator()),
              ),
            );

          },
        );
      },
    );
  }

  Widget buildMessageItem(MessageModel model) => Align(
        alignment: AlignmentDirectional.topStart,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(20),
                topEnd: Radius.circular(20),
                topStart: Radius.circular(20),
              ),
            ),
            child: Text(model.text!),
          ),
        ),
      );

  Widget buildMyMessageItem(MessageModel model) => Align(
        alignment: AlignmentDirectional.topEnd,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(20),
                topEnd: Radius.circular(20),
                topStart: Radius.circular(20),
              ),
            ),
            child: Text(model.text!),
          ),
        ),
      );
}
