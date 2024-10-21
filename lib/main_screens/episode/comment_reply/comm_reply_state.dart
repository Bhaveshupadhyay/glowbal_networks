import '../../../modal_class/comment_modal.dart';
import '../../../modal_class/reply_modal.dart';

abstract class CommentReplyState{}

class DesInitial extends CommentReplyState{}

class DescriptionShow extends CommentReplyState{}
class DescriptionHide extends CommentReplyState{}
class CommentShow extends CommentReplyState{}
class CommentHide extends CommentReplyState{}

class ReplyShow extends CommentReplyState{
  CommentModal commentModal;

  ReplyShow(this.commentModal);
}
class ReplyHide extends CommentReplyState{}

abstract class FetchCommentState{}
class CommentInitial extends FetchCommentState{}
class CommentLoading extends FetchCommentState{}

class CommentLoaded extends FetchCommentState{
  final List<CommentModal> list;
  final bool hasReachedMax;

  CommentLoaded(this.list, this.hasReachedMax);
}
class CommentMoreLoading extends FetchCommentState{}

class CommentInsertLoading extends FetchCommentState{}

class CommentInsertFailed extends FetchCommentState{
  final String errorMsg;

  CommentInsertFailed(this.errorMsg);
}

class NotLoggedIn extends FetchCommentState{}

abstract class FetchReplyState{}
class ReplyInitial extends FetchReplyState{}
class ReplyLoading extends FetchReplyState{}

class ReplyLoaded extends FetchReplyState{
  final CommentModal commentModal;
  final List<ReplyModal> list;
  final bool hasReachedMax;

  ReplyLoaded(this.commentModal,this.list, this.hasReachedMax);
}

class UserNotLoggedIn extends FetchReplyState{}
class ReplyInsertLoading extends FetchReplyState{}