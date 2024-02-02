import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Function to add a diary entry
Future<void> createDemoEntry() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  String? userId = user?.uid;

  String diaryContent =
      "Dear Diary,                        I'm excited to start using this new diary app called Retrospective that I found on the Play Store. I've always wanted to start writing a diary, but never got around to it. I'm hoping that this app will help me create a habit of writing every day. Today was a good day. I woke up early and went for a run. The weather was perfect, and I felt energized. After my run, I had a healthy breakfast and got ready for work. Work was busy, but I managed to get everything done on time.In the evening, I met up with some friends for dinner. We went to a new restaurant that just opened up in town. The food was delicious, and we had a great time catching up. We talked about our future plans and how we can support each other in achieving our goals.In the evening, I met up with some friends for dinner. We went to a new restaurant that just opened up in town. The food was delicious, and we had a great time catching up. We talked about our future plans and how we can support each other in achieving our goals.In the evening, I met up with some friends for dinner. We went to a new restaurant that just opened up in town. The food was delicious, and we had a great time catching up. We talked about our future plans and how we can support each other in achieving our goals.In the evening, I met up with some friends for dinner. We went to a new restaurant that just opened up in town. The food was delicious, and we had a great time catching up. We talked about our future plans and how we can support each other in achieving our goals. In the evening, I met up with some friends for dinner. We went to a new restaurant that just opened up in town. The food was delicious, and we had a great time catching up.Overall, it was a good day. I'm looking forward to writing more in this diary and documenting my life.Overall, it was a good day. I'm looking forward to writing more in this diary and documenting my life.";
  DateTime entryDate = DateTime.now();
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
