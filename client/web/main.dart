import 'dart:html';
import 'dart:async';

InputElement input = querySelector("#textInput");
var output = querySelector("#output");
var buttonSend = querySelector("#send");
var buttonImg = querySelector("#url");
var buttonVideo = querySelector("#video");

Future<Null> main() async {

  //send custom message
  buttonSend.onClick.listen((MouseEvent event) async{
    addContent(input.value);
  });

  //send img
  buttonImg.onClick.listen((MouseEvent event) async{
    addContent(getPrefabImg(input.value));
  });

  //send video
  buttonVideo.onClick.listen((MouseEvent event) async{
    addContent(getPrefabVideo(input.value));
  });
}

//if user use a prefab img
String getPrefabImg(url) {
  return "<img class='prefabImg' src='" + url + "'>";
}


//if user use a prefab video
String getPrefabVideo(url) {
  return "<iframe class='prefabVideo'' src='" + url + "' frameborder='0' allowfullscreen></iframe>";
}


//reset input and add content
void addContent(value){
  output.setInnerHtml(value + output.innerHtml);
  input.value = null;
}