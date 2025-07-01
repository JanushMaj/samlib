import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/app_user.dart';
import '../../domain/services/i_app_user_service.dart';

class AppUserFirebaseService implements IAppUserService {
  final FirebaseFirestore _firestore;

  AppUserFirebaseService(this._firestore);

  Future<void> upsertAppUser(AppUser user) async {
    await _firestore.collection('users').doc(user.id).set(user.toJson());
  }

  Stream<AppUser?> getAppUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromJson(doc.data() as Map<String, dynamic>);
    });
  }
}
