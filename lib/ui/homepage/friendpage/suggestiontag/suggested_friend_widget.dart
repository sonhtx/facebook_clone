import 'package:anti_fb/api/friend/friend_api.dart';
import 'package:flutter/material.dart';

class SuggestedFriendWidget extends StatefulWidget {
  final String id;
  final String username;
  final String avatar;
  final String created;
  final String sameFriend;
  var friendApi = FriendApi();

  final Function(String id) delWhenDelSuggestion;

  SuggestedFriendWidget(this.id, this.username, this.avatar, this.created,
      this.sameFriend, this.delWhenDelSuggestion,
      {super.key});

  @override
  State<StatefulWidget> createState() {
    return _SuggestFriendWidget();
  }
}

class _SuggestFriendWidget extends State<SuggestedFriendWidget> {
  bool isRequested = false;
  @override
  Widget build(BuildContext context) {
    void handleCancelRequest() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: Text(
                'Do you want to cancel request friend to ${widget.username}?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  print('deleted request friend to ${widget.username}');
                  widget.friendApi.delRequestFriend(widget.id);
                  setState(() {
                    isRequested = false;
                  });
                },
                child: const Text('Accept'),
              ),
            ],
          );
        },
      );
    }

    void handleAddFriend() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: Text(
                'Do you want to send a friend request to ${widget.username}?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isRequested = true;
                  });
                  widget.friendApi.setRequestFriend(widget.id);
                  print('send request to  ${widget.username}');
                  // Close the dialog
                },
                child: const Text('Accept'),
              ),
            ],
          );
        },
      );
    }

    void handleDelSuggestion() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: Text(
                'Do you want to delete suggested friend ${widget.username}?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  print('deleted suggestion ${widget.username}');
                  widget.delWhenDelSuggestion(widget.id);
                },
                child: const Text('Accept'),
              ),
            ],
          );
        },
      );
    }

    Widget suggestBtns = Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
          child: TextButton(
            onPressed: () {
              handleAddFriend();
            },
            style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              backgroundColor: Colors.blue, // Màu nền của nút
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: const Text(
              'Add friend',
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5.0)),
          child: TextButton(
            onPressed: handleDelSuggestion,
            style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              backgroundColor: Colors.grey[300], // Màu nền của nút
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: const Text('Remove',
                style: TextStyle(color: Colors.black, fontSize: 15.0)),
          ),
        ),
      ],
    );

    if (isRequested) {
      suggestBtns = Row(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5.0)),
            child: TextButton(
              onPressed: () {
                handleCancelRequest();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.black, fontSize: 15.0)),
            ),
          ),
        ],
      );
    }

    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(widget.avatar),
            radius: 40.0,
          ),
          const SizedBox(width: 20.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.username,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15.0),
              suggestBtns,
            ],
          )
        ],
      ),
    );
  }
}