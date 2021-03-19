import 'package:hive/hive.dart';
import 'product-model.dart';

part 'cart-product-model.g.dart';

@HiveType(typeId: 1)
class CartProduct extends HiveObject{
  @HiveField(0)
  Products product;
  @HiveField(1)
  int quantity;

  CartProduct({this.product,this.quantity=1});
}