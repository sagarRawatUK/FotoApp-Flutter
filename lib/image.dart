import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:FotoApp/main.dart';

class ImagePath extends StatelessWidget {
  final String imgPath;
  ImagePath(this.imgPath);
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.black,
        ),
        actions: [
          IconButton(
              color: Colors.black,
              icon: Icon(Icons.file_download),
              onPressed: () async => DownloadTask(
                  taskId: await FlutterDownloader.enqueue(
                      url: imgPath,
                      savedDir: await localPath,
                      openFileFromNotification: true,
                      showNotification: true)))
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Hero(tag: imgPath, child: Image.network(imgPath)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
