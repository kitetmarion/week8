// import '../models/community.dart';
// import '../services/auth_service.dart';

// class CommunityService {
//   static final List<CommunityPost> _posts = [];
//   static final List<Comment> _comments = [];
//   static final List<CommunityChallenge> _challenges = [];
//   static final List<LeaderboardEntry> _leaderboard = [];
//   static final List<ChatRoom> _chatRooms = [];
//   static final List<ChatMessage> _messages = [];
//   static final List<ReportData> _reports = [];

//   // Posts & Feed
//   static Future<List<CommunityPost>> getFeedPosts({String category = 'all'}) async {
//     await Future.delayed(Duration(milliseconds: 500));
    
//     // Generate sample posts if empty
//     if (_posts.isEmpty) {
//       _generateSamplePosts();
//     }
    
//     if (category == 'all') {
//       return List.from(_posts)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
//     }
    
//     return _posts.where((post) => post.category == category).toList()
//       ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
//   }

//   static Future<void> createPost(CommunityPost post) async {
//     await Future.delayed(Duration(milliseconds: 300));
//     _posts.add(post);
//   }

//   static Future<void> likePost(String postId) async {
//     await Future.delayed(Duration(milliseconds: 200));
//     final index = _posts.indexWhere((post) => post.id == postId);
//     if (index != -1) {
//       final post = _posts[index];
//       _posts[index] = CommunityPost(
//         id: post.id,
//         userId: post.userId,
//         username: post.username,
//         displayName: post.displayName,
//         userProfileImage: post.userProfileImage,
//         content: post.content,
//         imageUrls: post.imageUrls,
//         postType: post.postType,
//         category: post.category,
//         createdAt: post.createdAt,
//         likesCount: post.isLikedByCurrentUser ? post.likesCount - 1 : post.likesCount + 1,
//         commentsCount: post.commentsCount,
//         isLikedByCurrentUser: !post.isLikedByCurrentUser,
//         tags: post.tags,
//         progressData: post.progressData,
//       );
//     }
//   }

//   static Future<void> addComment(Comment comment) async {
//     await Future.delayed(Duration(milliseconds: 300));
//     _comments.add(comment);
    
//     // Update post comment count
//     final postIndex = _posts.indexWhere((post) => post.id == comment.postId);
//     if (postIndex != -1) {
//       final post = _posts[postIndex];
//       _posts[postIndex] = CommunityPost(
//         id: post.id,
//         userId: post.userId,
//         username: post.username,
//         displayName: post.displayName,
//         userProfileImage: post.userProfileImage,
//         content: post.content,
//         imageUrls: post.imageUrls,
//         postType: post.postType,
//         category: post.category,
//         createdAt: post.createdAt,
//         likesCount: post.likesCount,
//         commentsCount: post.commentsCount + 1,
//         isLikedByCurrentUser: post.isLikedByCurrentUser,
//         tags: post.tags,
//         progressData: post.progressData,
//       );
//     }
//   }

//   static Future<List<Comment>> getPostComments(String postId) async {
//     await Future.delayed(Duration(milliseconds: 300));
//     return _comments.where((comment) => comment.postId == postId).toList()
//       ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
//   }

