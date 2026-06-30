// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String acceptGroupInvite(String group) {
    return 'Accepted invite to $group';
  }

  @override
  String get add => 'Add';

  @override
  String get addGroup => 'Add Group';

  @override
  String get addAssetConfirmation => 'Asset added';

  @override
  String addCategoryConfirmation(String name) {
    return 'Category $name added';
  }

  @override
  String addPlaceConfirmation(String name) {
    return 'Place $name added';
  }

  @override
  String get addPlaceToGroup => 'Add place to group';

  @override
  String get anonymousUser => 'Anonymous User';

  @override
  String get appearance => 'Appearance';

  @override
  String get cancel => 'Cancel';

  @override
  String get categories => 'Categories';

  @override
  String get categoryNotFound => 'Category not found';

  @override
  String createGroupConfirmation(String name) {
    return 'Group $name created';
  }

  @override
  String get darkMapStyleURL => 'Dark map style URL';

  @override
  String get dark => 'Dark';

  @override
  String declineGroupInvite(String group) {
    return 'Declined invite to $group';
  }

  @override
  String get defaultMap => 'Default';

  @override
  String get deleteAsset => 'Delete Asset';

  @override
  String get deleteAssetConfirmation => 'Asset deleted';

  @override
  String get deleteAssetQuestion => 'Do you want to delete this asset?';

  @override
  String get deleteCategory => 'Delete Category';

  @override
  String deleteCategoryConfirmation(String name) {
    return 'Category $name deleted';
  }

  @override
  String get deleteCategoryQuestion => 'Do you want to delete this category?';

  @override
  String get deleteGroup => 'Delete Group';

  @override
  String deleteGroupConfirmation(String name) {
    return 'Group $name deleted';
  }

  @override
  String get deleteGroupQuestion => 'Do you want to delete this group?';

  @override
  String get deletePlace => 'Delete Place';

  @override
  String deletePlaceConfirmation(String name) {
    return 'Place $name deleted';
  }

  @override
  String get deletePlaceQuestion => 'Do you want to delete this place?';

  @override
  String get description => 'Description';

  @override
  String get directions => 'Directions';

  @override
  String get email => 'Email';

  @override
  String get error => 'Error';

  @override
  String get explore => 'Explore';

  @override
  String get groups => 'Groups';

  @override
  String get inviteGroupMember => 'Invite group member';

  @override
  String inviteGroupMemberConfirmation(String user, String group) {
    return 'Invited $user to group $group';
  }

  @override
  String get invites => 'Invites';

  @override
  String get latitude => 'Latitude';

  @override
  String get leaveGroup => 'Leave group';

  @override
  String leaveGroupConfirmation(String name) {
    return 'Left group $name';
  }

  @override
  String get leaveGroupQuestion => 'Do you want to leave this group?';

  @override
  String get lessOptions => 'less options';

  @override
  String get light => 'Light';

  @override
  String get loading => 'Loading...';

  @override
  String get login => 'Login';

  @override
  String loginConfirmation(String user) {
    return 'Logged in as $user';
  }

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Logged out';

  @override
  String get logoutQuestion => 'Do you want to logout?';

  @override
  String get longitude => 'Longitude';

  @override
  String get mapLayer => 'Map Layer';

  @override
  String get mapStyleURL => 'Map style URL';

  @override
  String get moreOptions => 'more options';

  @override
  String get name => 'Name';

  @override
  String get newCategory => 'New Category';

  @override
  String get noCategories => 'No categories available';

  @override
  String get noDescription => 'No description available';

  @override
  String get noGroups => 'No groups available. Create one with the + Button';

  @override
  String get noGroupInvites => 'No group invites available';

  @override
  String get optional => '(optional)';

  @override
  String get overlayURL => 'Overlay URL';

  @override
  String get password => 'Password';

  @override
  String get photonURL => 'Photon URL';

  @override
  String get placeNotFound => 'Place not found';

  @override
  String get register => 'Register';

  @override
  String registerConfirmation(String user) {
    return 'Registered user $user';
  }

  @override
  String get removeGroupMember => 'Remove group member';

  @override
  String removeGroupMemberConfirmation(String user, String group) {
    return 'Removed $user from group $group';
  }

  @override
  String get removeGroupMemberQuestion =>
      'Do you want to remove this group member?';

  @override
  String get satellite => 'Satellite';

  @override
  String get save => 'Save';

  @override
  String get searchPlaces => 'Search places';

  @override
  String get serverURL => 'Server URL';

  @override
  String get settings => 'Settings';

  @override
  String get sharedWith => 'Shared with: ';

  @override
  String get showMarkers => 'Show markers';

  @override
  String get showOverlay => 'Show overlay';

  @override
  String get system => 'System';

  @override
  String updateCategoryConfirmation(String name) {
    return 'Category $name updated';
  }

  @override
  String updateGroupMemberRole(String user, String role) {
    return 'Updated $user\'s role to $role';
  }

  @override
  String updatePlaceConfirmation(String name) {
    return 'Place $name updated';
  }

  @override
  String get username => 'Username';

  @override
  String get yes => 'Yes';
}
