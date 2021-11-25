import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/new_post_screen/new_post_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icons.dart';


class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      SocialCubit.get(context).getUserData();
      SocialCubit.get(context).getPosts();
      SocialCubit.get(context).getUsers();
      return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
            if(state is SocialNewPostState){
              navigateTo(context, NewPostScreen());
            }

          },
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentIndex]),
                actions: [
                  IconButton(onPressed: (){}, icon: Icon(
                      IconBroken.Notification
                  )),
                  IconButton(onPressed: (){}, icon: Icon(
                      IconBroken.Search
                  )),
                ],
              ),
              body: Conditional.single(

                context: context,
                conditionBuilder: (context)=> SocialCubit.get(context).userModel != null ,
                fallbackBuilder: (context)
                {

                  return Center(child: CircularProgressIndicator());},
                widgetBuilder: (context){
                  return cubit.screens[cubit.currentIndex];

                },
              ),
              bottomNavigationBar:
              // GNav(
              //
              //   backgroundColor: Colors.white,
              //     // rippleColor: Colors.grey[800]!, // tab button ripple color when pressed
              //     // hoverColor: Colors.grey[700]!, // tab button hover color
              //   // haptic: true, // haptic feedback
              //     tabBorderRadius: 15,
              //     // tabActiveBorder: Border.all(color: Colors.black, width: 1), // tab button border
              //     /// tabBorder: Border.all(color: Colors.white, width: 1), // tab button border
              //     // tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)], // tab button shadow
              //     curve: Curves.easeOutExpo, // tab animation curves
              //     duration: Duration(milliseconds: 500), // tab animation duration
              //     gap: 5, // the tab button gap between icon and text
              //     color: Colors.blueGrey[400], // unselected icon color
              //     activeColor: Colors.blue, // selected icon and text color
              //     iconSize: 30, // tab button icon size
              //     tabBackgroundColor: Colors.white, // selected tab background color
              //     padding: EdgeInsets.symmetric(horizontal: 17.8, vertical: 5), // navigation bar padding
              //     tabs: [
              //       GButton(
              //         icon: IconBroken.Home,
              //         text: 'Home',
              //       ),
              //       GButton(
              //         icon: IconBroken.User,
              //         text: 'Friends',
              //       ),
              //       GButton(
              //         icon: Icons.post_add_outlined,
              //         text: 'Post',
              //       ),
              //       GButton(
              //         icon: IconBroken.Chat,
              //         text: 'Chat',
              //       ),
              //       GButton(
              //         icon: IconBroken.Setting,
              //         text: 'Setting',
              //       ),
              //     ],
              //
              //   onTabChange: (index){
              //     cubit.changeNavBar(index);
              //   },
              //   selectedIndex: cubit.currentIndex,
              //
              // )
              BottomNavigationBar(items: [
                BottomNavigationBarItem(icon: Icon(IconBroken.Home),label: 'Home'),
                BottomNavigationBarItem(icon: Icon(IconBroken.User1),label: 'Friends'),
                BottomNavigationBarItem(icon: Icon(Icons.post_add_outlined),label: 'Post'),
                BottomNavigationBarItem(icon: Icon(IconBroken.Chat),label: 'Chat'),
                BottomNavigationBarItem(icon: Icon(IconBroken.Profile),label: 'Profile'),
              ],

                onTap: (index){
                  cubit.changeNavBar(index);
                },
                currentIndex: cubit.currentIndex,


              ),
            );
          });
    },

    );
  }
}
