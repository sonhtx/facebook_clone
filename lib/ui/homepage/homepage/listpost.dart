// List of posts
import 'package:anti_fb/models/post/PostListData.dart';
import 'package:anti_fb/models/request/ReqListPost_VideoData.dart';
import 'package:anti_fb/repository/post/post_repo.dart';
import 'package:anti_fb/ui/homepage/homepage/postpage/post_screen.dart';
import 'package:anti_fb/ui/homepage/homepage/reaction_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:readmore/readmore.dart';

import '../../../constants.dart';
import '../../../models/post/ImageData.dart';
import '../../../widgets/TextWidget.dart';
import '../../../widgets/profile_avatar.dart';
import '../home_screen.dart';

class ListPostWidget extends StatefulWidget {
  const ListPostWidget({super.key, required this.postlists});

  final List<PostListData> postlists;

  @override
  State<ListPostWidget> createState() => _ListPostWidgetState();
}

class _ListPostWidgetState extends State<ListPostWidget> {
  late List<PostListData> _postlists;

  late List<Widget> listPostsWidget = [];

  final PostRepository _postRepository = PostRepository();

  static final RequestListPost_VideoData requestListPostData =
  RequestListPost_VideoData("1", "1", "1", "1.0", "1.0", "6", "60", "10");

  Future<void> getlistpost() async {
    try {
      List<PostListData>? listPost =
          await _postRepository.getlistpost(requestListPostData);
      for (int i = 0; i < listPost!.length; i++) {
        PostListData curPost = listPost[i];
        listPostsWidget.add(PostWidget(
            curPost.id,
            curPost.name,
            curPost.image,
            curPost.described,
            curPost.created,
            curPost.feel,
            curPost.comment_mark,
            curPost.is_felt,
            curPost.author.name,
            curPost.author.avatar));
      }
      final HomeState? homeState =
          context.findAncestorStateOfType<HomeState>();
      homeState?.postlist = listPost;
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    _postlists = widget.postlists;

    setState(() {
      if (_postlists.isEmpty) {
        getlistpost();
      } else {
        for (int i = 0; i < _postlists.length; i++) {
          PostListData curPost = _postlists[i];
          listPostsWidget.add(PostWidget(
              curPost.id,
              curPost.name,
              curPost.image,
              curPost.described,
              curPost.created,
              curPost.feel,
              curPost.comment_mark,
              curPost.is_felt,
              curPost.author.name,
              curPost.author.avatar));
        }
      }

    });


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GREY,
      child: Column(
        children: listPostsWidget,
      ));
  }
}

// post
class PostWidget extends StatelessWidget {
  final String id;
  final String name;
  final List<ImageData> images;
  final String described;
  final String created;
  final String feel;
  final String comment_mark;
  final String is_felt;
  final String author_name;

  final String author_avatar_url;

  PostWidget(
      this.id,
      this.name,
      this.images,
      this.described,
      this.created,
      this.feel,
      this.comment_mark,
      this.is_felt,
      this.author_name,
      this.author_avatar_url,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: WHITE,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PostHeader(
                  imageUrl: author_avatar_url,
                  email: author_name,
                  timestamp: created,
                ),
                const SizedBox(height: 4.0),
                // _PostCaption(caption: post.caption,),
                ReadMoreText(
                  described,
                  trimLines: 2,
                  colorClickableText: GREY,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '    Show more',
                  trimExpandedText: '',
                  moreStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: GREY),
                ),
                // images != [] ? const SizedBox.shrink():const SizedBox(height: 6.0,)
              ],
            ),
          ),

          // ----------------------------
          images != []
              ? SizedBox(
                  height: 200,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          4, // Adjust the number of images per row as needed
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: CachedNetworkImage(
                          imageUrl: images[index].url,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      );
                    },
                  ))
              : const SizedBox.shrink(),
          // ------------------------------

          Container(
              height: 30,
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          TextWidget(
                            text: feel,
                            textColor: GREY,
                            fontSize: 12,
                            width: 12,
                          ),
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              color: FBBLUE,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.thumb_up,
                              size: 10.0,
                              color: WHITE,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              color: RED,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.thumb_down,
                              size: 10.0,
                              color: WHITE,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        '$comment_mark Mark',
                        style: TextStyle(color: GREY[600]),
                      ),
                    )
                  ])),
          const Divider(
            thickness: 0.1,
            color: GREY,
          ),
          _PostBottom(id, is_felt)
        ],
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final String imageUrl;
  final String email;
  final String timestamp;

  const _PostHeader(
      {required this.imageUrl, required this.email, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(imageUrl: imageUrl),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                email,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$timestamp  • ', style: TextStyle( color: Colors.grey[600], fontSize: 12.0,),
                  ),
                  Icon( Icons.public, color: Colors.grey[600], size: 12.0,)
                ],
              )
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
        )
      ],
    );
  }
}

class _PostBottom extends StatelessWidget {

  const _PostBottom(this.id, this.is_felt);

  final String id;
  final String is_felt;



  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 30),
          child: ReactionButton<String>(
            toggle: false,
            direction: ReactionsBoxAlignment.rtl,
            onReactionChanged: (Reaction<String>? reaction) {

            },
            reactions: reaction,
            placeholder:
              reaction[int.parse(is_felt) + 1],
            // boxColor: Colors.black.withOpacity(0.5),
            boxRadius: 20,
            itemsSpacing: 10,
            itemSize: const Size(40, 40),
          ),
        ),
        Container(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostScreen(id: id,),
                  ),
                );
              },
              child: const Row (
                children: [
                  Icon(Icons.comment, color: GREY,),
                  TextWidget(text: 'Mark',
                    textColor: GREY,
                    fontSize: 12,
                    paddingLeft: 5,
                    width: 40,)
                ],
              ),
            )
        ),
      ]
    );
  }

}