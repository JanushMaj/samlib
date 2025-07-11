import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/app_user.dart';
import '../../domain/services/i_app_user_service.dart';
import '../dto/app_user_dto.dart';

class AppUserFirebaseService implements IAppUserService {
  final FirebaseFirestore _firestore;

  AppUserFirebaseService(this._firestore);

  Future<void> upsertAppUser(AppUser user) async {
    final dto = AppUserDto.fromDomain(user);
    await _firestore
        .collection('users')
        .doc(user.id)
        .set(dto.toJson(), SetOptions(merge: true));
  }

  @override
  Future<AppUser?> getAppUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUserDto.fromFirestore(doc).toDomain();
  }

  Stream<AppUser?> getAppUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUserDto.fromFirestore(doc).toDomain();
    });
  }

  @override
  Future<AppUser?> getUserByEmployeeId(String employeeId) async {
    final query = await _firestore
        .collection('users')
        .where('employeeId', isEqualTo: employeeId)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return AppUserDto.fromFirestore(query.docs.first).toDomain();
  }
}
