/// Detection Response Model
/// Response from the audio detection API
class DetectionResponse {
  final bool success;
  final String message;
  final DetectionData? data;

  DetectionResponse({required this.success, required this.message, this.data});

  factory DetectionResponse.fromJson(Map<String, dynamic> json) {
    return DetectionResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? DetectionData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Detection Data Model
class DetectionData {
  final String topLabel;
  final double value;

  DetectionData({required this.topLabel, required this.value});

  factory DetectionData.fromJson(Map<String, dynamic> json) {
    return DetectionData(
      topLabel: json['top_label'] as String,
      value: (json['value'] as num).toDouble(),
    );
  }
}

/// API Error Response Model
class ApiErrorResponse {
  final List<ErrorDetail> detail;

  ApiErrorResponse({required this.detail});

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      detail: (json['detail'] as List)
          .map((e) => ErrorDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Error Detail Model
class ErrorDetail {
  final List<dynamic> loc;
  final String msg;
  final String type;

  ErrorDetail({required this.loc, required this.msg, required this.type});

  factory ErrorDetail.fromJson(Map<String, dynamic> json) {
    return ErrorDetail(
      loc: json['loc'] as List<dynamic>,
      msg: json['msg'] as String,
      type: json['type'] as String,
    );
  }
}
