// ignore_for_file: constant_identifier_names

part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
  LOGIN,
  REGISTER,
  FORGETPASS,
  VERIFICATION,
  ADDHABIT,
  HABITDETAIL,
  TIMER,
  ADDTASK,
  TASKDETAIL,
  SETTINGS,
  PROFILE,
  EDITPROFILE,
  TASKHISTORY,
  STATISTICS,
}

class AppState extends Equatable {
  final AppStatus status;
  final User user;

  const AppState._({
    required this.status,
    this.user = User.empty,
  });

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  @override
  List<Object> get props => [status, user];
}

  

// class AppStateAuthenticated extends AppState {
//   const AppStateAuthenticated({required User user})
//       : super(status: AppStatus.authenticated, user: user);
// }

// class AppStateUnauthenticated extends AppState {
//   const AppStateUnauthenticated() : super(status: AppStatus.unauthenticated);
// }

// const AppState.authenticated(User user)
  //     : this._(
  //         status: AppStatus.authenticated,
  //         user: user,
  //       );

  // const AppState.unauthenticated()
  //     : this._(
  //         status: AppStatus.unauthenticated,
  //       );