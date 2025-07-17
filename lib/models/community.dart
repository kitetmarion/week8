class CommunityUser {
  final String id;
  final String username;
  final String displayName;
  final String bio;
  final String profileImageUrl;
  final List<String> fitnessGoals;
  final String mentalFocus;
  final int totalCaloriesBurned;
  final int currentStreak;
  final DateTime joinDate;
  final List<String> followingTopics;
  final int postsCount;
  final int followersCount;
  final int followingCount;

  CommunityUser({
    required this.id,
    required this.username,
    required this.displayName,
    this.bio = '',
    this.profileImageUrl = '',
    this.fitnessGoals = const [],
    this.mentalFocus = '',
    this.totalCaloriesBurned = 0,
    this.currentStreak = 0,
    required this.joinDate,
    this.followingTopics = const [],
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'fitnessGoals': fitnessGoals,
      'mentalFocus': mentalFocus,
      'totalCaloriesBurned': totalCaloriesBurned,
      'currentStreak': currentStreak,
      'joinDate': joinDate.toIso8601String(),
      'followingTopics': followingTopics,
      'postsCount': postsCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
    };
  }

  factory CommunityUser.fromJson(Map<String, dynamic> json) {
    return CommunityUser(
      id: json['id'],
      username: json['username'],
      displayName: json['displayName'],
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      fitnessGoals: List<String>.from(json['fitnessGoals'] ?? []),
      mentalFocus: json['mentalFocus'] ?? '',
      totalCaloriesBurned: json['totalCaloriesBurned'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      joinDate: DateTime.parse(json['joinDate']),
      followingTopics: List<String>.from(json['followingTopics'] ?? []),
      postsCount: json['postsCount'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
    );
  }
}

class CommunityPost {
  final String id;
  final String userId;
  final String username;
  final String displayName;
  final String userProfileImage;
  final String content;
  final List<String> imageUrls;
  final String postType; // progress, question, tip, reflection, challenge
  final String category; // fitness, mental_health, nutrition, general
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByCurrentUser;
  final List<String> tags;
  final Map<String, dynamic>? progressData;

  CommunityPost({
    required this.id,
    required this.userId,
    required this.username,
    required this.displayName,
    this.userProfileImage = '',
    required this.content,
    this.imageUrls = const [],
    required this.postType,
    required this.category,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLikedByCurrentUser = false,
    this.tags = const [],
    this.progressData,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'displayName': displayName,
      'userProfileImage': userProfileImage,
      'content': content,
      'imageUrls': imageUrls,
      'postType': postType,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLikedByCurrentUser': isLikedByCurrentUser,
      'tags': tags,
      'progressData': progressData,
    };
  }

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'],
      userId: json['userId'],
      username: json['username'],
      displayName: json['displayName'],
      userProfileImage: json['userProfileImage'] ?? '',
      content: json['content'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      postType: json['postType'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      isLikedByCurrentUser: json['isLikedByCurrentUser'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      progressData: json['progressData'],
    );
  }
}

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String displayName;
  final String userProfileImage;
  final String content;
  final DateTime createdAt;
  final int likesCount;
  final bool isLikedByCurrentUser;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.displayName,
    this.userProfileImage = '',
    required this.content,
    required this.createdAt,
    this.likesCount = 0,
    this.isLikedByCurrentUser = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'username': username,
      'displayName': displayName,
      'userProfileImage': userProfileImage,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'isLikedByCurrentUser': isLikedByCurrentUser,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      userId: json['userId'],
      username: json['username'],
      displayName: json['displayName'],
      userProfileImage: json['userProfileImage'] ?? '',
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      likesCount: json['likesCount'] ?? 0,
      isLikedByCurrentUser: json['isLikedByCurrentUser'] ?? false,
    );
  }
}

class ForumTopic {
  final String id;
  final String title;
  final String description;
  final String category;
  final String iconEmoji;
  final int subscribersCount;
  final int postsCount;
  final DateTime lastActivity;
  final bool isSubscribed;

  ForumTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.iconEmoji,
    this.subscribersCount = 0,
    this.postsCount = 0,
    required this.lastActivity,
    this.isSubscribed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'iconEmoji': iconEmoji,
      'subscribersCount': subscribersCount,
      'postsCount': postsCount,
      'lastActivity': lastActivity.toIso8601String(),
      'isSubscribed': isSubscribed,
    };
  }

  factory ForumTopic.fromJson(Map<String, dynamic> json) {
    return ForumTopic(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      iconEmoji: json['iconEmoji'],
      subscribersCount: json['subscribersCount'] ?? 0,
      postsCount: json['postsCount'] ?? 0,
      lastActivity: DateTime.parse(json['lastActivity']),
      isSubscribed: json['isSubscribed'] ?? false,
    );
  }
}

class CommunityChallenge {
  final String id;
  final String title;
  final String description;
  final String type; // fitness, mental_health, nutrition
  final Map<String, dynamic> goal;
  final DateTime startDate;
  final DateTime endDate;
  final int participantsCount;
  final bool isParticipating;
  final String prize;
  final List<String> rules;

  CommunityChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.goal,
    required this.startDate,
    required this.endDate,
    this.participantsCount = 0,
    this.isParticipating = false,
    this.prize = '',
    this.rules = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'goal': goal,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'participantsCount': participantsCount,
      'isParticipating': isParticipating,
      'prize': prize,
      'rules': rules,
    };
  }

  factory CommunityChallenge.fromJson(Map<String, dynamic> json) {
    return CommunityChallenge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      goal: json['goal'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      participantsCount: json['participantsCount'] ?? 0,
      isParticipating: json['isParticipating'] ?? false,
      prize: json['prize'] ?? '',
      rules: List<String>.from(json['rules'] ?? []),
    );
  }
}

class LeaderboardEntry {
  final String userId;
  final String username;
  final String displayName;
  final String profileImageUrl;
  final int score;
  final int rank;
  final String challengeId;
  final Map<String, dynamic> progress;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.displayName,
    this.profileImageUrl = '',
    required this.score,
    required this.rank,
    required this.challengeId,
    this.progress = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'score': score,
      'rank': rank,
      'challengeId': challengeId,
      'progress': progress,
    };
  }

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'],
      username: json['username'],
      displayName: json['displayName'],
      profileImageUrl: json['profileImageUrl'] ?? '',
      score: json['score'],
      rank: json['rank'],
      challengeId: json['challengeId'],
      progress: json['progress'] ?? {},
    );
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderUsername;
  final String senderDisplayName;
  final String content;
  final String type; // text, image, system
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderUsername,
    required this.senderDisplayName,
    required this.content,
    this.type = 'text',
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderUsername': senderUsername,
      'senderDisplayName': senderDisplayName,
      'content': content,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      senderUsername: json['senderUsername'],
      senderDisplayName: json['senderDisplayName'],
      content: json['content'],
      type: json['type'] ?? 'text',
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }
}

class ChatRoom {
  final String id;
  final String name;
  final String type; // direct, group, topic
  final List<String> participantIds;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final DateTime lastActivity;

  ChatRoom({
    required this.id,
    required this.name,
    required this.type,
    required this.participantIds,
    this.lastMessage,
    this.unreadCount = 0,
    required this.lastActivity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'participantIds': participantIds,
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'lastActivity': lastActivity.toIso8601String(),
    };
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      participantIds: List<String>.from(json['participantIds']),
      lastMessage: json['lastMessage'] != null 
          ? ChatMessage.fromJson(json['lastMessage']) 
          : null,
      unreadCount: json['unreadCount'] ?? 0,
      lastActivity: DateTime.parse(json['lastActivity']),
    );
  }
}

class ReportData {
  final String id;
  final String reporterId;
  final String contentId;
  final String contentType; // post, comment, user
  final String reason;
  final String description;
  final DateTime createdAt;
  final String status; // pending, reviewed, resolved

  ReportData({
    required this.id,
    required this.reporterId,
    required this.contentId,
    required this.contentType,
    required this.reason,
    this.description = '',
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporterId': reporterId,
      'contentId': contentId,
      'contentType': contentType,
      'reason': reason,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      id: json['id'],
      reporterId: json['reporterId'],
      contentId: json['contentId'],
      contentType: json['contentType'],
      reason: json['reason'],
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'] ?? 'pending',
    );
  }
}
