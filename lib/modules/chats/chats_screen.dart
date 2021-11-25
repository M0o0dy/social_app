import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (BuildContext context)
    {
      SocialCubit.get(context).getUserData();
      SocialCubit.get(context).getUsers();
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildChatItem(SocialCubit
                    .get(context)
                    .users[index], context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: SocialCubit
                .get(context)
                .users
                .length,
          );
        },
      );
    },
    );
  }

  Widget buildChatItem(SocialUserModel model, context) =>
      InkWell(
        onTap: () {
          navigateTo(context, ChatDetailsScreen(model: model,));
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('${model.image}'),
                radius: 25,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                '${model.name}',
                style:
                Theme
                    .of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(height: 1),
              ),
            ],
          ),
        ),
      );
}
