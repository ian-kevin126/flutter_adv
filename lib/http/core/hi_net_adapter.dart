import 'dart:convert';

import 'package:flutter_bili_app/http/request/base_request.dart';

///网络请求抽象类
abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}

/// 统一网络层返回格式（泛型）
class HiNetResponse<T> {
  HiNetResponse({
    this.data,
    required this.request,
    //状态码
    this.statusCode,
    //状态信息
    this.statusMessage,
    //额外的数据
    this.extra,
  });

  /// Response body. may have been transformed, please refer to [ResponseType].
  T? data;

  /// The corresponding request info.
  BaseRequest request;

  /// Http status code.
  int? statusCode;

  /// Returns the reason phrase associated with the status code.
  /// The reason phrase must be set before the body is written
  /// to. Setting the reason phrase after writing to the body.
  String? statusMessage;

  /// Custom field that you can retrieve it later in `then`.
  late dynamic extra;

  /// We are more concerned about `data` field.
  @override
  String toString() {
    if (data is Map) {
      //如果是map，转化为string
      return json.encode(data);
    }
    return data.toString();
  }
}
