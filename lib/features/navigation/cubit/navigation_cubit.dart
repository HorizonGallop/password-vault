import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationChanged(1)); // يبدأ من Home

  void changeTab(int index) {
    emit(NavigationChanged(index));
  }
}
