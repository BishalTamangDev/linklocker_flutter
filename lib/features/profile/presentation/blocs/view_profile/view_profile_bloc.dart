import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'view_profile_event.dart';
part 'view_profile_state.dart';

class ViewProfileBloc extends Bloc<ViewProfileEvent, ViewProfileState> {
  ViewProfileBloc() : super(ViewProfileInitial()) {
    on<ViewProfileEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