//   // Forum Topics
//   static Future<List<ForumTopic>> getForumTopics() async {
//     await Future.delayed(Duration(milliseconds: 500));
//     return [
//       ForumTopic(
//         id: '1',
//         title: 'Weight Loss Journey',
//         description: 'Share your weight loss progress and get support',
//         category: 'fitness',
//         iconEmoji: '🏃‍♀️',
//         subscribersCount: 1250,
//         postsCount: 89,
//         lastActivity: DateTime.now().subtract(Duration(minutes: 15)),
//         isSubscribed: true,
//       ),
//       ForumTopic(
//         id: '2',
//         title: 'Muscle Building',
//         description: 'Tips and progress for gaining muscle mass',
//         category: 'fitness',
//         iconEmoji: '💪',
//         subscribersCount: 980,
//         postsCount: 156,
//         lastActivity: DateTime.now().subtract(Duration(hours: 2)),
//       ),
//       ForumTopic(
//         id: '3',
//         title: 'Mental Health Support',
//         description: 'A safe space to discuss mental wellness',
//         category: 'mental_health',
//         iconEmoji: '🧠',
//         subscribersCount: 2100,
//         postsCount: 234,
//         lastActivity: DateTime.now().subtract(Duration(minutes: 30)),
//         isSubscribed: true,
//       ),
//       ForumTopic(
//         id: '4',
//         title: 'Nutrition Tips',
//         description: 'Share healthy recipes and nutrition advice',
//         category: 'nutrition',
//         iconEmoji: '🥗',
//         subscribersCount: 1680,
//         postsCount: 312,
//         lastActivity: DateTime.now().subtract(Duration(hours: 1)),
//       ),
//       ForumTopic(
//         id: '5',
//         title: 'Newbie Questions',
//         description: 'Ask anything - we\'re here to help!',
//         category: 'general',
//         iconEmoji: '❓',
//         subscribersCount: 890,
//         postsCount: 445,
//         lastActivity: DateTime.now().subtract(Duration(minutes: 45)),
//       ),
//       ForumTopic(
//         id: '6',
//         title: 'Meditation & Mindfulness',
//         description: 'Share meditation experiences and techniques',
//         category: 'mental_health',
//         iconEmoji: '🧘‍♀️',
//         subscribersCount: 756,
//         postsCount: 123,
//         lastActivity: DateTime.now().subtract(Duration(hours: 3)),
//       ),
//     ];
//   }

//   static Future<void> subscribeToTopic(String topicId) async {
//     await Future.delayed(Duration(milliseconds: 300));
//     // Implementation would update subscription status
//   }

//   // Challenges & Leaderboard
//   static Future<List<CommunityChallenge>> getCommunityhallenges() async {
//     await Future.delayed(Duration(milliseconds: 500));
    
//     if (_challenges.isEmpty) {
//       _generateSampleChallenges();
//     }
    
//     return List.from(_challenges);
//   }

//   static Future<void> joinChallenge(String challengeId) async {
//     await Future.delayed(Duration(milliseconds: 300));
//     final index = _challenges.indexWhere((c) => c.id == challengeId);
//     if (index != -1) {
//       final challenge = _challenges[index];
//       _challenges[index] = CommunityChallenge(
//         id: challenge.id,
//         title: challenge.title,
//         description: challenge.description,
//         type: challenge.type,
//         goal: challenge.goal,
//         startDate: challenge.startDate,
//         endDate: challenge.endDate,
//         participantsCount: challenge.participantsCount + 1,
//         isParticipating: true,
//         prize: challenge.prize,
//         rules: challenge.rules,
//       );
//     }
//   }

//   static Future<List<LeaderboardEntry>> getLeaderboard(String challengeId) async {
//     await Future.delayed(Duration(milliseconds: 500));
    
//     if (_leaderboard.isEmpty) {
//       _generateSampleLeaderboard(challengeId);
//     }
    
//     return _leaderboard.where((entry) => entry.challengeId == challengeId).toList()
//       ..sort((a, b) => a.rank.compareTo(b.rank));
//   }

//   // Chat & Messaging
//   static Future<List<ChatRoom>> getChatRooms() async {
//     await Future.delayed(Duration(milliseconds: 500));
    
//     if (_chatRooms.isEmpty) {
//       _generateSampleChatRooms();
//     }
    
//     return List.from(_chatRooms)..sort((a, b) => b.lastActivity.compareTo(a.lastActivity));
//   }

//   static Future<List<ChatMessage>> getChatMessages(String roomId) async {
//     await Future.delayed(Duration(milliseconds: 300));
//     return _messages.where((message) => message.id.startsWith(roomId)).toList()
//       ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
//   }

