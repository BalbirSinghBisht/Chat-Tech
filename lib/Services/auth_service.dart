import 'package:chattech/helper/helper_functions.dart';
import 'package:chattech/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database_service.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users? _userFromFirebaseUser(User user){
    return (user !=null) ? Users(uid: user.uid): null;
  }

  Future signInwithEmail(String email, String password) async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmail(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await DatabaseService(uid: user!.uid).updateUserData(email,password);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async{
    try{
      await HelperFunctions.saveUserLoggedIn(false);
      await HelperFunctions.saveUserEmail('');
      await HelperFunctions.saveUserName('');

      return await _auth.signOut().whenComplete(() async{
        print('Logged Out');
        await HelperFunctions.getUserLoggedIn().then((value) {
          print("Logged In: $value");
        });
        await HelperFunctions.getUserEmail().then((value) {
          print("Email: $value");
        });
        await HelperFunctions.getUserName().then((value) {
          print("Full Name: $value");
        });
      });
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}