class MotoristaDTOs {
  final String displayName;
  final String motoristaID;

  MotoristaDTOs({
    required this.displayName,
    required this.motoristaID,
  });

  factory MotoristaDTOs.fromJson(Map<String, dynamic> json) {
    return MotoristaDTOs(
      displayName: json['displayName'] ?? '',
      motoristaID: json['motoristaID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'motoristaID': motoristaID,
    };
  }
}
