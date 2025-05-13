class HighlightedTags {
  HighlightedTags({
    this.type,
    this.tags,
  });

  HighlightedTags.fromJson(dynamic json) {
    type = json['type'];
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags?.add(Tags.fromJson(v));
      });
    }
  }
  String? type;
  List<Tags>? tags;
  HighlightedTags copyWith({
    String? type,
    List<Tags>? tags,
  }) =>
      HighlightedTags(
        type: type ?? this.type,
        tags: tags ?? this.tags,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    if (tags != null) {
      map['tags'] = tags?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Tags {
  Tags({
    this.tag,
    this.icon,
  });

  Tags.fromJson(dynamic json) {
    tag = json['tag'];
    icon = json['icon'];
  }
  String? tag;
  String? icon;
  Tags copyWith({
    String? tag,
    String? icon,
  }) =>
      Tags(
        tag: tag ?? this.tag,
        icon: icon ?? this.icon,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tag'] = tag;
    map['icon'] = icon;
    return map;
  }
}
