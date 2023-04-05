import 'dart:convert';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
import 'package:ohnost/secrets.dart';
import 'package:ohnost/util.dart';
import 'package:tuple/tuple.dart';

import 'api.dart';

class PostList {
  late final Future<List<Post>> postFuture;
  late final List<Post> posts;
  int cursor = 0;

  PostList(this.posts);

  PostList.fromUser(handle, {this.cursor = 0}) {
    postFuture = getUserPosts(handle, cursor);
  }

  PostList.fromHomeFeed({this.cursor = 0, int? timestamp}) {
    postFuture = getHomeFeedPosts(cursor, timestamp);
  }

  Future<List<Post>> getHomeFeedPosts(int cursor, int? reftimestamp) async {
    try {
      late final Uri endpoint;
      if (reftimestamp != null) {
        endpoint = Uri.parse("https://cohost.org/?refTimestamp=$reftimestamp&skipPosts=0");
      } else {
        endpoint = Uri.parse("https://cohost.org/?skipPosts=$cursor");
      }
      Response res = await authenticatedGet(endpoint);

      if (res.statusCode == 200) {
        List<dynamic> postList = await extractLoaderState(
          utf8.decode(res.bodyBytes),
          'dashboard-nonlive-post-feed',
        );

        List<Post> posts =
            postList.map((dynamic item) => Post.fromJson(item)).toList();
        return posts;
      } else {
        throw "status code ${res.statusCode}";
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<List<Post>> getUserPosts(String handle, int cursor) async {
    try {
      final Uri endpoint =
          Uri.parse("$apiBase/project/$handle/posts?page=$cursor");
      Response res = await authenticatedGet(endpoint);

      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
        List<dynamic> postList = body['items'];

        // throw UnimplementedError();

        List<Post> posts =
            postList.map((dynamic item) => Post.fromJson(item)).toList();

        return posts;
      } else {
        throw "status code ${res.statusCode}";
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

class Post {
  Post({
    required this.postId,
    required this.headline,
    required this.publishedAt,
    required this.filename,
    required this.transparentShareOfPostId,
    required this.state,
    required this.numComments,
    required this.numSharedComments,
    required this.sharesLocked,
    required this.cws,
    required this.tags,
    required this.blocks,
    required this.plainTextBody,
    required this.postingProject,
    required this.shareTree,
    required this.relatedProjects,
    required this.singlePostPageUrl,
    required this.effectiveAdultContent,
    required this.isEditor,
    required this.contributorBlockIncomingOrOutgoing,
    required this.hasAnyContributorMuted,
    required this.postEditUrl,
    required this.isLiked,
    required this.canShare,
    required this.canPublish,
    required this.hasCohostPlus,
    required this.pinned,
    required this.commentsLocked,
  });
  late final int postId;
  late final String headline;
  late final String publishedAt;
  late final String filename;
  late final int? transparentShareOfPostId;
  late final int state;
  late final int numComments;
  late final int numSharedComments;
  late final List<dynamic> cws;
  late final List<String> tags;
  late final List<Block> blocks;
  late final String plainTextBody;
  late final PostingProject postingProject;
  late final List<Post> shareTree;
  late final List<dynamic> relatedProjects;
  late final String singlePostPageUrl;
  late final bool effectiveAdultContent;
  late final bool isEditor;
  late final bool contributorBlockIncomingOrOutgoing;
  late final bool hasAnyContributorMuted;
  late final String postEditUrl;
  late bool isLiked;
  late final bool canShare;
  late final bool canPublish;
  late final bool hasCohostPlus;
  late final bool pinned;
  late final bool sharesLocked;
  late final bool commentsLocked;
  late final Map<int, List<CommentOuter>> comments;
  late final Map<String, dynamic> sourceJson;

  Post.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    headline = json['headline'];
    publishedAt = json['publishedAt'];
    filename = json['filename'];
    transparentShareOfPostId = json['transparentShareOfPostId'];
    state = json['state'];
    numComments = json['numComments'];
    numSharedComments = json['numSharedComments'];
    cws = List.castFrom<dynamic, dynamic>(json['cws']);
    tags = List.castFrom<dynamic, String>(json['tags']);
    blocks = List.from(json['blocks']).map((e) => Block.fromJson(e)).toList();
    plainTextBody = json['plainTextBody'];
    postingProject = PostingProject.fromJson(json['postingProject']);
    shareTree =
        List.from(json['shareTree']).map((e) => Post.fromJson(e)).toList();
    relatedProjects = List.castFrom<dynamic, dynamic>(json['relatedProjects']);
    singlePostPageUrl = json['singlePostPageUrl'];
    effectiveAdultContent = json['effectiveAdultContent'];
    isEditor = json['isEditor'];
    contributorBlockIncomingOrOutgoing =
        json['contributorBlockIncomingOrOutgoing'];
    hasAnyContributorMuted = json['hasAnyContributorMuted'];
    postEditUrl = json['postEditUrl'];
    isLiked = json['isLiked'];
    canShare = json['canShare'];
    canPublish = json['canPublish'];
    hasCohostPlus = json['hasCohostPlus'];
    pinned = json['pinned'];
    commentsLocked = json['commentsLocked'];
    sharesLocked = json['sharesLocked'];
    sourceJson = json;
  }

  Future<bool> toggleLikedStatus() async {
    num postToLike =
        transparentShareOfPostId != null ? transparentShareOfPostId! : postId;

    final Uri endpoint = !isLiked
        ? Uri.parse("$trpcBase/relationships.like")
        : Uri.parse("$trpcBase/relationships.unlike");

    final Map data = {"fromProjectId": 615, "toPostId": postToLike};

    Response res = await authenticatedPost(endpoint, body: jsonEncode(data));

    if (res.statusCode == 200) {
      isLiked = !isLiked;
      return isLiked;
    } else {
      throw "failed to like, status code ${res.statusCode}";
    }
  }

  static Future<Post> getPostFromId(int id, String handle) async {
    final Uri endpoint = Uri.parse(
        "$trpcBase/posts.singlePost?input={\"handle\":\"$handle\",\"postId\":$id}");
    Response res = await authenticatedGet(endpoint);
    Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
    dynamic postRaw = body['result']['data']['post'];
    Post post = Post.fromJson(postRaw);
    return post;
  }

  Future<void> deletePost() async {
    final Uri endpoint =
        Uri.parse("$apiBase/project/${postingProject.handle}/posts/$postId");
    Response res = await authenticatedDelete(endpoint);
    if (res.statusCode != 200) throw Error();
    return;
  }
}

class Comments {
  late final Map<String, List<CommentOuter>> comments;

  static Future<Map<String, List<CommentOuter>>> getCommentsFromId(
      int id, String handle) async {
    final Uri endpoint = Uri.parse(
        "$trpcBase/posts.singlePost?input={\"handle\":\"$handle\",\"postId\":$id}");
    Response res = await get(endpoint,
        headers: {'Cookie': 'connect.sid=${AppSecrets.cookie}'});
    Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
    Map<String, dynamic> commentsRaw = body['result']['data']['comments'];
    final Map<String, dynamic> commentMap = commentsRaw;
    final Map<String, List<dynamic>> commentMapWithList = commentMap.map(
      (key, value) => MapEntry(key, List.from(value)),
    );
    final Map<String, List<CommentOuter>> commentMapWithListAndStuff =
        commentMapWithList.map(
      (key, value) => MapEntry(
          key,
          value
              .map(
                (e) => CommentOuter.fromJson(e),
              )
              .toList()),
    );

    return commentMapWithListAndStuff;
  }
}

class CommentOuter {
  late final PostComment comment;
  late final PostingProject poster;
  late final String canInteract;
  late final String canEdit;
  late final String canHide;

  CommentOuter.fromJson(Map<String, dynamic> json) {
    comment = PostComment.fromJson(json['comment']);
    poster = PostingProject.fromJson(json['poster']);
    canInteract = json['canInteract'];
    canEdit = json['canEdit'];
    canHide = json['canHide'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    data['poster'] = poster;
    data['canInteract'] = canInteract;
    data['canEdit'] = canEdit;
    data['canHide'] = canHide;
    return data;
  }
}

class PostComment {
  late final String commentId;
  late final String postedAtISO;
  late final bool deleted;
  late final String body;
  late final List<CommentOuter> children;
  late final int postId;
  late final String? inReplyTo;
  late final bool hasCohostPlus;
  late final bool hidden;

  PostComment.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    postedAtISO = json['postedAtISO'];
    deleted = json['deleted'];
    body = json['body'];
    children = List.from(json['children'])
        .map((e) => CommentOuter.fromJson(e))
        .toList();
    postId = json['postId'];
    inReplyTo = json['inReplyTo'];
    hasCohostPlus = json['hasCohostPlus'];
    hidden = json['hidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commentId'] = commentId;
    data['postedAtISO'] = postedAtISO;
    data['deleted'] = deleted;
    data['body'] = body;
    data['children'] = children;
    data['postId'] = postId;
    data['inReplyTo'] = inReplyTo;
    data['hasCohostPlus'] = hasCohostPlus;
    data['hidden'] = hidden;

    return data;
  }
}

enum BlockType { markdown, attachment, unknown }

class Block {
  late final String type;
  BlockType typeGood = BlockType.unknown;
  late final MarkdownBlock? markdown;
  late final AttachmentBlock? attachment;

  Block({
    required this.type,
    this.markdown,
    this.attachment,
  }) {
    inferType();
  }

  Block.fromJson(Map<String, dynamic> json) {
    type = json['type'];

    inferType();

    if (json['markdown'] != null) {
      markdown = MarkdownBlock?.fromJson(json['markdown']);
    }
    if (json['attachment'] != null) {
      attachment = AttachmentBlock?.fromJson(json['attachment']);
    }
  }

  void inferType() {
    switch (type) {
      case "markdown":
        typeGood = BlockType.markdown;
        break;
      case "attachment":
        typeGood = BlockType.attachment;
        break;
      default:
        break;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (attachment != null) {
      data['attachment'] = attachment!.toJson();
    }
    if (markdown != null) {
      data['markdown'] = markdown!.toJson();
    }
    return data;
  }
}

class AttachmentBlock {
  late final String fileURL;
  late final String previewURL;
  late final String attachmentId;
  late final String? altText;

  AttachmentBlock.fromJson(Map<String, dynamic> json) {
    fileURL = json['fileURL'];
    previewURL = json['previewURL'];
    attachmentId = json['attachmentId'];
    altText = json['altText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attachmentId'] = attachmentId;
    data['altText'] = altText;
    return data;
  }
}

class MarkdownBlock {
  late final String content;

  MarkdownBlock({
    required this.content,
  });

  MarkdownBlock.fromJson(Map<String, dynamic> json) {
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    return data;
  }
}

class PostingProject {
  PostingProject({
    required this.handle,
    this.displayName,
    this.dek,
    this.description,
    required this.avatarURL,
    required this.avatarPreviewURL,
    this.headerURL,
    this.headerPreviewURL,
    required this.projectId,
    required this.privacy,
    this.pronouns,
    this.url,
    required this.flags,
    required this.avatarShape,
  });
  late final String handle;
  late final String? displayName;
  late final String? dek;
  late final String? description;
  late final String avatarURL;
  late final String avatarPreviewURL;
  late final String? headerURL;
  late final String? headerPreviewURL;
  late final int projectId;
  late final String privacy;
  late final String? pronouns;
  late final String? url;
  late final List<dynamic> flags;
  late final String avatarShape;

  PostingProject.fromJson(Map<String, dynamic> json) {
    handle = json['handle'];
    displayName = json['displayName'];
    dek = json['dek'];
    description = json['description'];
    avatarURL = json['avatarURL'];
    avatarPreviewURL = json['avatarPreviewURL'];
    headerURL = json['headerURL'];
    headerPreviewURL = json['headerPreviewURL'];
    projectId = json['projectId'];
    privacy = json['privacy'];
    pronouns = json['pronouns'];
    url = json['url'];
    flags = List.castFrom<dynamic, dynamic>(json['flags']);
    avatarShape = json['avatarShape'];
  }

  static Future<Tuple2<PostingProject, List<Post>>> getUserData(
      String handle) async {
    try {
      PostList postList = PostList.fromUser(handle);
      List<Post> posts = await postList.postFuture;
      late PostingProject project;

      /* 
        oh hey, it's this fucking guy again. see above for
        another instance of this method. for some reason i can't
        find a normal way to get the full details about a page
        without just getting the normal page on cohost.org and
        extracting the state, or getting the first post from
        the post list and grabbing the details from there (each
        post has a `postingProject` key that contains the project's
        details in full). 
      */
      // if we can avoid making an extra request, do so
      if (posts.isNotEmpty) {
        project = posts[0].postingProject;
      } else {
        // otherwise just extract it from cohost.org
        final Uri endpoint = Uri.parse("https://cohost.org/$handle");
        Response res = await authenticatedGet(endpoint);

        if (res.statusCode == 200) {
          final Document parsed = parse(utf8.decode(res.bodyBytes));
          final Element elem =
              parsed.getElementById("__COHOST_LOADER_STATE__")!;
          final Map<String, dynamic> json = jsonDecode(elem.innerHtml);
          Map<String, dynamic> prObject =
              json['dashboard'] ?? json['project-page-view']['project'];
          project = PostingProject.fromJson(prObject);
        } else {
          throw "status code ${res.statusCode}";
        }
      }

      return Tuple2(project, posts);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<FollowStatus> getFollowStatus() async {
    Uri endpoint = Uri.parse(
        "$trpcBase/projects.followingState?input={\"projectHandle\":\"$handle\"}");

    Response res = await get(endpoint,
        headers: {'Cookie': 'connect.sid=${AppSecrets.cookie}'});

    Map<String, dynamic> json =
        jsonDecode(utf8.decode(res.bodyBytes))['result']['data'];
    FollowStatus followStatus = FollowStatus.fromJson(json);
    return followStatus;
  }
}

class FollowStatus {
  late final int readerToProject;
  late final int projectToReader;

  FollowStatus.fromJson(Map<String, dynamic> json) {
    readerToProject = json['readerToProject'];
    projectToReader = json['projectToReader'] ?? 0;
  }
}
