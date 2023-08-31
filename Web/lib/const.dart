

class AppConst{
  static const String appName="Veris";
  static const String status="Hi there I'm using $appName";
  static const List<String> menuData=["New Group","Archived Chat","Settings","Logout"];
}


class UserConst{
  static const String studentMessage="Login on mobile version.";
  static const String disabledMessage="Your Veris account has been disabled.";
  static const String student="student";
  static const String admin="admin";
  static const String superAdmin="superAdmin";
  static List<String> superAdminTypes= ["student","admin","superAdmin"];
  static List<String> adminTypes= ["student"];
}

class ErrorConst{
  static const String noUsersFoundYet="No Users Found Yet";
}

class ChatConst{
  static const String groupChat="groupChat";
  static const String privateChat="privateChat";
}

class FriendConst{
  static const String friendRequestSent="friendRequestSent";
  static const String friendRequestAccepted="friendRequestAccepted";
  static const String friendRequestRejected="friendRequestRejected";
}

class PageConst{
  static const String registrationPage="registrationPage";
  static const String loginPage="loginPage";
  static const String forgotPage="forgotPage";
  static const String phoneRegistrationPage="phoneRegistrationPage";
  static const String settingsPage="settingsPage";
  static const String allUserPage="allUserPage";
}