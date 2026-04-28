

class Retrain{
  final String status;
  final int buffer_size;

  Retrain({
    required this.status,
    required this.buffer_size,
  });

  factory Retrain.fromJson(Map<String, dynamic> json) {
    return Retrain(
      status: json['status'] as String,
      buffer_size: json['buffer_size'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'buffer_size': buffer_size,
    };
  }
}