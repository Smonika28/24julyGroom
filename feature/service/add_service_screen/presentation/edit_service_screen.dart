import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/api/api_string.dart';
import '../../../../presentation/manage_services_container1_screen/manage_services_container1_screen.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/app_style.dart';
import '../../../../utils/Toast/app_toast.dart';
import '../../../../utils/color_constant.dart';
import '../../../../utils/size_utils.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../signup/bloc/seller_signup_bloc.dart';
import '../../manage_service/presentation/manage_services_container_page.dart';
import '../../service_details_screen/service_details_screen.dart';
import '../bloc/fetch_all_service_bloc.dart';
import 'package:http/http.dart' as http;
import '../bloc/fetch_all_service_bloc.dart';

class EditServiceScreen extends StatefulWidget {
  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  bool _isChecked = true;
  var jsonResponse;
  var resMsg;

  TextEditingController serviceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController serviceTypeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController offerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetchAllServiceBloc>(context).add(FetchAllServiceEvents());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String? selectedService;
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        appBar: CustomAppBar(
          title: "Edit Service",
        ),
        body: SizedBox(
          width: size.width,
          child: SingleChildScrollView(
            padding: getPadding(top: 7),
            child: Container(
              decoration: AppDecoration.fillGray200,
              child: Container(
                width: double.maxFinite,
                child: Container(
                  padding: getPadding(left: 29, top: 17, right: 29, bottom: 17),
                  decoration: AppDecoration.fillWhiteA700,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: getPadding(left: 23),
                            child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "Service",
                                      style: TextStyle(
                                          color: ColorConstant.gray700,
                                          fontSize: getFontSize(14),
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400)),
                                  TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                          color: ColorConstant.red500,
                                          fontSize: getFontSize(14),
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400))
                                ]),
                                textAlign: TextAlign.left)),
                        BlocBuilder<FetchAllServiceBloc, FetchAllServiceState>(
                          builder: (context, state) {
                            if (kDebugMode) {
                              print(state.toString());
                            }
                            if (state is FetchAllServiceLoadedState) {
                              return Container(
                                height: getVerticalSize(55),
                                width: getHorizontalSize(356),
                                margin: getMargin(top: 6),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        getHorizontalSize(27)),
                                    border: Border.all(
                                        color: ColorConstant.orangeA200,
                                        width: getHorizontalSize(1))),
                                child: CustomDropDown(
                                    onChanged: (v) {
                                      selectedService = v;
                                      print("selectedService $selectedService");
                                      // selectedService = service.name;
                                      // ServiceDetailsScreen({required this.serviceData});
                                    },
                                    items: state.allServiceModel),
                              );
                            }
                            return Shimmer.fromColors(
                              baseColor: Colors.transparent,
                              highlightColor: Colors.white.withOpacity(0.5),
                              child: Container(
                                color: const Color(0xFF244661),
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                              ),
                            );
                          },
                        ),
                        BlocConsumer<FetchAllFieldBloc, FetchAllFieldState>(
                          listener: (context, state) {
                            if (state is addServiceState) {
                              ToastMessage.toast(
                                  context: context,
                                  message: state.message.toString(),
                                  messageColor: Colors.white,
                                  background: Colors.green);

                              Future.delayed(const Duration(milliseconds: 1500),
                                  () => Navigator.pop(context));
                            }
                          },
                          builder: (context, state) {
                            print("fiedstate $state");
                            if (state is FetchAllServiceFieldLoading) {
                              return Shimmer.fromColors(
                                baseColor: Colors.transparent,
                                highlightColor: Colors.white.withOpacity(0.5),
                                child: Container(
                                  color: const Color(0xFF244661),
                                  width: MediaQuery.of(context).size.width,
                                ),
                              );
                            }
                            if (state
                                is FetchAllServiceDetailsFieldSetDoneState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: getPadding(
                                          left: 30, top: 9, bottom: 5),
                                      child: Text("Category Name",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtInterRegular14)),
                                  CustomTextFormField(
                                    hintText:
                                        "${state.detailServiceModel.data!.category!.name!}",
                                  ),
                                  Padding(
                                      padding: getPadding(
                                          left: 23, top: 9, bottom: 5),
                                      child: Text("Service Type",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtInterRegular14)),
                                  CustomTextFormField(
                                    hintText:
                                        "${state.detailServiceModel.data!.serviceType!.name!}",
                                  ),
                                  Padding(
                                      padding: getPadding(
                                          left: 23, top: 8, bottom: 5),
                                      child: Text("Duration",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtInterRegular14)),
                                  CustomTextFormField(
                                    hintText:
                                        "${state.detailServiceModel.data!.duration!}",
                                  ),
                                  Padding(
                                      padding: getPadding(
                                          left: 23, top: 9, bottom: 5),
                                      child: Text("Description",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtInterRegular14)),
                                  CustomTextFormField(
                                    hintText:
                                        "${state.detailServiceModel.data!.description!}",
                                  ),
                                  Padding(
                                    padding: getPadding(top: 8, right: 32),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                              Padding(
                                                  padding: getPadding(
                                                      left: 23, bottom: 5),
                                                  child: Text("Offer (%)",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtInterRegular14)),
                                              CustomTextFormField(
                                                // readOnly: true,
                                                hintText:
                                                    "${state.detailServiceModel.data!.offer!.offerAmount}",
                                              )
                                            ])),
                                        Checkbox(
                                          value: _isChecked,
                                          onChanged: (value) {
                                            setState(() {
                                              _isChecked = value!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  BlocListener<FetchAllFieldBloc,
                                      FetchAllFieldState>(
                                    listener: (context, state) {},
                                    child: CustomButton(
                                      onTap: () {
                                        BlocProvider.of<FetchAllFieldBloc>(
                                                context)
                                            .add(
                                                AddServiceEvent(
                                                    serviceID: state
                                                        .detailServiceModel
                                                        .data!
                                                        .id!,
                                                    offerId: state
                                                        .detailServiceModel
                                                        .data!
                                                        .offerId
                                                        .toString(),
                                                    offerPrice: int.parse(state
                                                        .detailServiceModel
                                                        .data!
                                                        .offer!
                                                        .offerAmount!)));
                                      },
                                      height: getVerticalSize(
                                        55,
                                      ),
                                      text: "UPDATE",
                                      margin: getMargin(
                                        left: 60,
                                        top: 40,
                                        right: 61,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: getPadding(top: 25, bottom: 31),
                                      child: SizedBox(
                                        width: getHorizontalSize(94),
                                        child: Divider(
                                            height: getVerticalSize(4),
                                            thickness: getVerticalSize(4),
                                            color: ColorConstant.gray9006c),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        )
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  onTapArrowleft2(BuildContext context) {
    Navigator.pop(context);
  }
}
