import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String uid;
  DatabaseService({
    this.uid
});
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference groupCollection = Firestore.instance.collection('groups');

  Future updateUserData(String fullName,String email, String password) async{
    return await userCollection.document(uid).setData({
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
    await groupDocRef.updateData({
      'members': FieldValue.arrayUnion([uid + '_' +username]),
      'groupId': groupDocRef.documentID
    });

    DocumentReference userDocRef = userCollection.document(uid);
    return await userDocRef.updateData({
      'groups': FieldValue.arrayUnion([groupDocRef.documentID + '_' +groupName])
    });
  }

  Future togglingGroupJoin(String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.document(groupId);

    List<dynamic> groups = await userDocSnapshot.data['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      await userDocRef.updateData({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });
      await groupDocRef.updateData({
        'members': FieldValue.arrayRemove([uid + '_' + userName])
      });
    }
    else {
      await userDocRef.updateData({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });
      await groupDocRef.updateData({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });
    }
  }
  Future<bool> isUserJoined(String groupId, String groupName, String userName) async{
    DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot;
    userDocSnapshot= await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.data['groups'];

    if(groups.contains(groupId+ '_' +groupName)){
      return true;
    }
    else{
      return false;
    }
  }
  Future getUserData(String email) async{
    QuerySnapshot snapshot;
    snapshot = (await userCollection.where('email', isEqualTo: email).getDocuments());
    print(snapshot.documents[0].data);
    return snapshot;
  }
  getUserGroups() async{
    return Firestore.instance.collection('users').document(uid).snapshots();
  }
  sendMsg(String groupId, chatMsgData){
    Firestore.instance.collection('groups').document(groupId).collection('messages').add(chatMsgData);
    Firestore.instance.collection('groups').document(groupId).updateData({
      'recentMessage': chatMsgData['message'],
      'recentMessageSender': chatMsgData['sender'],
      'recentMessageTime': chatMsgData['time'].toString(),
    });
  }
  getChats(String groupId) async{
    return Firestore.instance.collection('groups').document(groupId)
        .collection('messages').orderBy('time').snapshots();
  }
  searchByName(String groupName){
    return Firestore.instance.collection("groups").
    where('groupName', isEqualTo: groupName).getDocuments();
  }
}