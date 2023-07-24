import 'package:bloc/bloc.dart';
import 'package:groomely_seller/core/api/api_string.dart';
import 'package:groomely_seller/feature/dashboard_screen/model/dhashview_model.dart';
import 'package:groomely_seller/utils/APi/api_provider.dart';
import 'package:meta/meta.dart';
part 'home_view_event.dart';
part 'home_view_state.dart';

class HomeViewBloc extends Bloc<HomeViewEvent, HomeViewState> {
  HomeViewBloc() : super(HomeViewInitial()) {
    HomeViewModel homeViewModel = HomeViewModel();
    ApiProvider apiProvider = ApiProvider();
     on<FetchHomeViewEvents>((event, emit) async {
      try {
        emit(HomeViewLoadingState());
        // final myList = await repository.getLogin(requestModel);
        final myData = await apiProvider
              .dataProcessor({},homeViewModel, Apis.homePage);
            // .dataProcessor({},homeViewModel, Apis.getUser);
        print("my data--> $myData");
        if (myData != null && myData.status == true) {
          // String userName = myList.data.user.first_name+ myList.data.user.last_name;
          print("loaded--> ${myData.toJson()}");
          emit(HomeViewLoadedState(homeViewModel: myData));
        } else {
          emit(HomeViewErrorState(errorMsg: myData.toString()));
        }
      } catch (e) {
        emit(HomeViewErrorState(errorMsg: e.toString()));
      }
    });
  }
}
