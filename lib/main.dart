import 'dart:async';
import 'package:FotoApp/image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<QuerySnapshot> subscription;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> wallpapersList;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("wallpapers");
  @override
  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshots) {
      setState(() {
        wallpapersList = datasnapshots.docs;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("FotoApp"),
        ),
        body: wallpapersList != null
            ? StaggeredGridView.countBuilder(
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  String imgPath = wallpapersList[index].get("url");
                  return Card(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImagePath(imgPath))),
                      child: Hero(
                          tag: imgPath,
                          child: FadeInImage(
                            width: MediaQuery.of(context).size.width,
                            placeholder: AssetImage("assets/loading.gif"),
                            image: NetworkImage(imgPath),
                            fit: BoxFit.cover,
                          )),
                    ),
                  );
                },
                staggeredTileBuilder: (index) =>
                    StaggeredTile.count(2, index.isEven ? 2 : 3),
                itemCount: wallpapersList.length,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
