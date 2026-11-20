import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResumeServiceDatasource {
  final SupabaseClient supabase;

  ResumeServiceDatasource({required this.supabase});

  Future<String?> uploadResume(File file, String fileName) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final uniqueValue = DateTime.now().microsecondsSinceEpoch;
    final filePath = '${user.id}/$uniqueValue-$fileName';

    await supabase.storage
        .from('resumes')
        .upload(
          filePath,
          file,
          fileOptions: const FileOptions(upsert: false),
        );

    await updateResumeUrlProfile(filePath, user.id);

    final signedUrl = await supabase.storage
        .from('resumes')
        .createSignedUrl(filePath, 3600);

    return signedUrl;
  }

  Future<void> updateResumeUrlProfile(
      String filePath, String userId) async {
    await supabase
        .from('profiles')
        .update({
          'resume_url': filePath,
        })
        .eq('id', userId);
  }
}
