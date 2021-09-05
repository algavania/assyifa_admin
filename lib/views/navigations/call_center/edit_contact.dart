import 'dart:io';

import 'package:assyifa_admin/models/call_center_model.dart';
import 'package:assyifa_admin/services/database.dart';
import 'package:assyifa_admin/shared/custom_dialog.dart';
import 'package:assyifa_admin/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:assyifa_admin/shared/custom_text_field.dart';
import 'package:assyifa_admin/shared/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditContact extends StatefulWidget {
  final CallCenterModel callCenterModel;

  const EditContact({Key key, this.callCenterModel}) : super(key: key);

  @override
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  File _imageFile;
  String _imageUrl;

  final _nameValidator = (value) =>
      value.toString().trim().isEmpty ? 'Nama tidak boleh kosong' : null;
  final _phoneValidator = (value) =>
      value.toString().trim().isEmpty ? 'Nomor HP tidak boleh kosong' : null;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  TextEditingController _phoneController;
  FToast fToast;
  BuildContext pageContext;

  Future pickImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, maxHeight: 200);
    print(pickedFile.path);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future uploadToFirebase(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      if (_imageFile == null) {
        uploadDatabase(_imageUrl);
      } else {
        String fileName = widget.callCenterModel.image;
        StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('call_center/$fileName');
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        taskSnapshot.ref.getDownloadURL().then(
          (url) async {
            uploadDatabase(url);
          },
        ).catchError((err) {
          _showToast(err, 'error');
        });
      }
    }
  }

  Future uploadDatabase(String url) async {
    CallCenterModel callCenterModel = CallCenterModel(
        widget.callCenterModel.docId,
        _nameController.text,
        _phoneController.text,
        url);
    try {
      print(callCenterModel.docId);
      await DatabaseService().editCallCenter(callCenterModel);
      _showToast('Call Center berhasil diubah!', 'success');
    } catch (err) {
      _showToast(err, 'error');
    }
    setState(() {
      _isLoading = false;
      _nameController.clear();
      _phoneController.clear();
      _imageFile = null;
    });
    Navigator.pop(context);
  }

  void _showToast(String message, String type) {
    Color color;
    Icon icon;
    if (type == 'success') {
      color = Colors.green;
      icon = Icon(Icons.check, color: Colors.white);
    } else if (type == 'error') {
      color = Colors.white;
      icon = Icon(Icons.error);
    }
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(
            width: 12.0,
          ),
          Text(message, style: TextStyle(color: Colors.white)),
        ],
      ),
    );

    // Custom Toast Position
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        gravity: ToastGravity.BOTTOM,
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            bottom: 16.0,
            left: 16.0,
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController(text: widget.callCenterModel.name);
    _phoneController = TextEditingController(text: widget.callCenterModel.phone);
    _imageUrl = widget.callCenterModel.image;
    fToast = FToast();
    fToast.init(context);
    pageContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Ubah Kontak'),
              actions: [
                InkWell(
                    onTap: () => showDeletionDialog(widget.callCenterModel),
                    borderRadius: BorderRadius.circular(100),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.delete),
                    ))
              ],
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 85.0,
                            height: 85.0,
                            child: _imageFile == null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(_imageUrl),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(_imageFile,
                                        fit: BoxFit.fill)),
                          ),
                          Positioned.fill(
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: 35.0,
                                  height: 35.0,
                                  child: FloatingActionButton(
                                    elevation: 0.0,
                                    onPressed: () => pickImage(),
                                    child: Icon(
                                      Icons.edit,
                                      size: 18.0,
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: double.infinity, height: 25.0),
                    CustomTextField('Nama', TextInputType.name, _nameController,
                        _nameValidator),
                    SizedBox(width: double.infinity, height: 15.0),
                    CustomTextField('Nomor Telepon', TextInputType.number,
                        _phoneController, _phoneValidator),
                    SizedBox(width: double.infinity, height: 25.0),
                    CustomButton('Simpan', () => uploadToFirebase(context)),
                  ],
                ),
              ),
            ),
          );
  }

  void showErrorDialog(String error) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(title: 'Error', content: error);
        });
  }

  void showDeletionDialog(CallCenterModel callCenterModel) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Hapus Kontak'),
            content: Text('Yakin untuk menghapus ${callCenterModel.name}?'),
            actions: [
              TextButton(
                onPressed: () {
                  print('Cancel deletion');
                  Navigator.pop(context);
                },
                child: Text('Batal', style: TextStyle(fontSize: 16.0)),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  Navigator.pop(context);
                  await DatabaseService()
                      .deleteCallCenter(callCenterModel.docId);
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pop(pageContext);
                },
                child: Text('Hapus',
                    style: TextStyle(color: Color(0xFFFF4F4F), fontSize: 16.0)),
              ),
            ],
          );
        });
  }
}