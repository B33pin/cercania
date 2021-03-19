import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImageSelector extends StatefulWidget {
  List<String> images = [];
  ImageSelector();
  @override
  createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  ImagePicker _picker = ImagePicker();

  @override
  initState() {
    super.initState();
    if (widget.images == null) {
      widget.images = [];
    }
  }

  _imgFromCamera() async {
    final pickedImage =
    await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if(pickedImage!=null)
      setState(() {
        widget.images.add(pickedImage.path);
      });
  }

  _pickFromGallery() async {
    Map<String, String> tempImages;
    try {
      FilePicker inst = FilePicker.platform;
      var files = await inst.pickFiles(type: FileType.image,allowMultiple: true,
          allowCompression: true);
      if(mounted && files!=null){
        setState(() {
          files.files.map((e) => widget.images.add(e.path)).toList();
        });
      }
      // tempImages = await FilePicker.getMultiFilePath(
      //     type: FileType.IMAGE, fileExtension: 'jpg,png,webp,jpeg');
    } on PlatformException catch (e) {
      // Message Display.
    }
  }

  @override
  build(context) => ConstrainedBox(
        constraints: BoxConstraints.expand(height: 150),
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  color: Colors.grey.shade200,
                  child: Center(
                    child: widget.images.isEmpty
                        ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.image),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3),
                          ),
                          Text("No Images Selected!",style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w400)),
                        ],
                      )
                        : ListView.builder(
                            itemCount: widget.images.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) => GestureDetector(
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Delete image?"),
                                          actions: [
                                            FlatButton(
                                              onPressed: () => setState(() {
                                                widget.images.remove(widget
                                                    .images.elementAt(i));
                                                Navigator.of(context).pop();
                                              }),
                                              child: Text("Yes"),
                                            ),
                                            FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text("No"),
                                            )
                                          ],
                                        ));
                              },
                              child: SizedBox(
                                width: 150,
                                height: 150,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(
                                      File(widget.images.elementAt(i)),
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: -2,
                                      child: SizedBox(
                                        height: 30,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: IconButton(
                                              icon: Icon(Icons.delete,color: Colors.white,size: 15,), onPressed: (){
                                                setState(() {
                                                  widget.images.remove(widget
                                                      .images.elementAt(i));
                                                });
                                          }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  )),
            ),
            Positioned(
              bottom: -15,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.purple.shade400,
                  child: IconButton(
                    icon: Icon(Icons.image),
                    onPressed: _pickFromGallery,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -15,
              left: 50,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: _imgFromCamera,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
