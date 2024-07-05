  // WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isWindows || Platform.isLinux) {
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // }
  // Future<void> initializeDatabase() async {
  //   _database = await openDatabase(
  //     join(await getDatabasesPath(), 'databaseT13.db'),
  //     onCreate: (db, version) {
  //       // الادارة
  //       db.execute(
  //         'CREATE TABLE admins(id INTEGER PRIMARY KEY AUTOINCREMENT,user_name TEXT,password TEXT,updateTimeDebts TEXT)',
  //       );

  //       // المنتجات
  //       db.execute(
  //           'CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, nameProduct TEXT, quantity INTEGER, sellingPrice INTEGER, purchasingPrice INTEGER, description TEXT, note TEXT)');
 
//
//           Future<void> deleteS() async {
//   await _database.delete(
//     'sequence',
//   );
//   deleteS2();
//   notifyListeners();
// }


  // Future<void> insertBarcode(BarcodeData barcodeData) async {
  //   await _database.insert(
  //     'barcode_table',
  //     barcodeData.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );



//     Future<List<BarcodeData>> getAllBarcodesNotID() async {
//   final List<Map<String, dynamic>> maps = await _database.query(
//     'barcode_table',
//   );

//   return List.generate(maps.length, (i) {
//     return BarcodeData(
//       id: maps[i]['id'],
//       productsId: maps[i]['productsId'],
//       barcode: maps[i]['barcode'],
//     );
//   });
// }


// Future<void> updateProduct(Product product) async {
//   print('_____AA1');

//   await _database.update(
//     'products',
//     product.toMap(),
//     where: 'id = ?',
//     whereArgs: [product.id],
//   );
//   print('_____AA2');
//   // _products = await getAllProducts();
//   notifyListeners();
// }
