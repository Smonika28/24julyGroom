



import 'package:equatable/equatable.dart';

import '../model/edit_password_response_model.dart';

abstract class EditPasswordState extends Equatable {
  const EditPasswordState();

  @override
  List<Object> get props => [];
}

class EditPasswordStateInitial extends EditPasswordState {}

class EditPasswordStateLoading extends EditPasswordState {}

class EditPasswordStateLoaded extends EditPasswordState {
  final EditPasswordResponseModel editPasswordResponseModel;

  EditPasswordStateLoaded(this.editPasswordResponseModel);

  @override
  List<Object> get props => [editPasswordResponseModel];
}

class EditPasswordStateFailed extends EditPasswordState {
  final String errorMessage;

  EditPasswordStateFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}