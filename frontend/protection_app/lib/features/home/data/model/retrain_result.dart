

class RetrainResult {
  final String status;
  final int samples_used;

  RetrainResult({
    required this.status,
    required this.samples_used,
  });

  factory RetrainResult.fromJson(Map<String, dynamic> json) {
    return RetrainResult(
      status: json['status'] as String,
      samples_used: json['samples_used'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'samples_used': samples_used,
    };
  }
}