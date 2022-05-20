abstract class ChatState{}
class IntiChatState extends ChatState{}
//ok
class LodingSendMessage extends ChatState{}
class ScSendMessage extends ChatState{}
class ErrorSendMessage extends ChatState{}
//ok
class LodingGetMessage extends ChatState{}
class ScGetMessage extends ChatState{}
class ErrorGetMessage extends ChatState{}


class LodingPickeChatImage extends ChatState{}
class ScPickeChatImage extends ChatState{}
class ErrorPickeChatImage extends ChatState{
  final String error;
  ErrorPickeChatImage(this.error);
}
class LodingUpdateChatImage extends ChatState{}
class ScUpdateChatImage extends ChatState{}
class ErrorUpdateChatImage extends ChatState{
  final String error;
  ErrorUpdateChatImage(this.error);
}
 
 class ChangeInputText extends ChatState{}
 
 class RemoveChatImage extends ChatState{}

 class ChangeChatBar extends ChatState{}

class LodingAddToFav extends ChatState{}
class ScAddToFav extends ChatState{}
class ErrorAddToFav extends ChatState{
  final String error;
  ErrorAddToFav(this.error);
}

class LodingDeleteFromFav extends ChatState{}
class ScDeleteFromFav extends ChatState{}
class ErrorDeleteFromFav extends ChatState{
  final String error;
  ErrorDeleteFromFav(this.error);
}

class LodingGetFavMessage extends ChatState{}
class ScGetFavMessage extends ChatState{}
class ErrorGetFavMessage extends ChatState{}

class LodingDeleteMessage extends ChatState{}
class ScDeleteMessage extends ChatState{}
class ErrorDeleteMessage extends ChatState{}


class LodingDeleteChat extends ChatState{}
class ScDeleteChat extends ChatState{}
class ErrorDeleteChat extends ChatState{}

class LodingGetChats extends ChatState{}
class ScGetChats extends ChatState{}
class ErrorGetChats extends ChatState{}


class LodingGetLastMessage extends ChatState{}
class ScGetLastMessage extends ChatState{}
class ErrorGetLastMessage extends ChatState{}
class IsEmogyV extends ChatState{}
class IsKeyV extends ChatState{}

class LodingPickeChatFile extends ChatState{}
class ScPickeChatFile extends ChatState{}
class ErrorPickeChatFile extends ChatState{
  final String error;
  ErrorPickeChatFile(this.error);
}


class LodingUpdateChatFile extends ChatState{}
class ScUpdateChatFile extends ChatState{}
class ErrorUpdateChatFile extends ChatState{
  final String error;
  ErrorUpdateChatFile(this.error);
}


class ChangeDecu extends ChatState{}

class LodingStartRecording extends ChatState{}
class ScStartRecording extends ChatState{}
class ErrorStartRecording extends ChatState{
  final String error;
  ErrorStartRecording(this.error);
}

class LodingStopRecording extends ChatState{}
class ScStopRecording extends ChatState{}
class ErrorStopRecording extends ChatState{
  final String error;
  ErrorStopRecording(this.error);
}
class LodingStartPlaying extends ChatState{}
class ScStartPlaying extends ChatState{}
class ErrorStartPlaying extends ChatState{
  final String error;
  ErrorStartPlaying(this.error);
}

class LodingStopPlaying extends ChatState{}
class ScStopPlaying extends ChatState{}
class ErrorStopPlaying extends ChatState{
  final String error;
  ErrorStopPlaying(this.error);
}

class LodingGetUser extends ChatState{}
class ScGetUser extends ChatState{}
class ErrorGetUser extends ChatState{
  final String error;
  ErrorGetUser(this.error);
}

