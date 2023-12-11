import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PostImage extends StatefulWidget {
  String images;

  PostImage(this.images, {super.key});

  @override
  State<PostImage> createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? image;
  bool _loading = false;
  String downloadedPath = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.images);
    downloadFile(widget.images, "Image_1");
    // downloadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formKey,
          child: _loading
              ? const Center(
                  child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator()))
              : Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {},
                      child: image != null
                          ? Image.file(image!)
                          : Container(
                              height: MediaQuery.of(context).size.height / 3.0,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey.shade100,
                              child: const Center(
                                child: Text(
                                  "Add Image",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "First Name",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 60,
                              width: 200,
                              child: TextFormField(
                                controller: firstname,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter First Name";
                                  }
                                },
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 2,
                                  )),
                                  filled: true,
                                  fillColor: Colors.grey.shade300,
                                  hintText: "First Name",
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Last Name",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 60,
                              width: 200,
                              child: TextFormField(
                                controller: lastname,
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return "Please Enter Last Name";
                                },
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 2,
                                  )),
                                  filled: true,
                                  fillColor: Colors.grey.shade300,
                                  hintText: "Last Name",
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Email",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 60,
                              width: 200,
                              child: TextFormField(
                                controller: email,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter your Email";
                                  }
                                  if (!isEmailValid()) {
                                    return "Please Enter Valid Email";
                                  }
                                },
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 2,
                                  )),
                                  filled: true,
                                  fillColor: Colors.grey.shade300,
                                  hintText: "Email",
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Phone",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 60,
                              width: 200,
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                controller: phone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter your Phone";
                                  }
                                  if (value.length != 10) {
                                    return "Enter Valid Phone";
                                  }
                                },
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 2,
                                  )),
                                  filled: true,
                                  fillColor: Colors.grey.shade300,
                                  hintText: "Phone",
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _loading = true;
                          uploadData();
                        }
                      },
                      style: ButtonStyle(
                        alignment: Alignment.center,
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: const Text(
                        "Submit",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  void uploadData() async {
    try {
      String url = "http://dev3.xicom.us/xttest/savedata.php";
      var uri = Uri.parse(url);
      var request = http.MultipartRequest("POST", uri);
      request.fields['first_name'] = firstname.text;
      request.fields['last_name'] = lastname.text;
      request.fields['email'] = email.text;
      request.fields['phone'] = phone.text;
      request.files.add(http.MultipartFile.fromBytes('user_image',
          await File.fromUri(Uri.parse(image!.path)).readAsBytes()));
      request.send().then((value) {
        _loading = false;

        if (value.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Image Uploaded Successfully")));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Future? imagepicker(ImageSource source) async {
  //   try {
  //     final result = await ImagePicker().pickImage(source: source);
  //     if (result == null) {
  //       return null;
  //     }
  //     setState(() {
  //       image = File(result.path);
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  downloadImage() async {
    try {
      await FileDownloader.downloadFile(
          url: widget.images,
          onDownloadCompleted: (path) {
            print("Download COmpleted");
            print(path);
            setState(() {
              downloadedPath = path;
              image = File(path);

              print(downloadedPath);
            });
          },
          onDownloadError: (error) {
            print("Error is $error ");
          });
      print(downloadedPath);
    } catch (e) {
      print(e.toString());
    }
  }

  bool isEmailValid() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email.text);
  }

  // _asyncMethod() async {
  //   //comment out the next two lines to prevent the device from getting
  //   // the image from the web in order to prove that the picture is
  //   // coming from the device instead of the web.
  //   var url = "https://www.tottus.cl/static/img/productos/20104355_2.jpg"; // <-- 1
  //   var response = await http.get(Uri.parse(widget.images));
  //   var tempDir = await getTemporaryDirectory();
  //   String fullPath = tempDir.path + "/boo2.pdf'";
  //   File file = File(fullPath);
  //   var raf = file.openSync(mode: FileMode.write);
  //   // response.data is List<int> type
  //   raf.writeFromSync(json.decode(response.body));
  //   await raf.close();
  //   // <--2
  //   // var documentDirectory = await getExternalStorageDirectory();
  //   // var firstPath = documentDirectory!.path + "/images";
  //   // var filePathAndName = documentDirectory.path + '/images/pic.jpg';
  //   // //comment out the next three lines to prevent the image from being saved
  //   // //to the device to show that it's coming from the internet
  //   // await Directory(firstPath).create(recursive: true); // <-- 1
  //   // File file2 = new File(filePathAndName);             // <-- 2
  //   // file2.writeAsBytesSync(response.bodyBytes);         // <-- 3
  //   // setState(() {
  //   //   image=file2;
  //   //   print(filePathAndName);
  //   //   // imageData = filePathAndName;
  //   //   // dataLoaded = true;
  //   // });
  // }

  Future<File?> downloadFile(String url, String name) async {
    try {
      var appStorage = await getApplicationDocumentsDirectory();
      var file = File("${appStorage.path}/$name");
      final response = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes, followRedirects: false));
      print(response);

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      print(response.data);
      print(" File Path is $file");
      setState(() {
        image = file;
      });
      return file;
    } catch (e) {
      print("error is ${e.toString()}");
    }
  }
}
