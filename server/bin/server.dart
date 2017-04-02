import 'dart:io' as io;

import 'dart:async';
import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_cors/shelf_cors.dart' as shelf_cors; // ignore: uri_does_not_exist
import 'package:shelf/shelf_io.dart' as shelf_io;

//list that contain the chat
List<String> Chat = new List<String>();

//main function
Future<Null> main(List<String> args) async{
  //set the port
  var parser = new ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080');

  var result = parser.parse(args);

  //use the port and throw an error if it's wrong
  var port = int.parse(result['port'], onError: (val) {
    io.stdout.writeln('Could not parse port value "$val" into a number.');
    io.exit(1);
  });

  //set pipeline
  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware(shelf_cors.createCorsHeadersMiddleware())
      .addHandler(getChatContent); //call the request here

  shelf_io.serve(handler, '0.0.0.0', port).then((server) { //Console message when server launch
    print('Serving at http://${server.address.host}:${server.port}');
  });

  Future handleMessage(io.WebSocket socket, dynamic message) async {
    print(message);
    socket.add('Received!');
    socket.close();
  }


  //starting the socket
  Future startSocket() async {
    try {
      io.HttpServer server = await io.HttpServer.bind('localhost', 8090);
      server.listen((io.HttpRequest req) async {
        if (req.uri.path == '/ws') {
          io.WebSocket socket = await io.WebSocketTransformer.upgrade(req);
          socket.listen((msg) => handleMessage(socket, msg));
        }
      });
    }
    catch (e) {
      print("An error occurred. ${e.toString()}");
    }
  }
  //call function
  startSocket();
}


//listen to client request
shelf.Response getChatContent(shelf.Request request) {
  //select the right path
  if (request.requestedUri.path == '/chat') {
    Chat[Chat.length] = request.toString();
    return new shelf.Response.ok(Chat);
  }
  //request doesn't exist
  return new shelf.Response.forbidden('Cannot access this path');
}
