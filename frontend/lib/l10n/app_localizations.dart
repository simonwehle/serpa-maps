import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// Shown after a user accepted a group invitation
  ///
  /// In en, this message translates to:
  /// **'Accepted invite to {group}'**
  String acceptGroupInvite(String group);

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addGroup.
  ///
  /// In en, this message translates to:
  /// **'Add Group'**
  String get addGroup;

  /// No description provided for @addAssetConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Asset added'**
  String get addAssetConfirmation;

  /// Shown after a category is successfully added
  ///
  /// In en, this message translates to:
  /// **'Category {name} added'**
  String addCategoryConfirmation(String name);

  /// Shown after a place is successfully added
  ///
  /// In en, this message translates to:
  /// **'Place {name} added'**
  String addPlaceConfirmation(String name);

  /// No description provided for @addPlaceToGroup.
  ///
  /// In en, this message translates to:
  /// **'Add place to group'**
  String get addPlaceToGroup;

  /// No description provided for @anonymousUser.
  ///
  /// In en, this message translates to:
  /// **'Anonymous User'**
  String get anonymousUser;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @categoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Category not found'**
  String get categoryNotFound;

  /// Shown after a group is successfully created
  ///
  /// In en, this message translates to:
  /// **'Group {name} created'**
  String createGroupConfirmation(String name);

  /// No description provided for @darkMapStyleURL.
  ///
  /// In en, this message translates to:
  /// **'Dark map style URL'**
  String get darkMapStyleURL;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Shown after a user declined a group invite
  ///
  /// In en, this message translates to:
  /// **'Declined invite to {group}'**
  String declineGroupInvite(String group);

  /// No description provided for @defaultMap.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultMap;

  /// No description provided for @deleteAsset.
  ///
  /// In en, this message translates to:
  /// **'Delete Asset'**
  String get deleteAsset;

  /// No description provided for @deleteAssetConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Asset deleted'**
  String get deleteAssetConfirmation;

  /// No description provided for @deleteAssetQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this asset?'**
  String get deleteAssetQuestion;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategory;

  /// Shown after a category is successfully deleted
  ///
  /// In en, this message translates to:
  /// **'Category {name} deleted'**
  String deleteCategoryConfirmation(String name);

  /// No description provided for @deleteCategoryQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this category?'**
  String get deleteCategoryQuestion;

  /// No description provided for @deleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get deleteGroup;

  /// Shown after a group is successfully deleted
  ///
  /// In en, this message translates to:
  /// **'Group {name} deleted'**
  String deleteGroupConfirmation(String name);

  /// No description provided for @deleteGroupQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this group?'**
  String get deleteGroupQuestion;

  /// No description provided for @deletePlace.
  ///
  /// In en, this message translates to:
  /// **'Delete Place'**
  String get deletePlace;

  /// Shown after a place is successfully deleted
  ///
  /// In en, this message translates to:
  /// **'Place {name} deleted'**
  String deletePlaceConfirmation(String name);

  /// No description provided for @deletePlaceQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this place?'**
  String get deletePlaceQuestion;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @inviteGroupMember.
  ///
  /// In en, this message translates to:
  /// **'Invite group member'**
  String get inviteGroupMember;

  /// Shown after user is invited to a group
  ///
  /// In en, this message translates to:
  /// **'Invited {user} to group {group}'**
  String inviteGroupMemberConfirmation(String user, String group);

  /// No description provided for @invites.
  ///
  /// In en, this message translates to:
  /// **'Invites'**
  String get invites;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @leaveGroup.
  ///
  /// In en, this message translates to:
  /// **'Leave group'**
  String get leaveGroup;

  /// Shown after user left a group successfully deleted
  ///
  /// In en, this message translates to:
  /// **'Left group {name}'**
  String leaveGroupConfirmation(String name);

  /// No description provided for @leaveGroupQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to leave this group?'**
  String get leaveGroupQuestion;

  /// No description provided for @lessOptions.
  ///
  /// In en, this message translates to:
  /// **'less options'**
  String get lessOptions;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Shown after a user successfully logged in
  ///
  /// In en, this message translates to:
  /// **'Logged in as {user}'**
  String loginConfirmation(String user);

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Shown after a user successfully logged out
  ///
  /// In en, this message translates to:
  /// **'Logged out'**
  String get logoutConfirmation;

  /// No description provided for @logoutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout?'**
  String get logoutQuestion;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @mapLayer.
  ///
  /// In en, this message translates to:
  /// **'Map Layer'**
  String get mapLayer;

  /// No description provided for @mapStyleURL.
  ///
  /// In en, this message translates to:
  /// **'Map style URL'**
  String get mapStyleURL;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'more options'**
  String get moreOptions;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategory;

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategories;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available'**
  String get noDescription;

  /// No description provided for @noGroups.
  ///
  /// In en, this message translates to:
  /// **'No groups available. Create one with the + Button'**
  String get noGroups;

  /// No description provided for @noGroupInvites.
  ///
  /// In en, this message translates to:
  /// **'No group invites available'**
  String get noGroupInvites;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'(optional)'**
  String get optional;

  /// No description provided for @overlayURL.
  ///
  /// In en, this message translates to:
  /// **'Overlay URL'**
  String get overlayURL;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @photonURL.
  ///
  /// In en, this message translates to:
  /// **'Photon URL'**
  String get photonURL;

  /// No description provided for @placeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Place not found'**
  String get placeNotFound;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Shown after a user successfully registered
  ///
  /// In en, this message translates to:
  /// **'Registered user {user}'**
  String registerConfirmation(String user);

  /// No description provided for @removeGroupMember.
  ///
  /// In en, this message translates to:
  /// **'Remove group member'**
  String get removeGroupMember;

  /// Shown after a group member is successfully removed
  ///
  /// In en, this message translates to:
  /// **'Removed {user} from group {group}'**
  String removeGroupMemberConfirmation(String user, String group);

  /// No description provided for @removeGroupMemberQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove this group member?'**
  String get removeGroupMemberQuestion;

  /// No description provided for @satellite.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get satellite;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @searchPlaces.
  ///
  /// In en, this message translates to:
  /// **'Search places'**
  String get searchPlaces;

  /// No description provided for @serverURL.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverURL;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @sharedWith.
  ///
  /// In en, this message translates to:
  /// **'Shared with: '**
  String get sharedWith;

  /// No description provided for @showMarkers.
  ///
  /// In en, this message translates to:
  /// **'Show markers'**
  String get showMarkers;

  /// No description provided for @showOverlay.
  ///
  /// In en, this message translates to:
  /// **'Show overlay'**
  String get showOverlay;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Shown after a category is successfully updated
  ///
  /// In en, this message translates to:
  /// **'Category {name} updated'**
  String updateCategoryConfirmation(String name);

  /// Shown after a group member role was updated
  ///
  /// In en, this message translates to:
  /// **'Updated {user}\'s role to {role}'**
  String updateGroupMemberRole(String user, String role);

  /// Shown after a place is successfully updated
  ///
  /// In en, this message translates to:
  /// **'Place {name} updated'**
  String updatePlaceConfirmation(String name);

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
