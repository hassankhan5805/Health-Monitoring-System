import 'package:firebase_auth/firebase_auth.dart';

Future<String> createAccount(String name, String email, String pass) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    User authCred = (await auth.createUserWithEmailAndPassword(
            email: email, password: pass))
        .user;
    authCred.updateDisplayName(name);
    return null;
  } catch (e) {
    print("Error Creating Account: $e");
    return e.toString();
  }
}

Future<String> signinWithEmail(String email, String pass) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((value) {
      print('Response from Sign in: $value');
      return null;
    });
  } catch (e) {
    print("Error Signing In: $e");
    return e.toString();
  }
}

Future<String> signOut() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signOut();
    return null;
  } catch (e) {
    print("Error Signing Out: $e");
    return e.toString();
  }
}
