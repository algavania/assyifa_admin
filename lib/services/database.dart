import 'package:assyifa_admin/models/call_center_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  CollectionReference chats = Firestore.instance.collection('call_center');

  Future<void> addCallCenter(CallCenterModel callCenterModel) {
    // Call the CollectionReference to add a new call center
    return chats
        .add({
      'name': callCenterModel.name,
      'phone': callCenterModel.phone,
      'image': callCenterModel.image,
      'created_at': FieldValue.serverTimestamp()
    })
        .then((value) => print("Call Center Added"))
        .catchError((error) => print("Failed to add call center: $error"));
  }

  Future<void> editCallCenter(CallCenterModel callCenterModel) {
    print('database ${callCenterModel.docId}');
    return chats
        .document(callCenterModel.docId)
        .updateData({
      'name': callCenterModel.name,
      'phone': callCenterModel.phone,
      'image': callCenterModel.image,
    })
        .then((value) => print("Call Center Edited"))
        .catchError((error) => print("Failed to edit call center: $error"));
  }

  Future<void> deleteCallCenter(String docId) {
    return chats
        .document(docId)
        .delete()
        .then((value) => print("Call Center Deleted"))
        .catchError((error) => print("Failed to delete call center: $error"));
  }
}
