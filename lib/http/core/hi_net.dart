import 'package:flutter_bili_app/http/core/dio_adapter.dart';

import '../../request/base_request.dart';
import '../hi_error.dart';
import '../hi_net_adapter.dart';
import '../mock_adapter.dart';

///1.支持网络库插拔设计，且不干扰业务层
///2.基于配置请求请求，简洁易用
///3.Adapter设计，扩展性强
///4.统一异常和返回处理
class HiNet {
  HiNet._();

  //创建一个单例
  static HiNet? _instance;

  //获取单例（懒汉模式-用的时候才生成）
  static HiNet getInstance() {
    // if (_instance == null) {
    //   _instance = HiNet._();
    // }
    // 等价于
    _instance ??= HiNet._();
    return _instance!;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse? response;
    var error;
    try {
      response = await send(request);
      //  HiNet的异常
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      //兜底其它异常
      error = e;
      printLog(e);
    }
    if (response == null) {
      printLog(error);
    }
    var result = response?.data;
    printLog(result);
    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status ?? -1, result.toString(), data: result);
    }
  }

  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    ///使用Dio发送请求
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print('hi_net:' + log.toString());
  }
}