//   static Future<void> sendMessage(String roomId, String content) async {
//     await Future.delayed(Duration(milliseconds: 200));
//     final currentUser = AuthService.getCurrentUser();
//     if (currentUser != null) {
//       final message = ChatMessage(
//         id: '${roomId}_${DateTime.now().millisecondsSinceEpoch}',
//         senderId: 'current_user',
//         senderUsername: currentUser.username,
//         senderDisplayName: currentUser.fullName,
//         content: content,
//         timestamp: DateTime.now(),
//       );
//       _messages.add(message);
//     }
//   }

//   // Safety & Moderation
//   static Future<void> reportContent({
//     required String contentId,
//     required String contentType,
//     required String reason,
//     String description = '',
//   }) async {
//     await Future.delayed(Duration(milliseconds: 300));
    
//     final report = ReportData(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       reporterId: 'current_user',
//       contentId: contentId,
//       contentType: contentType,
//       reason: reason,
//       description: description,
//       createdAt: DateTime.now(),
//     );
    
//     _reports.add(report);
//   }

//   static Future<bool> checkContentSafety(String content) async {
//     await Future.delayed(Duration(milliseconds: 200));
    
//     // Simple keyword flagging
//     final flaggedWords = [
//       'hate', 'harmful', 'dangerous', 'suicide', 'self-harm'
//     ];
    
//     final lowerContent = content.toLowerCase();
//     return !flaggedWords.any((word) => lowerContent.contains(word));
//   }

//   // User Profiles
//   static Future<CommunityUser> getUserProfile(String userId) async {
//     await Future.delayed(Duration(milliseconds: 300));
    
//     // Return sample user profile
//     return CommunityUser(
//       id: userId,
//       username: 'fitness_enthusiast',
//       displayName: 'Alex Johnson',
//       bio: 'Fitness lover, mental health advocate. On a journey to better myself every day! 💪',
//       profileImageUrl: '/placeholder.svg?height=100&width=100',
//       fitnessGoals: ['Weight Loss', 'Muscle Gain', 'Endurance'],
//       mentalFocus: 'Stress Management & Mindfulness',
//       totalCaloriesBurned: 15420,
//       currentStreak: 12,
//       joinDate: DateTime.now().subtract(Duration(days: 180)),
//       followingTopics: ['Weight Loss Journey', 'Mental Health Support'],
//       postsCount: 23,
//       followersCount: 156,
//       followingCount: 89,
//     );
//   }

//   // Helper methods to generate sample data
//   static void _generateSamplePosts() {
//     final samplePosts = [
//       CommunityPost(
//         id: '1',
//         userId: 'user1',
//         username: 'fitness_sarah',
//         displayName: 'Sarah M.',
//         userProfileImage: '/placeholder.svg?height=50&width=50',
//         content: 'Just completed my first 5K run! 🏃‍♀️ Feeling amazing and proud of this milestone. The mental clarity after running is incredible!',
//         postType: 'progress',
//         category: 'fitness',
//         createdAt: DateTime.now().subtract(Duration(hours: 2)),
//         likesCount: 24,
//         commentsCount: 8,
//         tags: ['running', 'milestone', 'mentalhealth'],
//         progressData: {'distance': 5.0, 'time': '28:45', 'calories': 320},
//       ),
//       CommunityPost(
//         id: '2',
//         userId: 'user2',
//         username: 'mindful_mike',
//         displayName: 'Mike Chen',
//         userProfileImage: '/placeholder.svg?height=50&width=50',
//         content: 'Daily reminder: It\'s okay to have bad days. What matters is that you keep showing up for yourself. 💙 #MentalHealthMatters',
//         postType: 'reflection',
//         category: 'mental_health',
//         createdAt: DateTime.now().subtract(Duration(hours: 4)),
//         likesCount: 67,
//         commentsCount: 15,
//         tags: ['mentalhealth', 'motivation', 'selfcare'],
//       ),
//       CommunityPost(
//         id: '3',
//         userId: 'user3',
//         username: 'nutrition_nina',
//         displayName: 'Nina Rodriguez',
//         userProfileImage: '/placeholder.svg?height=50&width=50',
//         content: 'Quick tip: Prep your meals on Sunday! It saves so much time during the week and helps you stick to your nutrition goals. What\'s your favorite meal prep recipe?',
//         postType: 'tip',
//         category: 'nutrition',
//         createdAt: DateTime.now().subtract(Duration(hours: 6)),
//         likesCount: 43,
//         commentsCount: 22,
//         tags: ['mealprep', 'nutrition', 'tips'],
//       ),
//       CommunityPost(
//         id: '4',
//         userId: 'user4',
//         username: 'newbie_alex',
//         displayName: 'Alex Thompson',
//         userProfileImage: '/placeholder.svg?height=50&width=50',
//         content: 'New to fitness - any beginner-friendly workout recommendations? Feeling a bit overwhelmed with all the options out there!',
//         postType: 'question',
//         category: 'fitness',
//         createdAt: DateTime.now().subtract(Duration(hours: 8)),
//         likesCount: 12,
//         commentsCount: 31,
//         tags: ['beginner', 'workout', 'help'],
//       ),
//     ];
    
