class MotoristaDTO {
  final String displayName;
  final String motoristaID;

  MotoristaDTO({
    required this.displayName,
    required this.motoristaID,
  });

  factory MotoristaDTO.fromJson(Map<String, dynamic> json) {
    return MotoristaDTO(
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