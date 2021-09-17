import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  late final String uid;
  DatabaseService({
    required this.uid
});
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection('groups');

  Future updateUserData(String email, String password) async{
    return await userCollection.doc(uid).set({
      'email': email,
      'password': password,
      'groups': [],
      'profilepic': ''
    });
  }

  Future createGroup(String username,String groupName) async{
    DocumentReference groupDocRef = await groupCollection.add({
      'groupname': groupName,
      'groupicon': '',
      'admin': username,
      'members': [],
      'groupId': '',
      'recentMsg': '',
      'recentMsgSender': ''
    });
    await groupDocRef.update({
      'members': FieldValue.arrayUnion([uid + '_' +username]),
      'groupId': groupDocRef.id
    });

    DocumentReference userDocRef = await userCollection.doc(uid);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupDocRef.id+ '_' +groupName])
    });
  }

  Future togglingGroupJoin(String groupId, String groupName, String userName) async{
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);

    List<dynamic> groups = await userDocSnapshot.get('groups');

    if(groups.contains(groupId+ '_' +groupName)){
      await userDocRef.update({
        'groups': FieldValue.arrayRemove([groupId+ '_' +groupName])
      });
      await groupDocRef.update({
        'members': FieldValue.arrayRemove([uid+ '_' +userName])
      });
    }
    else{
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupId+ '_' +groupName])
      });
      await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid+ '_' +userName])
      });
    }
    Future<bool> isUserJoined(String groupId, String groupName, String userName) async{
      DocumentReference userDocRef =await userCollection.doc(uid);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      List<dynamic> groups = await userDocSnapshot.get('groups');

      if(groups.contains(groupId+ '_' +groupName)){
        return true;
      }
      else{
        return false;
      }
    }
    Future getUserData(String email) async{
      QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).get();
      print(snapshot.docs[0].data());
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
      return FirebaseFirestore.instance.collection('groups').
      where('groupName', isEqualTo: groupName).get();
    }
  }
}