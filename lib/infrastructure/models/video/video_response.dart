import 'package:cinemania/infrastructure/models/video/video_videodb.dart';

class VideoResponse {
    final int id;
    final List<VideoVideoDB> results;

    VideoResponse({
        required this.id,
        required this.results,
    });

    factory VideoResponse.fromJson(Map<String, dynamic> json) => VideoResponse(
        id: json["id"],
        results: List<VideoVideoDB>.from(json["results"].map((x) => VideoVideoDB.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}


