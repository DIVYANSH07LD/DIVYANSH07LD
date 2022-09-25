import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignController extends GetxController{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  loginWithGoogle()async{
        try{
          /// it holds the fields which identify the user
          final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
          ///it stores the user token
          final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount!.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication!.accessToken,
            idToken: googleSignInAuthentication.idToken
          );
          final authResult = await _firebaseAuth.signInWithCredential(credential);

          final User? user = authResult.user;

          assert(user!.isAnonymous);
          assert(user!.getIdToken()!=null);

          final User? currentUser = _firebaseAuth.currentUser;
          print("SIGN IN DONW");
        }
            catch(e){
          throw(e);
            }
  }

  Future<void> logOut()async{
    await _firebaseAuth.signOut();
    print("logout done");
  }

}