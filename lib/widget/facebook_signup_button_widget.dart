
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignUpButtonWidget extends StatefulWidget {
  const FacebookSignUpButtonWidget({Key? key}) : super(key: key);

  @override
  _FacebookSignUpButtonWidgetState createState() => _FacebookSignUpButtonWidgetState();
}

class _FacebookSignUpButtonWidgetState extends State<FacebookSignUpButtonWidget> {

  bool loggedIn = false;

  AccessToken? _accessToken;
  UserModel? _currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: _buildWidget(),
    );
  }

  _buildWidget()  {
    UserModel? user=_currentUser;
    if(user!=null)
      {
        return Padding(padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: user.pictureModel!.width! / 6,
                  backgroundImage: NetworkImage(user.pictureModel!.url!),
                ),
                title: Text(user.name!),
                subtitle: Text(user.email!),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: signOut, child: const Text("Sign Out"),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  primary: Colors.orangeAccent,
                  onPrimary: Colors.black,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        );
      }
    else{
      return Padding(padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          const SizedBox(height: 10,),
          ElevatedButton.icon(
            icon: Icon(Icons.facebook,
            color: Colors.blue,
            size: 30,),
            onPressed: signIn, label: const Text("Sign In with facebook"),
            style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),
              side: BorderSide(color: Colors.black)
            ),
            primary: Colors.white,
            onPrimary: Colors.black,
            textStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),

          ),
        ],
      ),
      );
    }
  }

  Future<void> signIn() async{
    final LoginResult result=await FacebookAuth.i.login();

    if(result.status == LoginStatus.success)
      {
        _accessToken = result.accessToken;

        final data = await FacebookAuth.i.getUserData();
        UserModel model = UserModel.fromJson(data);
        _currentUser = model;
        setState(() {

        });
      }
  }

  Future<void> signOut() async
  {
    _currentUser = null;
    _accessToken = null;
    setState(() {

    });

  }
}

class UserModel
{
  final String? email;
  final String? id;
  final String? name;
  final PictureModel? pictureModel;

  const UserModel({this.name,this.pictureModel,this.email,this.id});

  factory UserModel.fromJson(Map<String, dynamic>json)=>
      UserModel(
          email: json['email'],
          id: json['id'] as String?,
          name: json['name'],
          pictureModel: PictureModel.fromJson(json['picture']['data'])
  );
/*
  Sample result of get user data method
  {
    "email" = "dsmr.apps@gmail.com",
    "id" = 3003332493073668,
    "name" = "Darwin Morocho",
    "picture" = {
        "data" = {
            "height" = 50,
            "is_silhouette" = 0,
            "url" = "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3003332493073668",
            "width" = 50,
        },
    }
}
   */
}

class PictureModel
{
  final String? url;
  final int? width;
  final int? height;

  const PictureModel({this.width,this.height,this.url});

  factory PictureModel.fromJson(Map<String,dynamic> json) =>
      PictureModel(
        url: json['url'],
        width: json['width'],
        height: json['height']
      );

}

