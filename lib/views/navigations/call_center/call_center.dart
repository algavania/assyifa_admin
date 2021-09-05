import 'package:assyifa_admin/models/call_center_model.dart';
import 'package:assyifa_admin/shared/loading.dart';
import 'package:assyifa_admin/views/navigations/call_center/add_contact.dart';
import 'package:assyifa_admin/views/navigations/call_center/edit_contact.dart';
import 'package:assyifa_admin/views/navigations/drawer_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CallCenter extends StatefulWidget {
  static const String routeName = '/call_center';

  const CallCenter({Key key}) : super(key: key);

  @override
  _CallCenterState createState() => _CallCenterState();
}

class _CallCenterState extends State<CallCenter> {
  final Stream<QuerySnapshot> _usersStream = Firestore.instance
      .collection('call_center')
      .orderBy('created_at', descending: false)
      .snapshots();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    List<CallCenterModel> callCenterList = [];
    Color darkBlue = const Color(0xFF053742);

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('error');
          _isLoading = false;
          return Text('Something went wrong');
        }

        if (!snapshot.hasData) _isLoading = true;
        else {
          List<CallCenterModel> tempList = [];

          for (int i = 0; i < snapshot.data.documents.length; i++) {
            final DocumentSnapshot document = snapshot.data.documents[i];
            tempList.add(CallCenterModel(document.documentID.toString(), document['name'],
                document['phone'], document['image']));
          }

          _isLoading = false;
          callCenterList = tempList;
          print(_isLoading);
        }

        return _isLoading
            ? Loading()
            : Scaffold(
                appBar: AppBar(
                  title: Text('Call Center Management'),
                ),
                drawer: DrawerNavigation(),
                floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddContact()))),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(callCenterList.length, (index) {
                        CallCenterModel callCenterModel = callCenterList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Card(
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditContact(
                                          callCenterModel: callCenterModel,))),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0,
                                          right: 15.0,
                                          bottom: 5.0,
                                          left: 5.0),
                                      child: Container(
                                        width: 45.0,
                                        height: 45.0,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              callCenterModel.image),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(callCenterModel.name,
                                              style: TextStyle(
                                                  color: darkBlue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0)),
                                          Text(callCenterModel.phone,
                                              style: TextStyle(
                                                  color: darkBlue,
                                                  fontSize: 12.0)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
