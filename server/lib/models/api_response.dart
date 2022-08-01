import 'dart:convert';

import 'package:domain/model/api_error.dart';
import 'package:shelf/shelf.dart';

class APIResponse {
  static success(dynamic data) => Response.ok(
        json.encode({"response": data}),
        headers: {'Content-Type': 'application/json'},
      );

  static error(APIError apiError) => Response.ok(
        json.encode({
          "error": {"code": apiError.code, "message": apiError.message},
        }),
        headers: {'Content-Type': 'application/json'},
      );
}
