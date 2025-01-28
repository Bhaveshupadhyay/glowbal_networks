import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/modal_class/continue_watching_modal.dart';
import 'package:zeus/modal_class/episode_modal.dart';
import 'package:zeus/modal_class/home_modal.dart';
import 'package:zeus/modal_class/search_modal.dart';
import 'package:zeus/modal_class/subscription_modal.dart';
import 'package:zeus/modal_class/video_data.dart';
import 'package:zeus/modal_class/video_modal.dart';

import '../modal_class/comment_modal.dart';
import '../modal_class/reply_modal.dart';
import '../modal_class/user_details.dart';

class MyApi{
  static const baseUrl="https://glowbal.co.uk/api";
  static const imgUrl="https://glowbal.co.uk/api/uploads";

  static final _obj=MyApi();

  static MyApi getInstance()=>_obj;

  Future<List<VideoModal>> getSlider() async {
    List<VideoModal> list=[];
    await http.get(Uri.parse("$baseUrl/get/slider.php")).then(
        (response){
          if(response.statusCode==200){
            for(var json in jsonDecode(response.body)){
              list.add(VideoModal.fromJson(json));
            }
          }
        }
    );
    return list;
  }

  Future<List<HomeModal>> getHomeVideos(String offset) async {
    List<HomeModal> list=[];
    await http.post(Uri.parse("$baseUrl/get/home.php"),body: {"offset":offset}).then(
        (response){
          if(response.statusCode==200){
            // print(response.body);
            for(var json in jsonDecode(response.body)){
              VideoModal videoModal=VideoModal.fromHomeJson(json);
              List<EpisodeModal> episodeList=[];
              for(var json in json["episodes"]){
                episodeList.add(EpisodeModal.fromJson(json));
              }
              list.add(HomeModal(videoModal, episodeList,json['latestSeasonNumber']??'0'));
            }

          }
        }
    );
    return list;
  }

  Future<List<ContinueWatchingModal>> getContinueWatchingEpisodes() async {
    List<ContinueWatchingModal> list=[];
    if(UserDetails.id==null || UserDetails.id=='') return list;

    await http.post(Uri.parse("$baseUrl/get/continue_episode.php"),body: {"user_id":UserDetails.id}).then(
            (response){
          if(response.statusCode==200){
            for(var json in jsonDecode(response.body)){
              list.add(ContinueWatchingModal(json['last_watched_position'],EpisodeModal.fromJson(json)));
            }
          }
        }
    );
    return list;
  }


  Future<int> getSeasonCount(String videoId) async {
    int seasonCount=0;
    await http.post(Uri.parse("$baseUrl/get/videoSeasonCount.php"),body: {"videoId":videoId}).then(
            (response){
          if(response.statusCode==200){
            // print(response.body);
            for(var json in jsonDecode(response.body)){
              seasonCount=int.parse(json['count']);
            }

          }
        }
    );
    return seasonCount;
  }

  Future<List<EpisodeModal>> getSeasonEpisodes(String season,String videoId) async {
    List<EpisodeModal> list=[];
    await http.post(Uri.parse("$baseUrl/get/episodesBySeason.php"),body: {"season":season,"videoId":videoId}).then(
            (response){
          if(response.statusCode==200){
            // print(response.body);
            for(var json in jsonDecode(response.body)){
              list.add(EpisodeModal.fromJson(json));
            }

          }
        }
    );
    return list;
  }

  Future<List<EpisodeModal>> getNextEpisodes(String seasonId,String episodeId) async {
    List<EpisodeModal> list=[];
    await http.post(Uri.parse("$baseUrl/get/nextEpisodes.php"),body: {"seasonId":seasonId,"episodeId":episodeId}).then(
            (response){
          if(response.statusCode==200){
            // print(response.body);
            for(var json in jsonDecode(response.body)){
              list.add(EpisodeModal.fromJson(json));
            }

          }
        }
    );
    return list;
  }

