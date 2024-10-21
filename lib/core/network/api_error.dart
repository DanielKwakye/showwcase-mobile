import 'dart:convert';

import 'package:dio/dio.dart';

import 'api_error_model.dart';

class ApiError {
  late String errorDescription;
  ApiErrorModel? apiErrorModel;
  int? errorCode;

  ApiError({required this.errorDescription, this.errorCode});

  ApiError.fromDio(Object dioError) {
    _handleError(dioError);
  }

  void _handleError(Object error) {
    if (error is DioException) {
      var dioError = error;
      switch (dioError.type) {
        case DioExceptionType.cancel:
          errorDescription = "Request was cancelled";
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription = "Receive timeout in connection";
          break;
        case DioExceptionType.unknown:
          _setErrorDescription(dioError);
          break;
        case DioExceptionType.sendTimeout:
          errorDescription = "Send timeout in connection";
          break;
        case DioExceptionType.connectionTimeout:
          errorDescription = "Connection timeout";
          break;
        case DioExceptionType.badCertificate:
          errorDescription = "Bad certificate";
          break;
        case DioExceptionType.badResponse:
          // errorDescription = "Bad response";
          _setErrorDescription(dioError);
          break;
        case DioExceptionType.connectionError:
          errorDescription = "Unable to connect";
          break;
      }
    } else {
      errorDescription = "An unexpected error occurred";
    }
  }

  void _setErrorDescription(DioException dioError) {
    if(dioError.response == null) {
      errorDescription = "Please check your connection";
    }else {
      if (dioError.response!.statusCode == 401) {
        errorDescription = 'Session timeout';
      } else if (dioError.response!.statusCode == 400 || dioError.response!.statusCode! <= 409) {
        errorDescription = extractDescriptionFromResponse(dioError.response);
      }else if(dioError.response!.statusCode == 500){
        errorDescription = 'A Server Error Occurred';
      } else {
        errorDescription = 'Something went wrong, please check your internet connection..';
      }
    }
  }

  String extractDescriptionFromResponse(Response? response) {
    var message = '';

    var decodeResponse = response!.data;
    try {
      if (response.data != null ) {
        if(decodeResponse is String ){
          message = decodeResponse;
        }
        else if(decodeResponse is Map<String, dynamic>){
          if(decodeResponse.containsKey("error")) {
            message = decodeResponse['error'];
          }
          else if(decodeResponse.containsKey("errors")){
            final errors = decodeResponse['errors'];
            Map<String, dynamic>? decodedErrors;
            if(errors is String){
              decodedErrors = json.decode(errors);
            }else if(errors is Map<String, dynamic>){
              decodedErrors = errors;
            }
            if(decodedErrors != null && decodedErrors.isNotEmpty){
              message = decodedErrors.entries.first.value.toString();
            }
          }
          else if(decodeResponse.containsKey("message")){
            message = decodeResponse['message'];
          }else {
            message = response.statusMessage ?? '';
          }

        }

      } else {
        message = response.statusMessage ?? '';
      }
    } catch (error) {
      message = response.statusMessage ?? error.toString();
    }
    return message;
  }

  @override
  String toString() => errorDescription;
}
