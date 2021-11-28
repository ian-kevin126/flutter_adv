enum HttpMethod { GET, POST, DELETE }

/// 基础请求
abstract class BaseRequest {
  /// get请求可能出现下面两种情况
  /// 查询参数：curl -X GET "http://api.devio.org/uapi/test/test?requestPrams=11" -H "accept: */*"
  /// 路径参数：curl -X GET "https://api.devio.org/uapi/test/test/1
  var pathParams;

  /// 默认https请求
  var useHttps = true;

  /// api接口域名
  String authority() {
    return "api.devio.org";
  }

  /// 请求方法
  HttpMethod httpMethod();

  /// 请求路径
  String path();

  /// 拼装api的url
  String url() {
    Uri uri;
    var pathStr = path();

    /// 拼接path参数
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }

    /// http和https切换
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }

    print('url:${uri.toString()}');
    return uri.toString();
  }

  /// 接口是否需要登录才能访问
  bool needLogin();

  Map<String, String> params = Map();

  /// 添加参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  // 接口鉴权
  Map<String, dynamic> header = {};

  /// 添加header
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}

/**
 *
 * void TestApi() async {
      TestRequest request = TestRequest();
      request.add('name', 'kevin').add('age', '18');
      var res = await HiNet.getInstance().fire(request);
      print(res)
    }
 *
**/
