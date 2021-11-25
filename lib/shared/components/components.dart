


import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/icons.dart';

void showToast({required String msg, required state})=>Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);
enum ToastStates{SUCCESS,WARNING,ERROR}
Color chooseColor (ToastStates state){
  Color color;
  switch(state){
    case ToastStates.SUCCESS : color = Colors.green;break;
    case ToastStates.WARNING : color = Colors.amber;break;
    case ToastStates.ERROR : color = Colors.red;break;
  }return color;
}



Widget defaultButton ({required String label, required Function onPressed,Color? color})=>Container(
width: double.infinity,
decoration: BoxDecoration(
  color: color?? Colors.blue,
  borderRadius: BorderRadius.circular(20),
),
child: MaterialButton(
onPressed:(){
  onPressed();
},
child: Text(
  label,
style: TextStyle(
fontSize: 20,
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
),
);




Widget defaultFormField ({
  required TextEditingController controller,
  required String label,
  required IconData prefixIcon,
  String? hintText,
  Color? outLineColor,
  Color? fillColor,
  Color? focusColor,
  Color? hoverColor,
  IconData? suffixIcon,
  VoidCallback? suffixPressed,
  FormFieldValidator<String>? validate,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,

  required TextInputType keyboard,
  bool isPassword = false,
  bool noInput = false,
}) => TextFormField(

  cursorColor: outLineColor,
  onChanged: onChanged,
  onFieldSubmitted:onSubmitted,
  readOnly:noInput ,
  validator: validate ,
  controller: controller,
  decoration: InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),),
    labelText: label,
    prefixIcon: Icon(prefixIcon),
    suffixIcon: IconButton(icon: Icon(suffixIcon),onPressed:suffixPressed,),
    hintText: hintText,
  ),
  keyboardType: keyboard,
  obscureText: isPassword ,

);


PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
})=> AppBar(
  title: Text(title!),
  leading: IconButton(onPressed: (){
    Navigator.pop(context);
  }, icon: Icon(IconBroken.Arrow___Left_2)),
  actions: actions,
);



Widget myDivider()=>Padding(
  padding: const EdgeInsetsDirectional.only(start: 20,),
  child: Container(
    height: 1, width: double.infinity, color: Colors.grey[300],),
);

void navigateTo(context, widget) => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> widget ));
void navigateAndFinishTo(context, widget) => Navigator.pushReplacement(context , MaterialPageRoute(builder: (BuildContext context)=> widget ),result:(route)=>false);

void printFullText(String text){
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match)=>print(match.group(0)));
}