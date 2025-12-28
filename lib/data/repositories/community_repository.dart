import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';

/// Repository for community features
class CommunityRepository {
  /// Get community feed
  Future<List<Map<String, dynamic>>> getFeed({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await supabase
        .from('community_posts')
        .select('''
          *,
          author:users(id, first_name, last_name, avatar_url),
          workout_log:workout_logs(*)
        ''')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Get coach posts
  Future<List<Map<String, dynamic>>> getCoachPosts({
    int limit = 10,
  }) async {
    final response = await supabase
        .from('community_posts')
        .select('''
          *,
          author:users(id, first_name, last_name, avatar_url)
        ''')
        .eq('is_coach_post', true)
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Create a post
  Future<Map<String, dynamic>> createPost({
    required String authorId,
    String? content,
    String postType = 'text',
    List<String>? mediaUrls,
    String? workoutLogId,
  }) async {
    final response = await supabase.from('community_posts').insert({
      'author_id': authorId,
      'content': content,
      'post_type': postType,
      'media_urls': mediaUrls ?? [],
      'workout_log_id': workoutLogId,
    }).select().single();

    return response;
  }

  /// Like a post
  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    await supabase.from('post_likes').insert({
      'post_id': postId,
      'user_id': userId,
    });

    // Increment likes count
    await supabase.rpc('increment_likes', params: {'post_id': postId});
  }

  /// Unlike a post
  Future<void> unlikePost({
    required String postId,
    required String userId,
  }) async {
    await supabase
        .from('post_likes')
        .delete()
        .eq('post_id', postId)
        .eq('user_id', userId);

    // Decrement likes count
    await supabase.rpc('decrement_likes', params: {'post_id': postId});
  }

  /// Check if user liked a post
  Future<bool> hasLikedPost({
    required String postId,
    required String userId,
  }) async {
    final response = await supabase
        .from('post_likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  }

  /// Get post comments
  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    final response = await supabase
        .from('post_comments')
        .select('''
          *,
          user:users(id, first_name, last_name, avatar_url)
        ''')
        .eq('post_id', postId)
        .order('created_at');

    return List<Map<String, dynamic>>.from(response);
  }

  /// Add a comment
  Future<Map<String, dynamic>> addComment({
    required String postId,
    required String userId,
    required String content,
    String? parentCommentId,
  }) async {
    final response = await supabase.from('post_comments').insert({
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'parent_comment_id': parentCommentId,
    }).select().single();

    // Increment comments count
    await supabase.rpc('increment_comments', params: {'post_id': postId});

    return response;
  }

  /// Get tribe messages
  Future<List<Map<String, dynamic>>> getTribeMessages({
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await supabase
        .from('tribe_messages')
        .select('''
          *,
          user:users(id, first_name, last_name, avatar_url)
        ''')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Send tribe message
  Future<Map<String, dynamic>> sendTribeMessage({
    required String userId,
    required String content,
    String? mediaUrl,
  }) async {
    final response = await supabase.from('tribe_messages').insert({
      'user_id': userId,
      'content': content,
      'media_url': mediaUrl,
    }).select().single();

    return response;
  }

  /// Get leaderboard
  Future<List<Map<String, dynamic>>> getLeaderboard({
    int limit = 10,
  }) async {
    final response = await supabase
        .from('users')
        .select('id, first_name, last_name, avatar_url, points')
        .order('points', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Subscribe to new tribe messages
  Stream<Map<String, dynamic>> subscribeTribeMessages() {
    return supabase
        .from('tribe_messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((event) => event.isNotEmpty ? event.last : {});
  }
}

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository();
});

