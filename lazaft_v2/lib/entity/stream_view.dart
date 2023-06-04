class StreamView {
  int streamId;
  String streamAddr;
  String teacherEmail;
  String teacherName;
  String avatarAddr;

  StreamView.noParm({
    this.streamId = -1,
    this.streamAddr = '',
    this.teacherEmail = '',
    this.teacherName = '',
    this.avatarAddr = '',
  });

  StreamView({
    required this.streamId,
    required this.streamAddr,
    required this.teacherEmail,
    required this.teacherName,
    required this.avatarAddr,
  });

  factory StreamView.fromJson(Map<String, dynamic> json) {
    return StreamView(
      streamId: json['streamId'],
      streamAddr: json['streamAddr'],
      teacherEmail: json['teacherEmail'],
      teacherName: json['teacherName'],
      avatarAddr: json['avatarAddr'],
    );
  }

  @override
  String toString() {
    return 'StreamView(streamId: $streamId, streamAddr: $streamAddr, teacherEmail: $teacherEmail, teacherName: $teacherName, avatarAddr: $avatarAddr)';
  }
}
