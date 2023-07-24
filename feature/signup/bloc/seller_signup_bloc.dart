import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:groomely_seller/feature/signup/model/request_model.dart';
import 'package:groomely_seller/feature/signup/model/seller_signup_res_model.dart';
import 'package:groomely_seller/utils/APi/api_calling.dart';
import 'package:groomely_seller/utils/storage/local_storage.dart';

import '../../../core/api/api_string.dart';
import '../../../utils/APi/api_provider.dart';

part 'seller_signup_event.dart';

part 'seller_signup_state.dart';

class SellerSignupBloc extends Bloc<SellerSignupEvent, SellerSignupState> {
  SellerSignupBloc() : super(SellerSignupStateInitial()) {
    SellerSignupModel sellerSignupModel = SellerSignupModel();
    ApiCallingClass apiCallingClass = ApiCallingClass();
    // ApiProvider apiProvider = ApiProvider();

    on<SellerSignupSubmittedEvent>((event, emit) async {

      SellerSignupRequestModel requestModel = SellerSignupRequestModel(
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          phone: event.phone,
          zipcode: event.zipcode,
          password: event.password,
          confirmPassword: event.confirmPassword,
          userType: "BUSINESS_OWNER");


      try {
        emit(SellerSignupStateLoading());
         final mData = await apiCallingClass.signUpApiCall(requestModel);
        if (mData.token != null && mData.token != "") {
          print('seller signup  Response ---------------------- ${mData}');
          LocalStorageService()
              .saveToDisk(LocalStorageService.ACCESS_TOKEN_KEY, mData.token.toString());
          emit(SellerSignupStateLoaded(mData));
        }
        else {
          emit(SellerSignupStateFailed(mData.message.toString()));
        }
      } catch (e) {
        emit(SellerSignupStateFailed(e.toString()));
      }


    }
    );
  }
}
