import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groomely_seller/feature/dashboard_screen/bloc/home_view_bloc.dart';
import 'package:groomely_seller/widgets/custom_appbar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:groomely_seller/core/app_export.dart';
import '../../../../../feature/dashboard_screen/widgets/dashboard_item_widget.dart';
import '../../notification/presentation/notification.dart';

class BookServiceCardScreen extends StatefulWidget {
  @override
  State<BookServiceCardScreen> createState() => _BookServiceCardScreen();
}

class _BookServiceCardScreen extends State<BookServiceCardScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeViewBloc>(context).add(FetchHomeViewEvents());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: CustomAppBar(
              title: 'Booking List',
            )),
        body: SingleChildScrollView(
          padding: getPadding(
            top: 7,
          ),
          child: BlocBuilder<HomeViewBloc, HomeViewState>(
            builder: (context, state) {
              if (state is HomeViewErrorState) {
                return Center(child: Text(state.errorMsg));
              } else if (state is HomeViewLoadingState) {
                return Shimmer.fromColors(
                  baseColor: Colors.transparent,
                  highlightColor: Colors.white.withOpacity(0.3),
                  child: Container(
                    color: const Color(0xFF244661),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                );
              } else if (state is HomeViewLoadedState) {
                var active_services = state.homeViewModel.data!.activeServices;
                var todayBooking = "";
                return Column(
                  children: [
                    Container(
                      margin: getMargin(
                        bottom: 95,
                      ),
                      padding: getPadding(
                        top: 20,
                        bottom: 20,
                      ),
                      decoration: AppDecoration.fillWhiteA700,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: getPadding(
                              left: 13,
                              right: 13,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today’s Bookings",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtInterBold20,
                                ),
                                Padding(
                                  padding: getPadding(
                                    top: 1,
                                    bottom: 6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: getVerticalSize(
                              280,
                            ),
                            child:
                                state.homeViewModel.data!.todaysBooking != null
                                    ? ListView.separated(
                                        padding: getPadding(
                                          left: 15,
                                          top: 21,
                                          bottom: 2,
                                        ),
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (
                                          context,
                                          index,
                                        ) {
                                          return SizedBox(
                                            height: getVerticalSize(
                                              13,
                                            ),
                                          );
                                        },
                                        itemCount: 10,
                                        itemBuilder: (context, index) {
                                          return DashboardItemWidget();
                                        },
                                      )
                                    :
                                Align(
                                        alignment: Alignment.center,
                                        child: Text("No Booking")),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