  Future<SearchModal> search(String s) async {
    List<EpisodeModal> episodesList=[];
    List<VideoModal> videoList=[];
    await http.post(Uri.parse("$baseUrl/get/search.php"),body: {"s":s}).then(
            (response){
          if(response.statusCode==200){
            // print(response.body);
            for(var json in jsonDecode(response.body)['episodes']??[]){
              episodesList.add(EpisodeModal.fromJson(json));
            }

            for(var json in jsonDecode(response.body)['collections']??[]){
              videoList.add(VideoModal.fromJson(json));
            }
          }
        }
    );
    return SearchModal(episodesList, videoList);
  }

  Future<UserDetails> getUserDetails(String email)async {
    UserDetails userDetails=UserDetails.fromJson({});
    await http.post(Uri.parse('$baseUrl/get/userDetails.php'),body: {"email":email})
        .then((response){
      if(response.statusCode==200){
        List list=jsonDecode(response.body);
        if(list.isNotEmpty) {
          UserDetails.id=list[0]['id'];
          userDetails=UserDetails.fromJson(list[0]);
        }
      }
    });
    return userDetails;
  }

  Future<bool> login(String email,String password)async {
    bool isSuccess=false;
    await http.post(Uri.parse('$baseUrl/auth/login.php'),body: {"email":email,"password":password})
        .then((response){
      if(response.statusCode==200){
        // print(response.body);
        isSuccess=jsonDecode(response.body)['isSuccess'];
      }
    });
    return isSuccess;
  }

  Future<bool> register(String email,String password,String name,String image,String ip)async {
    bool isSuccess=false;
    Map<String, dynamic> map={
      "email":email,
      "password":password,
      "name": name,
      "image": image,
      "ip_address": ip};

    await http.post(Uri.parse('$baseUrl/auth/register.php'),headers: {'Content-Type': 'application/json'},
      body: jsonEncode(map),)
        .then((response){
      if(response.statusCode==200){
        // print(response.body);
        isSuccess=jsonDecode(response.body)['isSuccess'];
      }
    });
    return isSuccess;
  }
  Future<CommentModal> insertComment(String userId,String episodeId,String text)async {
    CommentModal commentModal=CommentModal(showReplies: false);
    final Map<String, dynamic> data = {
      "userId": userId,
      "episodeId": episodeId,
      "text": text
    };
    await http.post(Uri.parse('$baseUrl/insert/comment.php'),body: jsonEncode(data)).timeout(const Duration(seconds: 30))
        .then((response){
      if(response.statusCode==200){
        print(response.body);
        Map<String,dynamic> map=jsonDecode(response.body);
        if(map['isSuccess']){
          for(var json in map['result']){
            commentModal= CommentModal.fromJson(json, map['usaTimestamp']);
          }
        }
      }
    });
    return commentModal;
  }

  Future<ReplyModal> insertReply(String userId,String commId,String text)async {
    ReplyModal replyModal=ReplyModal.fromJson({}, 0);
    final Map<String, dynamic> data = {
      "userId": userId,
      "commId": commId,
      "text": text
    };
    // print(data);
    await http.post(Uri.parse('$baseUrl/insert/reply.php'),body: jsonEncode(data)).timeout(const Duration(seconds: 30))
        .then((response){
      if(response.statusCode==200){
        // print(response.body);
        Map<String,dynamic> map=jsonDecode(response.body);
        if(map['isSuccess']){
          for(var json in map['result']){
            replyModal= ReplyModal.fromJson(json, map['usaTimestamp']);
          }
        }
      }
    });
    return replyModal;
  }

  Future<List<CommentModal>> getComments(String episodeId,int offset)async {
    List<CommentModal> list=[];
    await http.post(Uri.parse('$baseUrl/get/comments.php'),body: {"episodeId":episodeId,"offset":offset.toString()})
        .then((response){
      if(response.statusCode==200){
        // print(response.body);
        var data=jsonDecode(response.body);
        for(var json in data['results']){
          list.add(CommentModal.fromJson(json, data['usaTimestamp']));
        }

      }
    });
    return list;
  }

