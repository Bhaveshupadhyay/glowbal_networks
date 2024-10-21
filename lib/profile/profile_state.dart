abstract class ImageState{}

class ImageInitial extends ImageState{}
class ImageLoading extends ImageState{}

class ImageLoaded extends ImageState{
  final bool isOnline;
  final String path;

  ImageLoaded(this.isOnline, this.path);
}