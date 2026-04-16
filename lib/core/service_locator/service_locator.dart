import 'package:e_commerce/core/service_locator/theme_service_locator/theme_service_locator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../extensions/extensions.dart';
import 'package:get_it/get_it.dart';
import '../../main.dart';
import '../helpers/helpers.dart';
import '../http/http.dart';

part 'init/init.dart';
part 'auth_service_locator/auth_service_locator.dart';
part 'shared_service_locator/shared_service_locator.dart';
part 'hive_service_locator/hive_service_locator.dart';
part 'home_service_locator/home_service_locator.dart';
