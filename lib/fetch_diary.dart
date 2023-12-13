import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;

Future<DocumentSnapshot?> fetchDiaryEntryByDate(String date) async {
  //final user = FirebaseAuth.instance.currentUser;

  //if (user != null) {
  //final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

  String? userId = user?.uid;
  final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

  final diaryEntryRef = userDocRef.collection('diaryEntries').doc(date);

  final diaryEntrySnapshot = await diaryEntryRef.get();
  if (diaryEntrySnapshot.exists) {
    // The document with the specified date exists
    return diaryEntrySnapshot;
  } else {
    // The document does not exist, handle accordingly
    return null;
  }
  //} else {
  // Handle the case where the user is not logged in
  //return null;
  //}
}

Future<List<DocumentSnapshot>> fetchDataBetweenDates(DateTime startDate) async {
  String? userId = user?.uid;
  final collection = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection("diaryEntries");

  QuerySnapshot querySnapshot = await collection
      .where('timestamp', isGreaterThanOrEqualTo: startDate)
      .orderBy('timestamp') // Order documents by date in ascending order
      .limit(4) // Limit the number of documents
      .get();

  return querySnapshot.docs;
}

Future<void> removeDiaryEntryByDate(String did) async {
  //final user = FirebaseAuth.instance.currentUser;

  //if (user != null) {
  //final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  String? userId = user?.uid;
  final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
  final diaryEntryRef = userDocRef.collection('diaryEntries').doc(did);

  try {
    // Delete the document with the specified date
    diaryEntryRef.delete();
    print('Diary entry deleted successfully');
  } catch (e) {
    // Handle any errors or exceptions
    print('Error deleting diary entry: $e');
  }
  //} else {
  // Handle the case where the user is not logged in
  //print('User is not logged in');
  //}
}

Future<void> updateDiaryEntryByDate(
    String did, Map<String, dynamic> newData) async {
  //final user = FirebaseAuth.instance.currentUser;

  //if (user != null) {
  //final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  String? userId = user?.uid;
  final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
  final diaryEntryRef = userDocRef.collection('diaryEntries').doc(did);

  try {
    // Update the document with the specified date and new data
    diaryEntryRef.update(newData);
    print('Diary entry updated successfully');
  } catch (e) {
    // Handle any errors or exceptions
    print('Error updating diary entry: $e');
  }
  //} else {
  // Handle the case where the user is not logged in
  //print('User is not logged in');
  //}
}
