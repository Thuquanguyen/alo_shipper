import 'package:intl/intl.dart';

class ShipModel {
  final List<Shipper>? data;

  ShipModel({this.data});

  factory ShipModel.fromJson(Map<String, dynamic> json) {
    return ShipModel(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => Shipper.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shipper {
  final Attributes? attributes;
  final String? id;
  final String? type;

  Shipper({this.attributes, this.id, this.type});

  factory Shipper.fromJson(Map<String, dynamic> json) {
    return Shipper(
      attributes: json['attributes'] != null
          ? Attributes.fromJson(json['attributes'])
          : null,
      id: json['id'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    if (attributes != null) {
      data['attributes'] = attributes?.toJson();
    }
    return data;
  }
}

class Attributes {
  final String? content;
  final int? id;
  final String? postId;
  final String? username;
  final int? timeCrawl;
  final String? fbUserPostId;

  Attributes(
      {this.content,
      this.id,
      this.postId,
      this.username,
      this.timeCrawl,
      this.fbUserPostId});


  String readTimestamp() {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch((timeCrawl ?? 0) * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }
    return time;
  }

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      content: json['content'],
      id: json['id'],
      postId: json['post_id'],
      username: json['username'],
      timeCrawl: json['time_crawl'],
      fbUserPostId: json['fb_user_post_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['id'] = id;
    data['post_id'] = postId;
    data['username'] = username;
    data['time_crawl'] = timeCrawl;
    data['fb_user_post_id'] = fbUserPostId;
    return data;
  }
}
