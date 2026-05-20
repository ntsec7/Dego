import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/notification.dart';

class NotificationService {

  final supabase = Supabase.instance.client;

  Future<void> createNotification(NotificationModel noti) async{
    try{
        await supabase.from('notifications').insert({
          'id_user':noti.id_user,
          'id_creator_user':noti.id_creator_user,
          'id_group':noti.id_group,
          'type':noti.type,
        });
    }catch(e){
      rethrow;
    }

  }

}