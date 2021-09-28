import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({
    this.uid
});
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection('groups');

  Future updateUserData(String fullName,String email, String password) async{
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'password': password,
      'groups': [],
      'profilePic': ''
    });
  }

  Future createGroup(String username,String groupName) async{
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': username,
      'members': [],
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });
    await groupDocRef.update({
      'members': FieldValue.arrayUnion([uid! + '_' +username]),
      'groupId': groupDocRef.id
    });

    DocumentReference userDocRef = userCollection.doc(uid);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupDocRef.id + '_' +groupName])
    });
  }

  Future togglingGroupJoin(String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot<Map<String,dynamic>>? userDocSnapshot =
    (await userDocRef.get()) as DocumentSnapshot<Map<String, dynamic>>?;

    DocumentReference groupDocRef = groupCollection.doc(groupId);

    List<dynamic> groups = await userDocSnapshot!.data()!['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      await userDocRef.update({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });
      await groupDocRef.update({
        'members': FieldValue.arrayRemove([uid! + '_' + userName])
      });
    }
    else {
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });
      await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid! + '_' + userName])
      });
    }
  }
  Future<bool> isUserJoined(String groupId, String groupName, String userName) async{
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot<Map<String,dynamic>>? userDocSnapshot;
    userDocSnapshot= (await userDocRef.get()) as DocumentSnapshot<Map<String, dynamic>>?;

    List<dynamic> groups = await userDocSnapshot!.data()!['groups'];

    if(groups.contains(groupId+ '_' +groupName)){
      return true;
    }
    else{
      return false;
    }
  }
  Future getUserData(String email) async{
    QuerySnapshot<Map<String,dynamic>>? snapshot;
    snapshot = (await userCollection.where('email', isEqualTo: email).get()) as QuerySnapshot<Map<String, dynamic>>?;
    print(snapshot!.docs[0].data());
    return snapshot;
  }
  getUserGroups() async{
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }
  sendMsg(String groupId, chatMsgData){
    FirebaseFirestore.instance.collection('groups').doc(groupId).collection('messages').add(chatMsgData);
    FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'recentMessage': chatMsgData['message'],
      'recentMessageSender': chatMsgData['sender'],
      'recentMessageTime': chatMsgData['time'].toString(),
    });
  }
  getChats(String groupId) async{
    return FirebaseFirestore.instance.collection('groups').doc(groupId)
        .collection('messages').orderBy('time').snapshots();
  }
  searchByName(String groupName){
    return FirebaseFirestore.instance.collection("groups").
    where('groupName', isEqualTo: groupName).get();
  }
}