//     _posts.addAll(samplePosts);
//   }

//   static void _generateSampleChallenges() {
//     final now = DateTime.now();
//     final sampleChallenges = [
//       CommunityChallenge(
//         id: '1',
//         title: '10K Steps Daily Challenge',
//         description: 'Walk 10,000 steps every day for 30 days',
//         type: 'fitness',
//         goal: {'steps': 10000, 'duration': 30},
//         startDate: now.subtract(Duration(days: 5)),
//         endDate: now.add(Duration(days: 25)),
//         participantsCount: 1247,
//         prize: 'Fitness Tracker & Wellness Bundle',
//         rules: [
//           'Track steps using any fitness app or device',
//           'Post daily progress in the community',
//           'Support fellow participants',
//           'Complete at least 25 out of 30 days to qualify'
//         ],
//       ),
//       CommunityChallenge(
//         id: '2',
//         title: '7-Day Meditation Streak',
//         description: 'Meditate for at least 10 minutes daily for 7 days',
//         type: 'mental_health',
//         goal: {'minutes': 10, 'duration': 7},
//         startDate: now.subtract(Duration(days: 2)),
//         endDate: now.add(Duration(days: 5)),
//         participantsCount: 892,
//         prize: 'Premium Meditation App Subscription',
//         rules: [
//           'Meditate for minimum 10 minutes daily',
//           'Use any meditation technique or app',
//           'Share your experience in the community',
//           'Complete all 7 days to qualify'
//         ],
//       ),
//       CommunityChallenge(
//         id: '3',
//         title: 'Hydration Hero Challenge',
//         description: 'Drink 8 glasses of water daily for 21 days',
//         type: 'nutrition',
//         goal: {'glasses': 8, 'duration': 21},
//         startDate: now.add(Duration(days: 3)),
//         endDate: now.add(Duration(days: 24)),
//         participantsCount: 567,
//         prize: 'Smart Water Bottle & Wellness Kit',
//         rules: [
//           'Drink at least 8 glasses (64oz) of water daily',
//           'Track your intake using any method',
//           'Share tips and motivation',
//           'Complete at least 18 out of 21 days'
//         ],
//       ),
//     ];
    
//     _challenges.addAll(sampleChallenges);
//   }

//   static void _generateSampleLeaderboard(String challengeId) {
//     final sampleEntries = [
//       LeaderboardEntry(
//         userId: 'user1',
//         username: 'step_master',
//         displayName: 'Jessica Liu',
//         profileImageUrl: '/placeholder.svg?height=50&width=50',
//         score: 12500,
//         rank: 1,
//         challengeId: challengeId,
//         progress: {'days_completed': 5, 'avg_steps': 12500},
//       ),
//       LeaderboardEntry(
//         userId: 'user2',
//         username: 'walker_pro',
//         displayName: 'David Kim',
//         profileImageUrl: '/placeholder.svg?height=50&width=50',
//         score: 11800,
//         rank: 2,
//         challengeId: challengeId,
//         progress: {'days_completed': 5, 'avg_steps': 11800},
//       ),
//       LeaderboardEntry(
//         userId: 'user3',
//         username: 'fitness_fan',
//         displayName: 'Maria Garcia',
//         profileImageUrl: '/placeholder.svg?height=50&width=50',
//         score: 11200,
//         rank: 3,
//         challengeId: challengeId,
//         progress: {'days_completed': 4, 'avg_steps': 11200},
//       ),
//     ];
    
