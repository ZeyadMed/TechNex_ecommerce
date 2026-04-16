import 'dart:convert';
import 'dart:developer';
import 'package:go_router/go_router.dart';
import 'package:e_commerce/core/enum/snack_bar_enum.dart';
import 'package:e_commerce/core/router/app_router.dart';
import '../extensions/extensions.dart';
import '../../main.dart';
import '../helpers/helpers.dart';
import '../local_storage/local_storage.dart';
import '../service_locator/service_locator.dart';
import 'either.dart';
import 'failure.dart';
import 'package:dio/dio.dart';

part 'api_consumer.dart';
part 'base_api_consumer.dart';
part 'endpoints.dart';
