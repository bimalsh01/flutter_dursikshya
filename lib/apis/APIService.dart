
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIService{

  Future<bool> login(String email, String password) async {
      bool isLogin = false;
      String? uid;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try{
        await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email, password: password)
          .then((value) => {
                uid = value.user!.uid,

                isLogin = true
              })
          .onError((error, stackTrace) => {
                isLogin = false
              });
      } catch(e){
        print(e);
      }

      return isLogin;
  }

  // Future<bool> register(String email, String password, String username, String firstname, String lastname){

  // }



  
}