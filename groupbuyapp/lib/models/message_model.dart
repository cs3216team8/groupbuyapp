import 'package:groupbuyapp/models/chat_temp_user_model.dart';

class Message {
  final User sender;
  final String time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread,
  });
}

// temporary placeholder for chat

// YOU - current user
final User currentUser = User(
  id: 0,
  name: 'Current User',
  imageUrl: '../../assets/temp_chat_assets/greg.jpg',
);

// USERS
final User greg = User(
  id: 1,
  name: 'Greg',
  imageUrl: '../../assets/temp_chat_assets/greg.jpg',
);
final User james = User(
  id: 2,
  name: 'James',
  imageUrl: '../../assets/temp_chat_assets/james.jpg',
);
final User john = User(
  id: 3,
  name: 'John',
  imageUrl: '../../assets/temp_chat_assets/john.jpg',
);
final User olivia = User(
  id: 4,
  name: 'Olivia',
  imageUrl: '../../assets/temp_chat_assets/olivia.jpg',
);
final User sam = User(
  id: 5,
  name: 'Sam',
  imageUrl: '../../assets/temp_chat_assets/sam.jpg',
);
final User sophia = User(
  id: 6,
  name: 'Sophia',
  imageUrl: '../../assets/temp_chat_assets/sophia.jpg',
);
final User steven = User(
  id: 7,
  name: 'Steven',
  imageUrl: '../../assets/temp_chat_assets/steven.jpg',
);

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: james,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    unread: true,
  ),
  Message(
    sender: olivia,
    time: '4:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    unread: true,
  ),
  Message(
    sender: john,
    time: '3:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    unread: false,
  ),
  Message(
    sender: sophia,
    time: '2:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    unread: true,
  ),
  Message(
    sender: steven,
    time: '1:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    unread: false,
  ),
  Message(
    sender: sam,
    time: '12:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    unread: false,
  ),
  Message(
    sender: greg,
    time: '11:30 AM',
    text: 'Hey, how\'s it going? What did you do today?',
    unread: false,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: james,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '4:30 PM',
    text: 'Just walked my doge. She was super duper cute. The best pupper!!',
    unread: true,
  ),
  Message(
    sender: james,
    time: '3:45 PM',
    text: 'How\'s the doggo?',
    unread: true,
  ),
  Message(
    sender: james,
    time: '3:15 PM',
    text: 'All the food',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'Nice! What kind of food did you eat?',
    unread: true,
  ),
  Message(
    sender: james,
    time: '2:00 PM',
    text: 'I ate so much food today.',
    unread: true,
  ),
];
