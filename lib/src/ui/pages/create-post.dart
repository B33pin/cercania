import 'package:cercania/src/models/Post-model.dart';
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/models/product-model.dart';
import 'package:cercania/src/services/PostService.dart';
import 'package:cercania/src/services/ProductService.dart';
import 'package:cercania/src/services/firebase-storage-service.dart';
import 'package:cercania/src/ui/widgets/cercania-app-bar.dart';
import 'package:cercania/src/ui/widgets/images_selector.dart';
import 'package:cercania/src/ui/widgets/loading-dialog.dart';
import 'package:cercania/src/utils/show-snackbar.dart';
import 'package:cercania/src/utils/simple-form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final postFormKey = GlobalKey<SimpleFormState>();
  final postDescription = TextEditingController();
  final imageSelector = ImageSelector();
  final ProductService productService = ProductService();
  List<DropdownMenuItem<Products>> items;
  Products selectedProduct;

  @override
  void initState() {
    super.initState();

    productService.fetchFavoritesFirestore().then((data) => setState(() {
          this?.items = data
              .map((product) =>
                  DropdownMenuItem(child: Text(product.name), value: product))
              .toList();
        }));
  }

  @override
  void dispose() {
    super.dispose();
    postDescription.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CercaniaAppBar(context: context, title: 'Comparta su experiencia!'),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 70),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 15.0),
                  blurRadius: 15.0),
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -10.0),
                  blurRadius: 10.0),
            ],
          ),
          child: SimpleForm(
            key: postFormKey,
            message: 'Posting',
            afterSubmit: () => Navigator.pop(context),
            onSubmit: () async {
              if (this.selectedProduct == null) {
                showToastMsg(
                    "You must select a product to share a review!", true);
                return;
              }
              openLoadingDialog(context, "Sharing");
              await _insertPost();
              Navigator.of(context).pop();
              showToastMsg("Shared successfully!");
            },
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: postDescription,
                  maxLines: null,
                  maxLength: 300,
                  minLines: null,
                  validator: (value) {
                    return value.isEmpty ? 'Please share some comments' : null;
                  },
                  decoration: InputDecoration(
                    hintText: "Description...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 11.0),
                  ),
                ),
              ),
              this.items == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton<Products>(
                        hint: Text("Please select a product"),
                        isExpanded: true,
                        items: this.items,
                        value: selectedProduct,
                        onChanged: (value) =>
                            setState(() => selectedProduct = value),
                      )),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                child: imageSelector,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => postFormKey.currentState.submit(),
                          child: Center(
                            child: Text("Share",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    letterSpacing: 1.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      )),
    );
  }

  _insertPost() async {
    await PostService().insertFirestore(Post(
      userId: AppData.profile.id,
      name: AppData.profile.name ?? '',
      userImage: AppData.profile.imgUrl,
      shopId: this.selectedProduct.shopId,
      likes: 0,
      description: this.postDescription.text,
      images: await FirebaseStorageService.uploadImages(imageSelector.images),
      time: Timestamp.now(),
    ));
  }
}
