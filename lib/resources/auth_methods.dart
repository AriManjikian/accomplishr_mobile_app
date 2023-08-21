import 'package:accomplishr_mobile_app/resources/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:accomplishr_mobile_app/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<model.User> getUserDetails() async {
    User? currentUser = _auth.currentUser;

    DocumentSnapshot snap =
        await _firestore.collection('Users').doc(currentUser!.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String confirm,
  }) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          password == confirm) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        model.User user = model.User(
          email: email,
          username: username,
          uid: cred.user!.uid,
        );
        await _firestore
            .collection('Users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "success";
      } else {}
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = "Please Provide Valid Information";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> signOutUser() async {
    String res = "Some error occured";

    try {
      _auth.signOut();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteUser() async {
    String res = "Some error occured";

    try {
      await FirestoreMethods().deleteUser();
      _auth.currentUser!.delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> changePassword(String email) async {
    String res = "Some error occured";

    try {
      await _auth.sendPasswordResetEmail(email: email);
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