  Future<List<ReplyModal>> getReplies(String commId,int offset)async {
    List<ReplyModal> list=[];
    await http.post(Uri.parse('$baseUrl/get/replies.php'),body: {"commId":commId,"offset":offset.toString()})
        .then((response){
      if(response.statusCode==200){
        // print(response.body);
        var data=jsonDecode(response.body);
        for(var json in data['results']){
          list.add(ReplyModal.fromJson(json, data['usaTimestamp']));
        }

      }
    });
    return list;
  }

  Future<String> uploadImage(String filePath) async {
    // Prepare the file
    var file = File(filePath);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/uploadImage.php'),
    );

    // Attach the file to the request
    request.files.add(
      await http.MultipartFile.fromPath('fileToUpload', file.path),
    );

    try {
      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        // You can also read the response body if needed
        var responseBody = await http.Response.fromStream(response);
        print('Response: ${responseBody.body}');
        var json=jsonDecode(responseBody.body);
        if(json['isSuccess']){
          return json['image'];
        }

      } else {
        print('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return '';
  }

  Future<String> getIp()async {
    String ip='N/A';
    await http.get(Uri.parse('$baseUrl/get/ipAddress.php')).then(
            (response){
          if(response.statusCode==200){
            ip= jsonDecode(response.body)['origin'];
          }
        }
    );
    return ip;
  }

  Future<bool> deleteAccount()async {
    bool isSuccess=false;
    await http.post(Uri.parse('$baseUrl/delete/user.php'),body: {"id":UserDetails.id})
        .then((response){
      if(response.statusCode==200){
        isSuccess= jsonDecode(response.body)['isSuccess'];
      }
    });
    return isSuccess;
  }

  Future<void> updateContinueEpisode(String episodeId,String lastWatchedPosition)async {
    if(UserDetails.id==null || UserDetails.id=='') return;
    await http.post(Uri.parse('$baseUrl/insert/continue_episode.php'),body: {"user_id":UserDetails.id,
      "episode_id": episodeId,
      "last_watched_position": lastWatchedPosition
    })
        .then((response){
      if(response.statusCode==200){

      }
    });
  }


  Future<SubscriptionModal> getSubscription(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get/subscription.php'),
        body: {"email": email},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print(data);
        return SubscriptionModal.fromJson(data);
      } else {
        throw Exception('Failed to load subscription. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  // Future<Map<String,dynamic>> getVideoUrl(String videoUrl) async {
  //   final prefs= await SharedPreferences.getInstance();
  //   String email=prefs.getString('email')??'';
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/get/videoUrl.php'),
  //       body: {"email": email,"videoUrl": videoUrl},
  //     );
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       // print(data);
  //       return data;
  //     } else {
  //       throw Exception('Failed to load subscription. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('An error occurred: $e');
  //   }
  // }

  Future<VideoData> getVideoUrl({required String videoId}) async {
    final prefs= await SharedPreferences.getInstance();
    String email=prefs.getString('email')??'';
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get/videoLink.php'),
        body: {"email": email,"video_id": videoId},
      );
      if (response.statusCode == 200) {
        // print(data);
        return VideoData.fromJson(json.decode(response.body),false);
      } else {
        throw Exception('Failed to load subscription. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<VideoData> getTrailerUrl({required String trailerId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get/trailerLink.php'),
        body: {"trailer_id": trailerId},
      );
      if (response.statusCode == 200) {
        // print(response.body);
        return VideoData.fromJson(json.decode(response.body),true);
      } else {
        throw Exception('Failed to load subscription. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> sendVerifyEmail()async {
    final prefs= await SharedPreferences.getInstance();
    String email=prefs.getString('email')??'';
    await http.post(Uri.parse('$baseUrl/mail/resendMail.php'),body: {"email":email})
        .then((response){
      if(response.statusCode==200){

      }
    });
  }

  Future<void> sendCancelEmail()async {
    final prefs= await SharedPreferences.getInstance();
    String email=prefs.getString('email')??'';
    await http.post(Uri.parse('$baseUrl/mail/cancelMail.php'),body: {"email":email})
        .then((response){
      if(response.statusCode==200){

      }
    });
  }
}