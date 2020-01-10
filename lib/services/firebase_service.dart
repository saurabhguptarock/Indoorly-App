import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:indoorly/model/model.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
]);
final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _firestore = Firestore.instance;

Future<void> login() async {
  GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  AuthResult result = await _auth.signInWithCredential(credential);
  createUserDatabase(result.user);
}

Future<void> createUserDatabase(FirebaseUser user) async {
  var doc = await _firestore.document('users/${user.uid}').get();
  if (!doc.exists) {
    var userRef = _firestore.document('users/${user.uid}');
    var data = {
      'uid': user.uid,
      'photoUrl': user.photoUrl,
      'name': user.displayName,
      'email': user.email,
    };
    userRef.setData(data, merge: true);
  }
}

Stream<User> streamUser(String uid) {
  return _firestore
      .collection('users')
      .document(uid)
      .snapshots()
      .map((snap) => User.fromMap(snap.data));
}

Stream<List<Product>> streamProducts(String uid) {
  return _firestore
      .collection('users')
      .document(uid)
      .collection('cart')
      .snapshots()
      .map((list) =>
          list.documents.map((data) => Product.fromFirestore(data)).toList());
}

void addProduct(String uid, Product product) async {
  DocumentReference doc = await _firestore
      .collection('users')
      .document(uid)
      .collection('cart')
      .add({
    'amount': product.amount,
    'price': product.price,
    'name': product.name,
    'quantity': product.quantity,
    'id': '',
  });
  doc.updateData({'id': doc.documentID});
}

void deleteAllProducts(String uid) async {
  QuerySnapshot query = await _firestore
      .collection('users')
      .document(uid)
      .collection('cart')
      .getDocuments();
  query.documents.forEach((doc) {
    doc.reference.delete();
  });
}

void updateQuantity(String uid, String docId, int val, int price) {
  _firestore
      .collection('users')
      .document(uid)
      .collection('cart')
      .document(docId)
      .updateData({
    'quantity': FieldValue.increment(val),
    'amount': FieldValue.increment(val * price)
  });
}

void deleteProduct(String uid, String docId) {
  _firestore
      .collection('users')
      .document(uid)
      .collection('cart')
      .document(docId)
      .delete();
}

void signOut() {
  _auth.signOut();
}
