import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_btn_nav_bar_state.dart';

class ChangeBtnNavBarCubit extends Cubit<ChangeBtnNavBarState> {
  ChangeBtnNavBarCubit() : super(ChangeBtnNavBarInitial());

  int currentIndex = 0;

  void changeCurrentIndex(int index) {
    currentIndex = index;
    emit(BtnNavIndexChanged());
  }
}
