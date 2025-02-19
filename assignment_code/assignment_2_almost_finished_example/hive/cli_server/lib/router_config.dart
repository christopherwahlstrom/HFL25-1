import 'dart:io';

import 'package:cli_server/handlers/bag_handlers.dart';
import 'package:cli_server/handlers/item_handlers.dart';
import 'package:hive/hive.dart';
import 'package:shelf_router/shelf_router.dart';

class ServerConfig {
  // singleton constructor

  ServerConfig._privateConstructor() {
    initialize();
  }

  static final ServerConfig _instance = ServerConfig._privateConstructor();

  static ServerConfig get instance => _instance;

  late Router router;

  late CollectionBox<String> bagBox;
  late CollectionBox<String> itemBox;

  late BoxCollection collection;

  Future initialize() async {
    // Configure routes.
    router = Router();

    // Create a box collection
    collection = await BoxCollection.open(
      'HFL24DB', // Name of your database
      {'bags', 'items'}, // Names of your boxes
    );

    bagBox = await collection.openBox<String>("bags");
    itemBox = await collection.openBox<String>("items");

    router.post('/items', postItemHandler); // create an item
    router.get('/items', getItemsHandler); // get all items
    router.get('/items/<id>', getItemHandler); // get specific item
    router.put('/items/<id>', updateItemHandler); // update specific item
    router.delete('/items/<id>', deleteItemHandler); // update specific item

    router.post('/bags', postBagHandler); // create a bag
    router.get('/bags', getBagsHandler); // get all bags
    router.get('/bags/<id>', getBagHandler); // get specific bag
    router.put('/bags/<id>', updateBagHandler); // update specific bag
    router.delete('/bags/<id>', deleteBagHandler); // update specific bag
  }
}