//     _leaderboard.addAll(sampleEntries);
//   }

//   static void _generateSampleChatRooms() {
//     final sampleRooms = [
//       ChatRoom(
//         id: 'room1',
//         name: 'Weight Loss Support',
//         type: 'group',
//         participantIds: ['user1', 'user2', 'user3', 'current_user'],
//         lastMessage: ChatMessage(
//           id: 'room1_msg1',
//           senderId: 'user1',
//           senderUsername: 'sarah_fit',
//           senderDisplayName: 'Sarah',
//           content: 'Great workout today everyone! 💪',
//           timestamp: DateTime.now().subtract(Duration(minutes: 15)),
//         ),
//         unreadCount: 2,
//         lastActivity: DateTime.now().subtract(Duration(minutes: 15)),
//       ),
//       ChatRoom(
//         id: 'room2',
//         name: 'Mindfulness Circle',
//         type: 'group',
//         participantIds: ['user4', 'user5', 'current_user'],
//         lastMessage: ChatMessage(
//           id: 'room2_msg1',
//           senderId: 'user4',
//           senderUsername: 'zen_master',
//           senderDisplayName: 'Alex',
//           content: 'Anyone up for a group meditation session?',
//           timestamp: DateTime.now().subtract(Duration(hours: 1)),
//         ),
//         unreadCount: 0,
//         lastActivity: DateTime.now().subtract(Duration(hours: 1)),
//       ),
//     ];
    
//     _chatRooms.addAll(sampleRooms);
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/community.dart';
import 'firebase_service.dart';

