class StreamSummary {
  final int streamId;
  final String title;
  final String coverAddr;
  final int status;
  final String teacherEmail;
  final String teacherName;

  StreamSummary({
    required this.streamId,
    required this.title,
    required this.coverAddr,
    required this.status,
    required this.teacherEmail,
    required this.teacherName,
  });


  factory StreamSummary.fromJson(Map<String, dynamic> json) {
    return StreamSummary(
      streamId: json['streamId'] as int,
      title: json['title'] as String,
      coverAddr: json['coverAddr'] as String,
      status: json['status'] as int,
      teacherEmail: json['teacherEmail'] as String,
      teacherName: json['teacherName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'streamId': streamId,
      'title': title,
      'coverAddr': coverAddr,
      'status': status,
      'teacherEmail': teacherEmail,
      'teacherName': teacherName,
    };
  }

  @override
  String toString() {
    return 'StreamSummary{streamId: $streamId, title: $title, coverAddr: $coverAddr, status: $status, teacherEmail: $teacherEmail, teacherName: $teacherName}';
  }
}