import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/data/repositories/validation_repository.dart';
import 'package:freegency_gp/core/shared/widgets/custom_text_field.dart';

part 'validation_state.dart';

enum PasswordRequirement {
  EIGHT_CHARS,
  UPPERCASE,
  LOWERCASE,
  DIGIT,
  SPECIAL_CHAR
}

class ValidationCubit extends Cubit<ValidationState> {
  final ValidationRepository _validationRepository;
  final GlobalKey<FormState> myForm = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController teamCategoryController = TextEditingController();
  final TextEditingController teamCodeController = TextEditingController();

  final Map<PasswordRequirement, bool> passwordChecklist = {
    PasswordRequirement.EIGHT_CHARS: false,
    PasswordRequirement.UPPERCASE: false,
    PasswordRequirement.LOWERCASE: false,
    PasswordRequirement.DIGIT: false,
    PasswordRequirement.SPECIAL_CHAR: false,
  };

  ValidationCubit({ValidationRepository? validationRepository})
      : _validationRepository = validationRepository ?? ValidationRepository(),
        super(ValidatioInitial());

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

  void onPasswordChanged(String password) {
    passwordChecklist[PasswordRequirement.EIGHT_CHARS] = password.length >= 8;
    passwordChecklist[PasswordRequirement.UPPERCASE] =
        password.contains(RegExp(r'[A-Z]'));
    passwordChecklist[PasswordRequirement.LOWERCASE] =
        password.contains(RegExp(r'[a-z]'));
    passwordChecklist[PasswordRequirement.DIGIT] =
        password.contains(RegExp(r'[0-9]'));
    passwordChecklist[PasswordRequirement.SPECIAL_CHAR] =
        password.contains(RegExp(r'[@$!%*?&]'));

    emit(PasswordChecklistUpdated(Map.from(passwordChecklist)));
  }

  String? validator(String? value, TextFieldValidation validationType) {
    switch (validationType) {
      case TextFieldValidation.EMAIL:
        return _validationRepository.validateEmail(value);
      case TextFieldValidation.PASSWORD:
        return _validationRepository.validatePassword(value);
      case TextFieldValidation.NONE:
        return null;
    }
  }

  bool validateForm() {
    final isValid = myForm.currentState?.validate() ?? false;
    if (isValid) {
      emit(ValidationSuccessState());
    } else {
      emit(ValidatioErrorState());
    }
    return isValid;
  }
}
