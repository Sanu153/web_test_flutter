import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/helper/table_columns.dart';

class ProductBarHelper {
//static final Database database;
//
//  ProductBarHelper({this.database});

  Future<int> insertProduct(UserProduct bar, Database database) async {
    //print("Saving To Local Helper: ${bar.toLocalData()}");
    return await database.insert(
        ProductBarTableHelper.tableName, bar.toLocalData());
  }

  Future<List<Map<String, dynamic>>> getAllProducts(Database database) async {
    return await database.query(ProductBarTableHelper.tableName);
  }

  Future<int> getProductCount(Database database) async {
    return Sqflite.firstIntValue(await database
        .rawQuery('SELECT COUNT(*) FROM ${ProductBarTableHelper.tableName}'));
  }

  Future<int> updateProduct(UserProduct bar, Database database) async {
    final Map<String, dynamic> row = bar.toLocalData();
    String generatedId = row[ProductBarTableHelper.productSpecGeneratedIdCol];
    return await database.update(ProductBarTableHelper.tableName, row,
        where: '${ProductBarTableHelper.productSpecGeneratedIdCol} = ?',
        whereArgs: [generatedId]);
  }

  Future<int> deleteProduct(String generatedId, Database database) async {
    //print("productId From Database: $generatedId");
    int result = await database.delete(ProductBarTableHelper.tableName,
        where: '${ProductBarTableHelper.productSpecGeneratedIdCol} = ?',
        whereArgs: [generatedId]);
    return result;
  }

  Future<int> dropProductTable(Database database) async {
    //print("productId From Database: $generatedId");
    int result = await database.delete(ProductBarTableHelper.tableName);
    return result;
  }
}
