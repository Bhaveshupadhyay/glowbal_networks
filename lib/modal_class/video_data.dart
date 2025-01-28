class VideoData {
  final bool? isSubActive;
  final List<VideoVersion>? sdVersions;
  final List<VideoVersion>? hdVersions;
  final List<VideoVersion>? hlsVersions;
  final List<String>? qualities;

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
    List<String> sortedQualities= List<String>.from(json['qualities']);
    sortedQualities.sort((a, b) {
      // If either value is "adaptive", we push it to the end
      if (a == "adaptive") return -1;
      if (b == "adaptive") return 1;

      // Sort numbers as integers
      return int.parse(a).compareTo(int.parse(b));
    });

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
      qualities: sortedQualities,
    );
  }
}

class VideoVersion {
  final String rendition;
  final String link;
  final String size;

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