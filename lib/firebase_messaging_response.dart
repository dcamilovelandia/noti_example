import 'dart:convert';

class FirebaseMessagingResponse {
  Schedule? schedule;
  List<ActionButton>? actionButtons;
  Content? content;

  FirebaseMessagingResponse({
    this.schedule,
    this.actionButtons,
    this.content,
  });

  factory FirebaseMessagingResponse.fromJson(Map<String, dynamic> json) => FirebaseMessagingResponse(
    schedule: Schedule.fromJson(jsonDecode(json["schedule"])),
    actionButtons: List<ActionButton>.from(jsonDecode(json["actionButtons"]).map((x) => ActionButton.fromJson(x))),
    content: Content.fromJson(jsonDecode(json["content"])),
  );

  Map<String, dynamic> toJson() => {
    "schedule": schedule!.toJson(),
    "actionButtons": List<dynamic>.from(actionButtons!.map((x) => x.toJson())),
    "content": content!.toJson(),
  };
}

class ActionButton {
  String? buttonType;
  String? label;
  bool? autoCancel;
  String? key;

  ActionButton({
    this.buttonType,
    this.label,
    this.autoCancel,
    this.key,
  });

  factory ActionButton.fromJson(Map<String, dynamic> json) => ActionButton(
    buttonType: json["buttonType"],
    label: json["label"],
    autoCancel: json["autoCancel"],
    key: json["key"],
  );

  Map<String, dynamic> toJson() => {
    "buttonType": buttonType,
    "label": label,
    "autoCancel": autoCancel,
    "key": key,
  };
}

class Content {
  String? channelKey;
  String? largeIcon;
  bool? showWhen;
  String? notificationLayout;
  String? privacy;
  int? id;
  String? title;
  String? body;
  bool? autoCancel;
  String? bigPicture;

  Content({
    this.channelKey,
    this.largeIcon,
    this.showWhen,
    this.notificationLayout,
    this.privacy,
    this.id,
    this.title,
    this.body,
    this.autoCancel,
    this.bigPicture,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    channelKey: json["channelKey"],
    largeIcon: json["largeIcon"],
    showWhen: json["showWhen"],
    notificationLayout: json["notificationLayout"],
    privacy: json["privacy"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
    autoCancel: json["autoCancel"],
    bigPicture: json["bigPicture"],
  );

  Map<String, dynamic> toJson() => {
    "channelKey": channelKey,
    "largeIcon": largeIcon,
    "showWhen": showWhen,
    "notificationLayout": notificationLayout,
    "privacy": privacy,
    "id": id,
    "title": title,
    "body": body,
    "autoCancel": autoCancel,
    "bigPicture": bigPicture,
  };
}

class Schedule {
  DateTime? initialDateTime;
  List<dynamic>? preciseSchedules;
  String? crontabSchedule;
  bool? allowWhileIdle;

  Schedule({
    this.initialDateTime,
    this.preciseSchedules,
    this.crontabSchedule,
    this.allowWhileIdle,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    initialDateTime: DateTime.parse(json["initialDateTime"]),
    preciseSchedules: List<dynamic>.from(json["preciseSchedules"].map((x) => x)),
    crontabSchedule: json["crontabSchedule"],
    allowWhileIdle: json["allowWhileIdle"],
  );

  Map<String, dynamic> toJson() => {
    "initialDateTime": initialDateTime!.toIso8601String(),
    "preciseSchedules": List<dynamic>.from(preciseSchedules!.map((x) => x)),
    "crontabSchedule": crontabSchedule,
    "allowWhileIdle": allowWhileIdle,
  };
}