import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/listings_model_class.dart';

import 'post_images.dart';

class ImageList extends StatefulWidget {
  const ImageList({super.key});

  @override
  State<ImageList> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  int offset = 0;
  List images = [];
  late final Future myFuture;

  @override
  void initState() {
    super.initState();
    myFuture = getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: myFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                          separatorBuilder: (a, c) => const SizedBox(height: 5),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PostImage(snapshot.data![index])));
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CachedNetworkImage(
                                      imageUrl: snapshot.data![index] ?? "",
                                      placeholder: (a, b) => const SizedBox(
                                          height: 170.0,
                                          child: CupertinoActivityIndicator())),
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Text("No Images Available");
                    }
                  }
                  return const Center(
                    child: SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            _isLoading
                ? const SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          scrollListner();
                        },
                        child: const Text(
                          "Click Here to Load More",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  )
          ],
        ),
      ),
    );
  }

  Future getImages() async {
    var url = "http://dev3.xicom.us/xttest/getdata.php";
    var uri = Uri.parse(url);
    var res = await http.post(uri,
        body: {"user_id": "108", "offset": "$offset", "type": "popular"});
    var data = jsonDecode(res.body);
    var items = ImageListings.fromJson(data);
    for (int i = 0; i < items.images!.length; i++) {
      images.add(items.images![i].xtImage);
    }
    setState(() {});
    return images;
  }

  bool _isLoading = false;

  void scrollListner() async {
    _isLoading = true;
    setState(() {});
    offset = offset + 1;
    await getImages();
    _isLoading = false;
    setState(() {});
  }
}
