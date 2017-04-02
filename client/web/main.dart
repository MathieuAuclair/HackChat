import 'dart:html';
import 'dart:async';
import 'package:http/browser_client.dart' as http;

InputElement input = querySelector("#textInput");
var output = querySelector("#output");
var buttonSend = querySelector("#send");
var buttonImg = querySelector("#url");
var buttonVideo = querySelector("#video");

Future<Null> main() async {

  var ws = new WebSocket('ws://localhost:8090/ws');
  ws.onMessage.listen((MessageEvent event) {
    print(event.data);
  });

  //set a http
  var client = new http.BrowserClient();

  //send custom message
  buttonSend.onClick.listen((MouseEvent event) async{
    addContent(input.value);
    var response = await client.get('http://localhost:8080/number');
    sendSocketMsg(ws, response.body);
  });

  //send img
  buttonImg.onClick.listen((MouseEvent event) async{
    addContent(getPrefabImg(input.value));
    var response = await client.get('http://localhost:8080/number');
    sendSocketMsg(ws, response.body);
  });

}

//if user use a prefab img
String getPrefabImg(url) {
  return "<img class='prefabImg' src='" + url + "'>";
}

//reset input and add content
void addContent(value){
  output.insertAdjacentHtml('beforeBegin', value, treeSanitizer: NodeTreeSanitizer.trusted);
  input.value = null;
}

void sendSocketMsg(WebSocket ws, String message) {
  if (ws != null && ws.readyState == WebSocket.CONNECTING) {
    new Future.delayed(
        //set a delay if server isn't connected
        new Duration(microseconds: 1), () => sendSocketMsg(ws, message));
  } else {
    //send the message
    ws.send(message);
  }
}