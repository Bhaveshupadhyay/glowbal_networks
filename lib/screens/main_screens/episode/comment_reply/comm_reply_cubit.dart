import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../backend/my_api.dart';
import '../../../../modal_class/comment_modal.dart';
import '../../../../modal_class/reply_modal.dart';
import '../../../../modal_class/user_details.dart';
import 'comm_reply_state.dart';

class DesCommCubit extends Cubit<CommentReplyState>{

  DesCommCubit(): super(DesInitial());

  void showDescription(){
    emit(DescriptionShow());
  }

  void hideDescription(){
    emit(DescriptionHide());
  }

  void showComment(){
    emit(CommentShow());
  }

  void hideComment(){
    emit(CommentHide());
  }

  void showReply(CommentModal commentModal){
    emit(ReplyShow(commentModal));
  }

  void hideReply(){
    emit(ReplyHide());
  }
}

class CommentCubit extends Cubit<FetchCommentState>{

  bool _hasReachedMax=false;
  final String episodeId;
  bool _isLoading=false;
  CommentCubit(this.episodeId):super(CommentInitial());

  Future<void> fetchComments() async {
    if(_hasReachedMax || _isLoading) return;
    List<CommentModal> oldList= (state is CommentLoaded)? (state as CommentLoaded).list : [];
    if(oldList.isEmpty) {
      emit(CommentLoading());
    }
    _isLoading=true;
    List<CommentModal> list= await MyApi.getInstance().getComments(episodeId, oldList.length);
    _isLoading=false;
    print(list.length);
    if(list.isEmpty){
      _hasReachedMax=true;
    }
    else{
      oldList.addAll(list);
    }
    if(list.length<5){
      _hasReachedMax=true;
    }
    if (isClosed) return;
    emit(CommentLoaded(oldList,_hasReachedMax));
  }

  Future<void> insertComments(String text)async {
    if(UserDetails.id==null || UserDetails.id==''){
      emit(NotLoggedIn());
      return;
    }
    if(text.trim().isEmpty){
      // emit(CommentInsertFailed('Comment can be empty'));
      return;
    }
    List<CommentModal> oldList= (state is CommentLoaded)? (state as CommentLoaded).list : [];
    CommentModal commentModal=await MyApi.getInstance().insertComment(UserDetails.id!, episodeId, text);
    emit(CommentInsertLoading());
    oldList.insert(0, commentModal);
    // print(oldList.length);
    emit(CommentLoaded(oldList,_hasReachedMax));
  }

}
class ReplyCubit extends Cubit<FetchReplyState>{

  bool _hasReachedMax=false;
  bool _isLoading=false;
  ReplyCubit():super(ReplyInitial());

  Future<void> fetchReply(CommentModal commentModal) async {
    _hasReachedMax=false;
    emit(ReplyLoading());
    List<ReplyModal> list= await MyApi.getInstance().getReplies(commentModal.id!, 0);
    if(list.isEmpty || list.length<5){
      _hasReachedMax=true;
    }
    if (isClosed) return;
    emit(ReplyLoaded(commentModal,list,_hasReachedMax));
  }

  Future<void> loadMoreReply(CommentModal commentModal) async {
    if(_hasReachedMax || _isLoading) return;
    List<ReplyModal> oldList= (state is ReplyLoaded)? (state as ReplyLoaded).list : [];
    if(oldList.isEmpty) {
      emit(ReplyLoading());
    }
    // print(oldList.length);
    _isLoading=true;
    List<ReplyModal> list= await MyApi.getInstance().getReplies(commentModal.id!, oldList.length);
    _isLoading=false;

    if(list.isEmpty){
      _hasReachedMax=true;
    }
    else{
      oldList.addAll(list);
    }
    if (isClosed) return;
    emit(ReplyLoaded(commentModal,oldList,_hasReachedMax));
  }

  Future<void> insertReply(CommentModal commentModal,String text) async {
    // emit(ReplyLoading());
    if(UserDetails.id==null || UserDetails.id==''){
      emit(UserNotLoggedIn());
      return;
    }
    List<ReplyModal> oldList= (state is ReplyLoaded)? (state as ReplyLoaded).list : [];
    ReplyModal replyModal= await MyApi.getInstance().insertReply(UserDetails.id!, commentModal.id!, text);
    emit(ReplyInsertLoading());
    oldList.insert(0,replyModal);
    if (isClosed) return;
    emit(ReplyLoaded(commentModal,oldList,_hasReachedMax));
  }

}