class CommunityService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;
  static final FirebaseAuth _auth = FirebaseService.auth;

  // Posts & Feed
  static Future<List<CommunityPost>> getFeedPosts({String category = 'all'}) async {
    try {
      Query query = FirebaseService.postsCollection.orderBy('createdAt', descending: true);
      
      if (category != 'all') {
        query = query.where('category', isEqualTo: category);
      }
      
      QuerySnapshot snapshot = await query.limit(50).get();
      
      List<CommunityPost> posts = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        
        // Check if current user liked this post
        if (_auth.currentUser != null) {
          DocumentSnapshot likeDoc = await doc.reference
              .collection('likes')
              .doc(_auth.currentUser!.uid)
              .get();
          data['isLikedByCurrentUser'] = likeDoc.exists;
        }
        
        posts.add(CommunityPost.fromJson(data));
      }
      
      return posts;
    } catch (e) {
      print('Error getting feed posts: $e');
      return [];
    }
  }

  static Future<bool> createPost(CommunityPost post) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Get user data
      DocumentSnapshot userDoc = await FirebaseService.getUserDocument(currentUser.uid).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      Map<String, dynamic> postData = {
        'userId': currentUser.uid,
        'username': userData['username'] ?? '',
        'displayName': userData['fullName'] ?? '',
        'userProfileImage': userData['profileImageUrl'] ?? '',
        'content': post.content,
        'imageUrls': post.imageUrls,
        'postType': post.postType,
        'category': post.category,
        'createdAt': FieldValue.serverTimestamp(),
        'likesCount': 0,
        'commentsCount': 0,
        'tags': post.tags,
        'progressData': post.progressData,
      };

      await FirebaseService.postsCollection.add(postData);
      
      // Update user's post count
      await FirebaseService.getUserDocument(currentUser.uid).update({
        'postsCount': FieldValue.increment(1),
      });

      return true;
    } catch (e) {
      print('Error creating post: $e');
      return false;
    }
  }

  static Future<bool> likePost(String postId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      DocumentReference postRef = FirebaseService.postsCollection.doc(postId);
      DocumentReference likeRef = postRef.collection('likes').doc(currentUser.uid);
      
      DocumentSnapshot likeDoc = await likeRef.get();
      
      if (likeDoc.exists) {
        // Unlike the post
        await likeRef.delete();
        await postRef.update({
          'likesCount': FieldValue.increment(-1),
        });
      } else {
        // Like the post
        await likeRef.set({
          'userId': currentUser.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        await postRef.update({
          'likesCount': FieldValue.increment(1),
        });
      }

      return true;
    } catch (e) {
      print('Error liking post: $e');
      return false;
    }
  }

  static Future<bool> addComment(Comment comment) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Get user data
      DocumentSnapshot userDoc = await FirebaseService.getUserDocument(currentUser.uid).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      Map<String, dynamic> commentData = {
        'postId': comment.postId,
        'userId': currentUser.uid,
        'username': userData['username'] ?? '',
        'displayName': userData['fullName'] ?? '',
        'userProfileImage': userData['profileImageUrl'] ?? '',
        'content': comment.content,
        'createdAt': FieldValue.serverTimestamp(),
        'likesCount': 0,
      };

      await FirebaseService.commentsCollection.add(commentData);
      
      // Update post comment count
      await FirebaseService.postsCollection.doc(comment.postId).update({
        'commentsCount': FieldValue.increment(1),
      });

      return true;
    } catch (e) {
      print('Error adding comment: $e');
      return false;
    }
  }

  static Future<List<Comment>> getPostComments(String postId) async {
    try {
      QuerySnapshot snapshot = await FirebaseService.commentsCollection
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: false)
          .get();

      List<Comment> comments = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        comments.add(Comment.fromJson(data));
      }

      return comments;
    } catch (e) {
      print('Error getting comments: $e');
      return [];
    }
  }

  // Forum Topics
  static Future<List<ForumTopic>> getForumTopics() async {
    try {
      QuerySnapshot snapshot = await FirebaseService.forumsCollection
          .orderBy('subscribersCount', descending: true)
          .get();

      List<ForumTopic> topics = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        
        // Check if current user is subscribed
        if (_auth.currentUser != null) {
          DocumentSnapshot subDoc = await doc.reference
              .collection('subscribers')
              .doc(_auth.currentUser!.uid)
              .get();
          data['isSubscribed'] = subDoc.exists;
        }
        
        topics.add(ForumTopic.fromJson(data));
      }

      return topics;
    } catch (e) {
      print('Error getting forum topics: $e');
      return _getDefaultForumTopics();
    }
  }

  static Future<bool> subscribeToTopic(String topicId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      DocumentReference topicRef = FirebaseService.forumsCollection.doc(topicId);
      DocumentReference subRef = topicRef.collection('subscribers').doc(currentUser.uid);
      
      DocumentSnapshot subDoc = await subRef.get();
      
      if (subDoc.exists) {
        // Unsubscribe
        await subRef.delete();
        await topicRef.update({
          'subscribersCount': FieldValue.increment(-1),
        });
      } else {
        // Subscribe
        await subRef.set({
          'userId': currentUser.uid,
          'subscribedAt': FieldValue.serverTimestamp(),
        });
        await topicRef.update({
          'subscribersCount': FieldValue.increment(1),
        });
      }

      return true;
    } catch (e) {
      print('Error subscribing to topic: $e');
      return false;
    }
  }

  // Challenges & Leaderboard
  static Future<List<CommunityChallenge>> getCommunityhallenges() async {
    try {
      QuerySnapshot snapshot = await FirebaseService.challengesCollection
          .where('endDate', isGreaterThan: Timestamp.now())
          .orderBy('endDate')
          .get();

      List<CommunityChallenge> challenges = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        
        // Check if current user is participating
        if (_auth.currentUser != null) {
          DocumentSnapshot participantDoc = await doc.reference
              .collection('participants')
              .doc(_auth.currentUser!.uid)
              .get();
          data['isParticipating'] = participantDoc.exists;
        }
        
        challenges.add(CommunityChallenge.fromJson(data));
      }

      return challenges;
    } catch (e) {
      print('Error getting challenges: $e');
      return _getDefaultChallenges();
    }
  }

  static Future<bool> joinChallenge(String challengeId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      DocumentReference challengeRef = FirebaseService.challengesCollection.doc(challengeId);
      DocumentReference participantRef = challengeRef.collection('participants').doc(currentUser.uid);
      
      await participantRef.set({
        'userId': currentUser.uid,
        'joinedAt': FieldValue.serverTimestamp(),
        'progress': {},
        'score': 0,
      });
      
      await challengeRef.update({
        'participantsCount': FieldValue.increment(1),
      });

      return true;
    } catch (e) {
      print('Error joining challenge: $e');
      return false;
    }
  }

  static Future<List<LeaderboardEntry>> getLeaderboard(String challengeId) async {
    try {
      QuerySnapshot snapshot = await FirebaseService.challengesCollection
          .doc(challengeId)
          .collection('participants')
          .orderBy('score', descending: true)
          .limit(50)
          .get();

      List<LeaderboardEntry> entries = [];
      int rank = 1;
      
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        // Get user data
        DocumentSnapshot userDoc = await FirebaseService.getUserDocument(data['userId']).get();
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        
        entries.add(LeaderboardEntry(
          userId: data['userId'],
          username: userData['username'] ?? '',
          displayName: userData['fullName'] ?? '',
          profileImageUrl: userData['profileImageUrl'] ?? '',
          score: data['score'] ?? 0,
          rank: rank++,
          challengeId: challengeId,
          progress: data['progress'] ?? {},
        ));
      }

      return entries;
    } catch (e) {
      print('Error getting leaderboard: $e');
      return [];
    }
  }

  // Safety & Moderation
  static Future<bool> reportContent({
    required String contentId,
    required String contentType,
    required String reason,
    String description = '',
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      await FirebaseService.reportsCollection.add({
        'reporterId': currentUser.uid,
        'contentId': contentId,
        'contentType': contentType,
        'reason': reason,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      return true;
    } catch (e) {
      print('Error reporting content: $e');
      return false;
    }
  }

  static Future<bool> checkContentSafety(String content) async {
    // Simple keyword flagging
    final flaggedWords = [
      'hate', 'harmful', 'dangerous', 'suicide', 'self-harm'
    ];
    
    final lowerContent = content.toLowerCase();
    return !flaggedWords.any((word) => lowerContent.contains(word));
  }

  // User Profiles
  static Future<CommunityUser?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseService.getUserDocument(userId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CommunityUser.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Helper methods for default data when Firebase is empty
  static List<ForumTopic> _getDefaultForumTopics() {
    return [
      ForumTopic(
        id: '1',
        title: 'Weight Loss Journey',
        description: 'Share your weight loss progress and get support',
        category: 'fitness',
        iconEmoji: '🏃‍♀️',
        subscribersCount: 1250,
        postsCount: 89,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 15)),
        isSubscribed: false,
      ),
      ForumTopic(
        id: '2',
        title: 'Mental Health Support',
        description: 'A safe space to discuss mental wellness',
        category: 'mental_health',
        iconEmoji: '🧠',
        subscribersCount: 2100,
        postsCount: 234,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 30)),
        isSubscribed: false,
      ),
      // Add more default topics as needed
    ];
  }

  static List<CommunityChallenge> _getDefaultChallenges() {
    final now = DateTime.now();
    return [
      CommunityChallenge(
        id: '1',
        title: '10K Steps Daily Challenge',
        description: 'Walk 10,000 steps every day for 30 days',
        type: 'fitness',
        goal: {'steps': 10000, 'duration': 30},
        startDate: now.subtract(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 25)),
        participantsCount: 1247,
        prize: 'Fitness Tracker & Wellness Bundle',
        rules: [
          'Track steps using any fitness app or device',
          'Post daily progress in the community',
          'Support fellow participants',
          'Complete at least 25 out of 30 days to qualify'
        ],
      ),
      // Add more default challenges as needed
    ];
  }
}
