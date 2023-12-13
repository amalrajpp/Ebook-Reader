import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;
String? userId = user?.uid;

// Function to add a diary entry
Future<void> addDiaryEntry(String diaryContent, DateTime entryDate) async {
  //final user = FirebaseAuth.instance.currentUser;

  //if (user != null) {
  //final userDocRef =
  //    FirebaseFirestore.instance.collection('users').doc(user.uid);
  final userDocRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('diaryEntries');

  userDocRef.add({
    'content': diaryContent,
    'timestamp': entryDate, // Optional: Record the timestamp
  });
  print("success");
  // } else {
  // Handle the case where the user is not logged in
//}
}
