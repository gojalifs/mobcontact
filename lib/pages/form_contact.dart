import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobcontact/database/db_helper.dart';

import 'package:mobcontact/models/contact_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FormContact extends StatefulWidget {
  final Contact contact;
  const FormContact(this.contact, {Key? key}) : super(key: key);
  @override
  State<FormContact> createState() => _FormContactState();
}

class _FormContactState extends State<FormContact> {
  final DbHelper dbHelper = DbHelper();
  File? imageFile;
  final txtNama = TextEditingController();
  final txtTelp = TextEditingController();
  final txtEmail = TextEditingController();
  final txtCompany = TextEditingController();
  final txtPhoto = TextEditingController();
  Uint8List? imageProfile;

  @override
  void initState() {
    super.initState();
    txtNama.text = widget.contact.name ?? "";
    txtTelp.text = widget.contact.mobileNo ?? "";
    txtEmail.text = widget.contact.email ?? "";
    txtCompany.text = widget.contact.company ?? "";
  }

  Future<String> appPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  getFromGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    // appPath().then((value) {
    //   String appPath = value;

    // });
    final imageTemp = File(image.path);
    image.readAsBytes().then((value) => imageProfile = value);

    setState(() {
      imageFile = imageTemp;
      txtPhoto.text = imageTemp.path;
    });
  }

  Future<File?> saveImage(String imagePath) async {
    final dir = await getApplicationDocumentsDirectory();

    final newImage = File('${dir.path}/${txtNama.text}.jpg');

    setState(() {
      txtPhoto.text = newImage.path;
    });
    return newImage;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: widget.contact.id != null
              ? const Text("Update Contact")
              : const Text("Add Contact"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Form(
              child: Column(
                children: [
                  imageFile == null
                      ? InkWell(
                          onTap: () {
                            getFromGallery();
                          },
                          child: const Icon(
                            Icons.person,
                            size: 250,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: const Text('Delete or Change?'),
                                  content: const Text(
                                      'tap anywhere outside to cancel'),
                                  actions: [
                                    CupertinoDialogAction(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          getFromGallery();
                                        },
                                        child: const Text('Change')),
                                    CupertinoDialogAction(
                                        onPressed: () {},
                                        child: const Text('Delete')),
                                  ],
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                              maxRadius: 100,
                              foregroundImage: FileImage(imageFile!))),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    controller: txtNama,
                    decoration: const InputDecoration(
                        labelText: "Nama",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person)),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    controller: txtTelp,
                    decoration: const InputDecoration(
                        labelText: "Nomor HP",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone)),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: txtEmail,
                    decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email)),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.go,
                    controller: txtCompany,
                    decoration: const InputDecoration(
                        labelText: "Nama Perusahaan",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.home)),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      onPressed: () async {
                        var navigator = Navigator.of(context);

                        Contact data = Contact(
                            name: txtNama.text,
                            mobileNo: txtTelp.text,
                            email: txtEmail.text,
                            company: txtCompany.text,
                            photo: txtPhoto.text);
                        if (widget.contact.id != null) {
                          data.id = widget.contact.id;
                          await dbHelper
                              .update(data)
                              .then((value) => navigator.pop());
                        } else {
                          await dbHelper
                              .save(data)
                              .then((value) => navigator.pop());
                        }
                      },
                      child: widget.contact.id != null
                          ? const Text("Update Contact")
                          : const Text("Save Contact"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
