class VideoData {
  bool? isSubActive;
  List<VideoVersion>? sdVersions;
  List<VideoVersion>? hdVersions;
  List<VideoVersion>? hlsVersions;
  List<String>? qualities;

  VideoData({
    required this.isSubActive,
    this.sdVersions,
    this.hdVersions,
    this.hlsVersions,
    this.qualities,
  });

  factory VideoData.fromJson(Map<String, dynamic> json, bool isTrailer) {
    if((json['isSubActive']==false || json['isSubActive']==null) && !isTrailer) {
      return VideoData(isSubActive: false);
    }
    return VideoData(
      isSubActive: json['isSubActive'],
      sdVersions: (json['sd_versions'] as List)
          .map((e) => VideoVersion.fromJson(e))
          .toList(),
      hdVersions: (json['hd_versions'] as List)
          .map((e) => VideoVersion.fromJson(e))
          .toList(),
      hlsVersions: (json['hls_versions'] as List)
          .map((e) => VideoVersion.fromJson(e))
          .toList(),
      qualities: List<String>.from(json['qualities']),
    );
  }
}

class VideoVersion {
  String rendition;
  String link;
  String size;

  VideoVersion({
    required this.rendition,
    required this.link,
    required this.size,
  });

  factory VideoVersion.fromJson(Map<String, dynamic> json) {
    return VideoVersion(
      rendition: json['rendition'],
      link: json['link'],
      size: json['size'],
    );
  }
}