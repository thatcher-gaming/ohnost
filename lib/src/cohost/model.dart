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
  late final List<dynamic> tags;
  late final List<Block> blocks;
  late final String plainTextBody;
  late final PostingProject postingProject;
  late final List<dynamic> shareTree;
  late final List<dynamic> relatedProjects;
  late final String singlePostPageUrl;
  late final bool effectiveAdultContent;
  late final bool isEditor;
  late final bool contributorBlockIncomingOrOutgoing;
  late final bool hasAnyContributorMuted;
  late final String postEditUrl;
  late final bool isLiked;
  late final bool canShare;
  late final bool canPublish;
  late final bool hasCohostPlus;
  late final bool pinned;
  late final bool commentsLocked;

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
    tags = List.castFrom<dynamic, dynamic>(json['tags']);
    blocks = List.from(json['blocks']).map((e) => Block.fromJson(e)).toList();
    plainTextBody = json['plainTextBody'];
    postingProject = PostingProject.fromJson(json['postingProject']);
    shareTree = List.castFrom<dynamic, dynamic>(json['shareTree']);
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
  }
}

enum BlockType { markdown, attachment, unknown }

class Block {
  late final String type;
  BlockType typeGood = BlockType.unknown;
  late final Markdown? markdown;
  late final Attachment? attachment;

  Block({
    required this.type,
    this.markdown,
    this.attachment,
  });

  Block.fromJson(Map<String, dynamic> json) {
    type = json['type'];

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

    if (json['markdown'] != null) {
      markdown = Markdown?.fromJson(json['markdown']);
    }
    if (json['attachment'] != null) {
      attachment = Attachment?.fromJson(json['attachment']);
    }
  }
}

class Attachment {
  late final String fileURL;
  late final String previewURL;
  late final String attachmentId;
  late final String? altText;

  Attachment.fromJson(Map<String, dynamic> json) {
    fileURL = json['fileURL'];
    previewURL = json['previewURL'];
    attachmentId = json['attachmentId'];
    altText = json['altText'];
  }
}

class Markdown {
  late final String content;

  Markdown({
    required this.content,
  });

  Markdown.fromJson(Map<String, dynamic> json) {
    content = json['content'];
  }
}

class PostingProject {
  PostingProject({
    required this.handle,
    this.displayName,
    this.dek,
    this.description,
    this.avatarURL,
    this.avatarPreviewURL,
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
  late final String? avatarURL;
  late final String? avatarPreviewURL;
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
}
