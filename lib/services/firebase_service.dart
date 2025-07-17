// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class FirebaseService {
//   static FirebaseAuth get auth => FirebaseAuth.instance;
//   static FirebaseFirestore get firestore => FirebaseFirestore.instance;
//   static FirebaseStorage get storage => FirebaseStorage.instance;

//   // Initialize Firebase
//   static Future<void> initialize() async {
//     await Firebase.initializeApp();
//   }

//   // Get current user
//   static User? getCurrentUser() {
//     return auth.currentUser;
//   }

//   // Check if user is logged in
//   static bool isUserLoggedIn() {
//     return auth.currentUser != null;
//   }

//   // Sign out
//   static Future<void> signOut() async {
//     await auth.signOut();
//   }

//   // Collections references
//   static CollectionReference get usersCollection => 
//       firestore.collection('users');
  
//   static CollectionReference get postsCollection => 
//       firestore.collection('posts');
  
//   static CollectionReference get commentsCollection => 
//       firestore.collection('comments');
  
//   static CollectionReference get challengesCollection => 
//       firestore.collection('challenges');
  
//   static CollectionReference get forumsCollection => 
//       firestore.collection('forums');
  
//   static CollectionReference get chatRoomsCollection => 
//       firestore.collection('chatRooms');
  
//   static CollectionReference get messagesCollection => 
//       firestore.collection('messages');
  
//   static CollectionReference get workoutsCollection => 
//       firestore.collection('workouts');
  
//   static CollectionReference get mealsCollection => 
//       firestore.collection('meals');
  
//   static CollectionReference get moodEntriesCollection => 
//       firestore.collection('moodEntries');
  
//   static CollectionReference get reportsCollection => 
//       firestore.collection('reports');

//   // Helper method to get user document
//   static DocumentReference getUserDocument(String userId) {
//     return usersCollection.doc(userId);
//   }

//   // Helper method to get subcollection
//   static CollectionReference getUserSubcollection(String userId, String subcollection) {
//     return getUserDocument(userId).collection(subcollection);
//   }
// }


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;

  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // Collection references
  static CollectionReference get usersCollection => firestore.collection('users');
  static CollectionReference get postsCollection => firestore.collection('posts');
  static CollectionReference get commentsCollection => firestore.collection('comments');
  static CollectionReference get challengesCollection => firestore.collection('challenges');
  static CollectionReference get forumsCollection => firestore.collection('forums');
  static CollectionReference get chatRoomsCollection => firestore.collection('chatRooms');
  static CollectionReference get messagesCollection => firestore.collection('messages');
  static CollectionReference get reportsCollection => firestore.collection('reports');
  static CollectionReference get workoutsCollection => firestore.collection('workouts');
  static CollectionReference get foodDatabaseCollection => firestore.collection('foodDatabase');
  static CollectionReference get mentalHealthCollection => firestore.collection('mentalHealth');

  // Document references
  static DocumentReference getUserDocument(String uid) => usersCollection.doc(uid);
  static DocumentReference getPostDocument(String postId) => postsCollection.doc(postId);
  static DocumentReference getCommentDocument(String commentId) => commentsCollection.doc(commentId);
  static DocumentReference getChallengeDocument(String challengeId) => challengesCollection.doc(challengeId);
  static DocumentReference getForumDocument(String forumId) => forumsCollection.doc(forumId);
  static DocumentReference getChatRoomDocument(String roomId) => chatRoomsCollection.doc(roomId);
  static DocumentReference getMessageDocument(String messageId) => messagesCollection.doc(messageId);
  static DocumentReference getReportDocument(String reportId) => reportsCollection.doc(reportId);
  static DocumentReference getWorkoutDocument(String workoutId) => workoutsCollection.doc(workoutId);
  static DocumentReference getFoodDatabaseDocument(String entryId) => foodDatabaseCollection.doc(entryId);
  static DocumentReference getMentalHealthDocument(String entryId) => mentalHealthCollection.doc(entryId);

  // Subcollection references
  static CollectionReference getPostLikes(String postId) => 
      getPostDocument(postId).collection('likes');
  
  static CollectionReference getPostComments(String postId) => 
      getPostDocument(postId).collection('comments');
  
  static CollectionReference getChallengeParticipants(String challengeId) => 
      getChallengeDocument(challengeId).collection('participants');
  
  static CollectionReference getForumSubscribers(String forumId) => 
      getForumDocument(forumId).collection('subscribers');
  
  static CollectionReference getChatRoomMessages(String roomId) => 
      getChatRoomDocument(roomId).collection('messages');

  // User profile subcollections
  static CollectionReference getUserWorkouts(String uid) => 
      getUserDocument(uid).collection('workouts');
  
  static CollectionReference getUserFoodEntries(String uid) => 
      getUserDocument(uid).collection('foodEntries');
  
  static CollectionReference getUserMentalHealth(String uid) => 
      getUserDocument(uid).collection('mentalHealth');
  
  static CollectionReference getUserFollowers(String uid) => 
      getUserDocument(uid).collection('followers');
  
  static CollectionReference getUserFollowing(String uid) => 
      getUserDocument(uid).collection('following');

  // Helper methods
  static String generateId() => firestore.collection('temp').doc().id;
  
  static Timestamp get serverTimestamp => Timestamp.now();
  
  static FieldValue get serverTimestampFieldValue => FieldValue.serverTimestamp();
}
