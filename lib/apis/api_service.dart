import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traveldiary/modal/user_modal.dart';
import 'package:traveldiary/state%20management/appdata.dart';

class APIService {
  Future<bool> login(String email, String password, context) async {
    print('login $email $password');
    bool isLogin = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        String uid = value.user!.uid;
        var result =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        var decodedJson = UserModal().fromJson(result.data()!);

        Provider.of<AppData>(context, listen: false).updateUser(
            decodedJson.firstname!,
            decodedJson.lastname!,
            decodedJson.email!,
            decodedJson.username!,
            decodedJson.profile!);

        isLogin = true;
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    } catch (e) {
      print(e);
    }

    return isLogin;
  }
}
