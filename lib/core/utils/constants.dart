import 'package:flutter/material.dart';
import 'package:highlight/languages/css.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/htmlbars.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/json.dart';
import 'package:highlight/languages/kotlin.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/swift.dart';
import 'package:highlight/languages/typescript.dart';
import 'package:highlight/languages/vue.dart';
import 'package:highlight/languages/xml.dart';
import 'package:highlight/languages/xquery.dart';
import 'package:highlight/languages/yaml.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/companies/data/models/company_size_model.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_enums.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_time_zone_model.dart';
import 'package:showwcase_v3/flavors.dart';

///MediaQuery Width
double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

///MediaQuery Height
double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
ThemeData theme(BuildContext context){
  return Theme.of(context);
}


double kMaxBorderRadius = 1000;
int defaultPageSize = 20;
const double defaultFontSize = 15;
const double  defaultLineHeight = 1.4;
const threadSymmetricPadding = 15.0;
const showSymmetricPadding = 15.0;
const kChatConnections = 'chat-connections-3';
const kChatMessages = 'chat-messages-3';
final kBetaMode = F.appFlavor == Flavor.beta;

// Just to keep track of the HiveAdapters created so far
const kChatConnectionModelHive = 1;
const kChatMessageModelHive = 2;
const kUserModelHive = 3;
const kChatAttachmentModelHive = 5;

/// Hero Tags
const kThreadContent = 'thread-content';
const kDefaultErrorText = "Check your connection";

const  profilePictureBucket = "showwcase-profile-pictures";
const projectBucket = "showwcase-project-data";

const kTestingMode = false;

/// External files
const kExternalShowwcaseBanner = "https://drive.google.com/file/d/1OnUX1-C24bvNSMqzretct5uUWfhL001A/view?usp=sharing";
const kSentryDNS = 'https://d63ed265b4bf4114a0277fe88c68be33@o4505606070140928.ingest.sentry.io/4505606071844864';

const anonymousPostUserImage = "https://www.showwcase.com/_next/static/media/anonymous.439383b7.png";
const anonymousPostUserId = -1000;

/// Image constants
// png / jpeg  jpg
const _imagePath = 'assets/img';
const kGoogleIcon = '$_imagePath/google_icon.png';
const kGithubIcon = '$_imagePath/github_icon.png';
const kLogoBlackPng = '$_imagePath/logo_black.png'; // used by splash screen
const kLogoWhitePng = '$_imagePath/logo_white.png'; // used by splash screen
const kWalkThroughImage1 = '$_imagePath/walkthrough_img_1.png';
const kWalkThroughImage2 = '$_imagePath/walkthrough_img_2.png';
const kWalkThroughImage3 = '$_imagePath/walkthrough_img_3.png';
const kWalkThroughImage4 = '$_imagePath/walkthrough_img_4.png';
const kWalkThroughImage5 = '$_imagePath/walkthrough_img_5.png';
const kImageNotFound = '$_imagePath/image_not_found.png';
const kTechStackPlaceHolderIcon = '$_imagePath/tech_stack_placeholder_icon.png';
const kShowsThumbnailPlaceHolder = '$_imagePath/showwcase_banner_placeholder.png';
const kASD9IconPng = '$_imagePath/asd9.png';

// svg
const _svgPath = 'assets/svg';
const kLogoSvg = '$_svgPath/logo.svg'; // used by app
const kCameraIconSvg = '$_svgPath/camera_icon.svg';
const kLocationIconSvg = '$_svgPath/location_icon.svg';
const kCalendarIconSvg = '$_svgPath/calendar_icon.svg';
const kNotificationIconSvg = '$_svgPath/notification_icon.svg';

const kUserIconSvg = '$_svgPath/user_icon.svg';
const kBookmarkIconSvg = '$_svgPath/bookmark.svg';
const kShareIconSvg = '$_svgPath/share.svg';
const kBookmarkFilledIconSvg = '$_svgPath/bookmark_filled.svg';
const kBookmarkOutlinedIconSvg = '$_svgPath/bookmark_alt.svg';
const kBoostIconSvg = '$_svgPath/arrow_circle_up.svg';
const kBoostOutlineIconSvg = '$_svgPath/boost_outline.svg';
const kCommentIconSvg = '$_svgPath/comment_icon.svg';
const kCommentFilledIconSvg = '$_svgPath/comment_filled.svg';
const kCommentOutlinedIconSvg = '$_svgPath/comment_outlined.svg';
const kLikeIconSvg = '$_svgPath/heart.svg';
const kMoreIconSvg = '$_svgPath/more_icon.svg';
const kLinkIconSvg = '$_svgPath/link_icon.svg';
const kCopyIconSvg = '$_svgPath/copy_icon.svg';
const kDashboardIconSvg = '$_svgPath/dashboard_icon.svg';
const kDetails = '$_svgPath/details.svg';
const kDeveloper = '$_svgPath/developers.svg';
const kHireDevelopers = '$_svgPath/hire_devs.svg';
const kConnectDevelopers = '$_svgPath/connect_developers.svg';
const kLookForWork = '$_svgPath/looking_for_work_path.svg';
const kUploadResume = '$_svgPath/upload_resume.svg';
const kPerson = '$_svgPath/person.svg';
const kFilterIcon = '$_svgPath/filter.svg';

const kStarIconSvg = '$_svgPath/star_icon.svg';
const kForkIconSvg = '$_svgPath/fork_icon.svg';
const kMembersIconSvg = '$_svgPath/members_icon.svg';
const kWorkIconSvg = '$_svgPath/briefcase.svg';
const kCirclesIconSvg = '$_svgPath/circles_icon.svg';
const kHomeIconSvg = '$_svgPath/home.svg';
const kHomeActiveIconSvg = '$_svgPath/home_active.svg';
const kShowsIconSvg = '$_svgPath/shows_icon.svg';
const kSearchIconSvg = '$_svgPath/search.svg';
const kAppleIconSvg = '$_svgPath/apple.svg';
const kCommunitiesIconSvg = '$_svgPath/communities.svg';
const kSeriesIconSvg = '$_svgPath/series_icon.svg';
const kSettingsIconSvg = '$_svgPath/settings.svg';
const kCircleIconSvg = '$_svgPath/circles.svg';

// create thread svgs
const kCircularAddIconSvg = '$_svgPath/circular_add.svg';
const kCodeIconSvg = '$_svgPath/code.svg';
const kGifIconSvg = '$_svgPath/gif.svg';
const kMentionIconSvg = '$_svgPath/mention.svg';
const kASD9IconSvg = '$_svgPath/asd9.svg';
const kPollIconSvg = '$_svgPath/poll.svg';
const kScheduleIconSvg = '$_svgPath/schedule.svg';
const kSendIconSvg = '$_svgPath/send_icon.svg';

// socials
const kFacebookIconSvg = '$_svgPath/socials/facebook.svg';
const kGithubIconSvg = '$_svgPath/socials/github.svg';
const kLinkedInIconSvg = '$_svgPath/socials/linkedIn.svg';
const kTwitterIconSvg = '$_svgPath/socials/twitter.svg';

// home feed filter icons
const kChatAlt2IconSvg = '$_svgPath/chat-alt-2.svg';
const kSparklesIconSvg = '$_svgPath/sparkles.svg';
const kSunIconSvg = '$_svgPath/sun.svg';
const kThumbUpIconSvg = '$_svgPath/thumb-up.svg';
const kTrendingUpIconSvg = '$_svgPath/trending-up.svg';

// json
const _jsonPath = 'assets/json';
// const kMobileIllustrationJson = '$_jsonPath/mobile_illustration.json'; // used by app
const kNoConnectionJson = '$_jsonPath/no_connection.json'; // used by app
const kEmptyContentJson = '$_jsonPath/empty.json'; // used by app
// const kCommentPostJson = '$_jsonPath/comment_post.json'; // used by app

//database name
const databaseName = 'showwcase.db';

const kOneSignalAppId = "98497c42-dee2-49ac-8ed9-b01d4d8ff592";


// general constants
const defaultCodeLanguage = 'javascript';
const codeTheme = customTheme;

/// Character `` ` ``.
const int $backquote = 0x60;

const customTheme = {
  'root': TextStyle(backgroundColor: Color(0xff232426), color: Color(0xffbababa)),
  'strong': TextStyle(color: Colors.deepOrangeAccent),
  'emphasis': TextStyle(color: kAppBlue, fontStyle: FontStyle.italic),
  'bullet': TextStyle(color: Color(0xff6896ba)),
  'quote': TextStyle(color: Color(0xff6896ba)),
  'link': TextStyle(color: Color(0xff6896ba)),
  'number': TextStyle(color: Color(0xff6896ba)),
  'regexp': TextStyle(color: Color(0xff6896ba)),
  'literal': TextStyle(color: Color(0xff6896ba)),
  'code': TextStyle(color: Color(0xffa6e22e)),
  'selector-class': TextStyle(color: Color(0xffa6e22e)),
  'keyword': TextStyle(color: Color(0xffcb7832)),
  'selector-tag': TextStyle(color: Color(0xffcb7832)),
  'section': TextStyle(color: Color(0xffcb7832)),
  'attribute': TextStyle(color: Color(0xffcb7832)),
  'name': TextStyle(color: Color(0xffcb7832)),
  'variable': TextStyle(color: Color(0xffcb7832)),
  'params': TextStyle(color: Color(0xffcb7832)),
  'string': TextStyle(color: Color(0xff6a8759)),
  'subst': TextStyle(color: Color(0xffe0c46c)),
  'type': TextStyle(color: Color(0xffe0c46c)),
  'built_in': TextStyle(color: Color(0xffe0c46c)),
  'builtin-name': TextStyle(color: Color(0xffe0c46c)),
  'symbol': TextStyle(color: Color(0xffe0c46c)),
  'selector-id': TextStyle(color: Color(0xffe0c46c)),
  'selector-attr': TextStyle(color: Color(0xffe0c46c)),
  'selector-pseudo': TextStyle(color: Color(0xffe0c46c)),
  'template-tag': TextStyle(color: Color(0xffe0c46c)),
  'template-variable': TextStyle(color: Color(0xffe0c46c)),
  'addition': TextStyle(color: Color(0xffe0c46c)),
  'comment': TextStyle(color: Colors.green),
  'deletion': TextStyle(color: Colors.deepOrangeAccent),
  'meta': TextStyle(color: Colors.deepOrangeAccent),
};


final profileTagIcons = [
  {"icon": 'assets/svg/profile_tags/globe-alt-icon.svg', "name": 'Globe'},
  {"icon": 'assets/svg/profile_tags/key-icon.svg', "name": 'Key'},
  {
    "icon": 'assets/svg/profile_tags/calculator-icon.svg',
    "name": 'Calculator'
  },
  {"icon": 'assets/svg/profile_tags/gift-icon.svg', "name": 'Gift'},
  {"icon": 'assets/svg/profile_tags/variable-icon.svg', "name": 'Variable'},
  {"icon": 'assets/svg/profile_tags/cloud-icon.svg', "name": 'Cloud'},
  {"icon": 'assets/svg/profile_tags/server-icon.svg', "name": 'Server'},
  {
    "icon": 'assets/svg/profile_tags/cube-icon.svg',
    "name": 'Cube Transparent'
  },
  {"icon": 'assets/svg/profile_tags/beaker-icon.svg', "name": 'Beaker'},
  {"icon": 'assets/svg/profile_tags/chip-icon.svg', "name": 'Chip'},
  {"icon": 'assets/svg/profile_tags/puzzle-icon.svg', "name": 'Puzzle'},
  {"icon": 'assets/svg/profile_tags/view-grid-icon.svg', "name": 'Grid View'},
  {"icon": 'assets/svg/profile_tags/terminal-icon.svg', "name": 'Terminal'},
  {"icon": 'assets/svg/profile_tags/star-icon.svg', "name": 'Star'},
  {
    "icon": 'assets/svg/profile_tags/microphone-icon.svg',
    "name": 'Microphone'
  },
  {"icon": 'assets/svg/profile_tags/briefcase-icon.svg', "name": 'Briefcase'},
  {
    "icon": 'assets/svg/profile_tags/dollar-icon.svg',
    "name": 'Currency Dollar'
  },
  {"icon": 'assets/svg/profile_tags/database-icon.svg', "name": 'Database'},
  {"icon": 'assets/svg/profile_tags/bolt-icon.svg', "name": 'Lightning Bolt'},
  {"icon": 'assets/svg/profile_tags/code-icon.svg', "name": 'Code'},
  {"icon": 'assets/svg/profile_tags/fire-icon.svg', "name": 'Fire'},
  {"icon": 'assets/svg/profile_tags/flag-icon.svg', "name": 'Flag'},
  {"icon": 'assets/svg/profile_tags/scale-icon.svg', "name": 'Scale'},
  {"icon": 'assets/svg/profile_tags/users-icon.svg', "name": 'Users'},
  {"icon": 'assets/svg/profile_tags/light-bulb-icon.svg', "name": 'Light Bulb'},
  {
    "icon": 'assets/svg/profile_tags/desktop-computer-icon.svg',
    "name": 'Desktop Computer'
  },
  {"icon": 'assets/svg/profile_tags/cap-icon.svg', "name": 'Academic Cap'},
  {"icon": 'assets/svg/profile_tags/hashtag-icon.svg', "name": 'Hashtag'},
  {"icon": 'assets/svg/profile_tags/lock-open-icon.svg', "name": 'Open Lock'},
  {
    "icon": 'assets/svg/profile_tags/finger-print-icon.svg',
    "name": 'Finger Print'
  },
  {
    "icon": 'assets/svg/profile_tags/user-group-icon.svg',
    "name": 'User Group'
  },
  {"icon": 'assets/svg/profile_tags/pencil-icon.svg', "name": 'Pencil'},
  {
    "icon": 'assets/svg/profile_tags/chart-square-bar-icon.svg',
    "name": 'Chart Square Bar'
  },
];

List<Map<String, dynamic>?> showType = [
  {
    'name': 'blog',
    'label': 'Blog',
    'color': const Color(0xff4ca9af), // Color(0xff99908C),
    'backgroundColor': const Color.fromRGBO(76, 169, 175, 0.1),
    'icon': 'assets/svg/show_icons/blog.svg'
  },
  {
    'name': 'hackathon',
    'label': 'Hackathon',
    'color': const Color(0xffe580f4), // Color(0xff99908C),
    'backgroundColor': const Color(0xfffdf2fe),
    'icon': 'assets/svg/show_icons/blog.svg'
  },
  {
    'name': 'podcast',
    'label': 'Podcast',
    'color': const Color(0xffD7A88E),
    'backgroundColor': const Color.fromRGBO(215, 144, 142, 0.1),
    'icon': 'assets/svg/show_icons/podcast.svg'
  },
  {
    'name': 'video',
    'label': 'Video',
    'color': const Color(0xff7A88C8),
    'backgroundColor': const Color.fromRGBO(122, 136, 200, 0.1),
    'icon': 'assets/svg/show_icons/video.svg'
  },
  {
    'name': 'product',
    'label': 'Product',
    'color': const Color(0xff8C7BB2),
    'backgroundColor': const Color.fromRGBO(140, 123, 179, 0.1),
    'icon': 'assets/svg/show_icons/product.svg'
  },
  {
    'name': 'git',
    'label': 'Repository',
    'color': const Color(0xffA1788B),
    'backgroundColor': const Color.fromRGBO(162, 120, 139, 0.1),
    'icon': 'assets/svg/show_icons/repo.svg'
  },
  {
    'name': 'event',
    'label': 'Event',
    'color': const Color(0xffC1BC35),
    'backgroundColor': const Color.fromRGBO(193, 188, 53, 0.1),
    'icon': 'assets/svg/schedule.svg'
  },
];


// supported code languages


final suggestedTags = [
  {
    'color': '#7090E8',
    'name': 'Software Engineering',
    'icon': 'Code',
  },
  {
    'color': '#9B51E0',
    'name': 'Github Star',
    'icon': 'Star',
  },
  {
    'color': '#5BACA3',
    'name': 'Creator',
    'icon': 'Hashtag',
  },
  {
    'color': '#56CCF2',
    'name': 'Open Source',
    'icon': 'Open Lock',
  },
  {
    'color': '#F2994A',
    'name': 'Machine Learning Engineer',
    'icon': 'Variable',
  },
  {
    'color': '#DE565B',
    'name': 'Blogger',
    'icon': 'Pencil',
  },
  {
    'color': '#DE565B',
    'name': 'Cloud Engineer',
    'icon': 'Cloud',
  },
  {
    'color': '#EFCA74',
    'name': 'Looking for new opportunities',
    'icon': 'Briefcase',
  },
  {
    'color': '#646DF6',
    'name': 'Founder',
    'icon': 'Light Bulb',
  },
  {
    'color': '#5BACA3',
    'name': 'Caught fire coding',
    'icon': 'Fire',
  },
  {
    'color': '#0070F3',
    'name': 'Crypto Enthusiast',
    'icon': 'Currency Dollar',
  },
  {
    'color': '#7090E8',
    'name': 'Podcast Host',
    'icon': 'Microphone',
  },
  {
    'color': '#9B51E0',
    'name': 'Cryptography',
    'icon': 'Key',
  },
  {
    'color': '#F2994A',
    'name': 'Data Scientist',
    'icon': 'Beaker',
  },
  {
    'color': '#5BACA3',
    'name': 'Blockchain Developer',
    'icon': 'Cube Transparent',
  },
  {
    'color': '#62BD7A',
    'name': 'Security Engineer',
    'icon': 'Finger Print',
  },
  {
    'color': '#62BD7A',
    'name': 'Google Cloud Platform Certified',
    'icon': 'Cloud',
  },
  {
    'color': '#886D2F',
    'name': 'AWS Certified',
    'icon': 'Server',
  },
  {
    'color': '#56CCF2',
    'name': 'Web Developer',
    'icon': 'Desktop Computer',
  },
  {
    'color': '#F2C94C',
    'name': 'Data Analyst',
    'icon': 'Chart Square Bar',
  },
  {
    'color': '#7090E8',
    'name': '6 years development experience',
    'icon': 'Terminal',
  },
  {
    'color': '#2D9CDB',
    'name': 'Open to collaborate',
    'icon': 'User Group',
  },
  {
    'color': '#DE565B',
    'name': 'Graduate Student',
    'icon': 'Academic Cap',
  },
  {
    'color': '#886D2F',
    'name': 'MySQL Expert',
    'icon': 'Database',
  },
  {
    'color': '#5BACA3',
    'name': 'React Developer',
    'icon': 'Code',
  },
];

final supportedLanguages = <String, dynamic>{
  'vue': vue,
  'graphql': javascript,
  'gn': javascript,
  'solidity': javascript,
  '1c': javascript,
  'abnf': javascript,
  'accesslog': javascript,
  'actionscript': javascript,
  'ada': javascript,
  'angelscript': javascript,
  'apache': javascript,
  'applescript': javascript,
  'arcade': javascript,
  'arduino': javascript,
  'armasm': javascript,
  'asciidoc': javascript,
  'aspectj': javascript,
  'autohotkey': javascript,
  'autoit': javascript,
  'avrasm': javascript,
  'awk': javascript,
  'axapta': javascript,
  'bash': javascript,
  'basic': javascript,
  'bnf': javascript,
  'brainfuck': javascript,
  'cal': javascript,
  'capnproto': javascript,
  'ceylon': javascript,
  'clean': javascript,
  'clojure-repl': javascript,
  'clojure': javascript,
  'cmake': javascript,
  'coffeescript': javascript,
  'coq': javascript,
  'cos': javascript,
  'cpp': javascript,
  'crmsh': javascript,
  'crystal': javascript,
  'cs': javascript,
  'csp': javascript,
  'css': css,
  'd': javascript,
  'dart': dart,
  'delphi': javascript,
  'diff': javascript,
  'django': javascript,
  'dns': javascript,
  'dockerfile': javascript,
  'dos': javascript,
  'dsconfig': javascript,
  'dts': javascript,
  'dust': javascript,
  'ebnf': javascript,
  'elixir': javascript,
  'elm': javascript,
  'erb': javascript,
  'erlang-repl': javascript,
  'erlang': javascript,
  'excel': javascript,
  'fix': javascript,
  'flix': javascript,
  'fortran': javascript,
  'fsharp': javascript,
  'gams': javascript,
  'gauss': javascript,
  'gcode': javascript,
  'gherkin': javascript,
  'glsl': javascript,
  'gml': javascript,
  'go': javascript,
  'golo': javascript,
  'gradle': javascript,
  'groovy': javascript,
  'haml': javascript,
  'handlebars': javascript,
  'haskell': javascript,
  'haxe': javascript,
  'hsp': javascript,
  'htmlbars': htmlbars,
  'http': javascript,
  'hy': javascript,
  'inform7': javascript,
  'ini': javascript,
  'irpf90': javascript,
  'isbl': javascript,
  'java': java,
  'javascript': javascript,
  'jboss-cli': javascript,
  'json': json,
  'julia-repl': javascript,
  'julia': javascript,
  'kotlin': kotlin,
  'lasso': javascript,
  'ldif': javascript,
  'leaf': javascript,
  'less': javascript,
  'lisp': javascript,
  'livecodeserver': javascript,
  'livescript': javascript,
  'llvm': javascript,
  'lsl': javascript,
  'lua': javascript,
  'makefile': javascript,
  'markdown': javascript,
  'mathematica': javascript,
  'matlab': javascript,
  'maxima': javascript,
  'mel': javascript,
  'mercury': javascript,
  'mipsasm': javascript,
  'mizar': javascript,
  'mojolicious': javascript,
  'monkey': javascript,
  'moonscript': javascript,
  'n1ql': javascript,
  'nginx': javascript,
  'nimrod': javascript,
  'nix': javascript,
  'nsis': javascript,
  'objectivec': javascript,
  'ocaml': javascript,
  'openscad': javascript,
  'oxygene': javascript,
  'parser3': javascript,
  'perl': javascript,
  'pf': javascript,
  'pgsql': javascript,
  'php': javascript,
  'plaintext': javascript,
  'pony': javascript,
  'powershell': javascript,
  'processing': javascript,
  'profile': javascript,
  'prolog': javascript,
  'properties': javascript,
  'protobuf': javascript,
  'puppet': javascript,
  'purebasic': javascript,
  'python': python,
  'q': javascript,
  'qml': javascript,
  'r': javascript,
  'reasonml': javascript,
  'rib': javascript,
  'roboconf': javascript,
  'routeros': javascript,
  'rsl': javascript,
  'ruby': javascript,
  'ruleslanguage': javascript,
  'rust': javascript,
  'sas': javascript,
  'scala': javascript,
  'scheme': javascript,
  'scilab': javascript,
  'scss': javascript,
  'shell': javascript,
  'smali': javascript,
  'smalltalk': javascript,
  'sml': javascript,
  'sqf': javascript,
  'sql': javascript,
  'stan': javascript,
  'stata': javascript,
  'step21': javascript,
  'stylus': javascript,
  'subunit': javascript,
  'swift': swift,
  'taggerscript': javascript,
  'tap': javascript,
  'tcl': javascript,
  'tex': javascript,
  'thrift': javascript,
  'tp': javascript,
  'twig': javascript,
  'typescript': typescript,
  'vala': javascript,
  'vbnet': javascript,
  'vbscript-html': javascript,
  'vbscript': javascript,
  'verilog': javascript,
  'vhdl': javascript,
  'vim': javascript,
  'x86asm': javascript,
  'xl': javascript,
  'xml': xml,
  'xquery': xquery,
  'yaml': yaml,
  'zephir': javascript,
  'react': javascript
};

final List<Map<String, dynamic>?> storeSocialLinksList = [
  { 'id': 1, 'name': 'personalWebsite', 'icon': 'website.svg', 'label': 'Website' },
  { 'id': 2, 'name': 'codepenProfile', 'icon': 'codepen.svg', 'label': 'Codepen' },
  { 'id': 3, 'name': 'githubProfile', 'icon': 'github.svg', 'label': 'GitHub' },
  { 'id': 4, 'name': 'dribbleProfile', 'icon': 'dribbble.svg', 'label': 'Dribbble' },
  { 'id': 5, 'name': 'linkedinProfile', 'icon': 'linkedin.svg', 'label': 'LinkedIn' },
  { 'id': 6, 'name': 'mediumProfile', 'icon': 'medium.svg', 'label': 'Medium' },
  { 'id': 7, 'name': 'gitlabProfile', 'icon': 'gitlab.svg', 'label': 'GitLab' },
  { 'id': 8, 'name': 'twitterProfile', 'icon': 'twitter.svg', 'label': 'Twitter' },
  { 'id': 9, 'name': 'tableauProfile', 'icon': 'tableau.svg', 'label': 'Tableau' },
  {'id': 10, 'name': 'stackoverflowProfile', 'icon': 'stackoverflow.svg', 'label': 'StackOverflow',},
  {'id': 11, 'name': 'codesandboxProfile', 'icon': 'codesandbox.svg', 'label': 'CodeSandbox',},
  { 'id': 12, 'name': 'replitProfile', 'icon': 'replit.svg', 'label': 'Repl.it' },
  { 'id': 13, 'name': 'behanceProfile', 'icon': 'behance.svg', 'label': 'Behance' },
  { 'id': 14, 'name': 'hashnodeProfile', 'icon': 'hashnode.svg', 'label': 'Hashnode' },
  { 'id': 15, 'name': 'devToProfile', 'icon': 'devto.svg', 'label': 'Dev.to' },
  {'id': 16, 'name': 'instagramProfile', 'icon': 'instagram.svg', 'label': 'Instagram',},
  {"id": 17, "name": "youtubeProfile", "label": "Youtube", "icon": "youtube.svg",},
  {"id": 18, "name": "facebookProfile", "label": "Facebook", "icon": "facebook.svg",},

];

final List<Map<String, dynamic>> experienceOptions = [
  {
    'label': 'Beginner',
    'description': 'I do not have a professional experience in this skill.',
    'value': 1,
  },
  {
    'label': 'Junior',
    'description': 'I have used this skill professionally in a limited capacity.',
    'value': 2,
  },
  {
    'label': 'Mid-level',
    'description':
    'I have used this skill professionally at length but not at a level where I teach.',
    'value': 4,
  },
  {
    'label': 'Senior',
    'description':
    'I have used this skill professionally at length and can teach others about this skill.',
    'value': 7,
  },
  {
    'label': 'Expert',
    'description':
    'I have deep understanding, used it professionally for years, and can build almost anything with it.',
    'value': 10,
  },
];


final List<Map<String, dynamic>> notificationTabItems = [
  <String, dynamic>{
    'index': 0,
    'text': "All",
    "value": "all",
    'category': NotificationCategory.all,
    'type': <String>[]
  },
  <String, dynamic>{
    'index': 1,
    'text': 'Mentions',
    "value": "mentions",
    'category': NotificationCategory.mentions,
    'type': <String>['thread_mention']
  },
  <String, dynamic>{
    'index': 2,
    'text': 'Requests',
    'value': 'requests',
    'category': NotificationCategory.requests,
    'type': <String>[
      'new_workedwith_invite',
      'new_project_workedwith_invite',
      'community_invite',
    ],
  },
  <String, dynamic>{
    'index': 3,
    'text': 'Community',
    'value': 'community',
    'category': NotificationCategory.community,
    'type': <String>[
      'new_community_member',
      'community_role_changed',
      'community_invite',
      'community_ownership_transfer',
      'new_thread',
      'new_reply',
      'thread_mention',
      'new_thread_upvote',
      'new_poll_vote',
      'community_approved',
    ],
  },
];


const showwcaseBadges = [
  {
    "badge": 'founding_creator',
    "title": 'Founding Creator Badge',
    "description": 'Founding Creators are dev writers, content creators, experienced coders, seasoned technology vets, engineering leaders, and architects that help shape the Showwcase roadmap and share their knowledge in the network',
    "icon": "https://assets.showwcase.com/badges/founding_creator_badge.svg",
  },
  {
    "badge": 'community_lead',
    "title": 'Community Lead Badge',
    "description":
    'Community Leads are here to drive the community forward, help members be successful on Showwcase, and create a healthy developer environment.',
    "icon": "https://assets.showwcase.com/badges/community_lead_badge.svg",
  },
  {
    "badge": '21_days_challenge',
    "title": '21DOU',
    "description": 'Developers who have successfully completed the 21 Days of Coding challenge will be awarded with this badge.',
    "icon": "https://assets.showwcase.com/badges/twentyOne_days_challenge.png",
  },
  {
    "badge": 'dev_elevate_bronze',
    "title": 'Dev Elevate 2022 Bronze',
    "description":
    'Developers who have successfully completed Dev Elevate 2022 and awarded with the Bronze badge.',
    "icon": "https://assets.showwcase.com/badges/bronze.png",
  },
  {
    "badge": 'dev_elevate_silver',
    "title": 'Dev Elevate 2022 Silver',
    "description": 'Developers who have successfully completed Dev Elevate 2022 and awarded with the Silver badge.',
    "icon": "https://assets.showwcase.com/badges/silver.png",
  },
  {
    "badge": 'dev_elevate_gold',
    "title": 'Dev Elevate 2022 Gold',
    "description": 'Developers who have successfully completed Dev Elevate 2022 and awarded with the Gold badge.',
    "icon": "https://assets.showwcase.com/badges/gold.png"
  },
  {
    "badge": 'dev_elevate_platinum',
    "title": 'Dev Elevate 2022 Platinum',
    "description":
    'Developers who have successfully completed Dev Elevate 2022 and awarded with the Platinum badge.',
    "icon": "https://assets.showwcase.com/badges/platinum.png",
  },
  {
    "badge": 'dev_elevate_champion',
    "title": 'Dev Elevate 2022 Champion',
    "description": 'Developers who have successfully completed Dev Elevate 2022 and awarded with the Champion badge.',
    "icon": "https://assets.showwcase.com/badges/champions.png",
  },
];

const List<Map<String, dynamic>> techStackExperiences = [
  {
      'value': 1,
      'title': 'Beginner',
      'desc': 'I do not have a professional experience in this skill.'
  },
  {
    'value': 2,
    'title': 'Junior',
    'desc': 'I have used this skill professionally in a limited capacity.'
  },
  {
    'value': 4,
    'title': 'Mid level',
    'desc': 'I have used this skill professionally at length but not at a level where I teach.'
  },
  {
    'value': 7,
    'title': 'Senior',
    'desc': 'I have used this skill professionally at length and can teach others about this skill.'
  },
  {
    'value': 10,
    'title': 'Expert',
    'desc': 'I do not have a professional experience in this skill.'
  },
];

const monthsList = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

final List<CompanySizeModel> companySizes = [
  const CompanySizeModel(
    label: "Small startups",
    value: '1-10',
  ),
  const CompanySizeModel(
    label: "Growing team",
    value: '11-25',
  ),
  const CompanySizeModel(
    label: "Medium Startups",
    value: '26-50',
  ),
  const CompanySizeModel(
    label: "Big Startups",
    value: '51-250',
  ),
  const CompanySizeModel(
    label: "Large companies",
    value: '251+',
  ),

];

final List<SharedTimeZoneModel> timeZones = [
  const SharedTimeZoneModel(
      label: "(GMT -12:00) Eniwetok, Kwajalein",
      value: "-12:00"
  ),
  const SharedTimeZoneModel(
      label:  "(GMT -11:00) Midway Island, Samoa",
      value: "-11:00"
  ),

  const SharedTimeZoneModel(
      label: "(GMT -10:00) Hawaii",
      value: "-10:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT -9:30) Taiohae",
      value: "-9:30"
  ),
  const SharedTimeZoneModel(
      label: "(GMT -9:00) Alaska",
      value: "-9:00"
  ),
  const SharedTimeZoneModel(
      label:  "(GMT -8:00) Pacific Time (US &amp; Canada)",
      value: "-8:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT -6:00) Central Time (US &amp; Canada), Mexico City",
      value: "-6:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT -5:00) Eastern Time (US &amp; Canada), Bogota, Lima",
      value: "-5:00"
  ),
  const SharedTimeZoneModel(
      label:  "(GMT -4:30) Caracas",
      value: "-4:30"
  ),
  const SharedTimeZoneModel(
      label:  "(GMT -4:00) Atlantic Time (Canada), Caracas, La Paz",
      value: "-4:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT -3:30) Newfoundland",
      value: "-3:30"
  ),
  const SharedTimeZoneModel(
      label: "(GMT -3:00) Brazil, Buenos Aires, Georgetown",
      value: "-3:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT -2:00) Mid-Atlantic",
      value: "-2:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT -1:00) Azores, Cape Verde Islands",
      value: "-1:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT) Western Europe Time, London, Lisbon, Casablanca",
      value: "0:00"
  ),
  const SharedTimeZoneModel(
      label:  "(GMT +1:00) Brussels, Copenhagen, Madrid, Paris",
      value: "+1:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +2:00) Kaliningrad, South Africa",
      value: "+2:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +3:00) Baghdad, Riyadh, Moscow, St. Petersburg",
      value: "+3:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +3:30) Tehran",
      value: "+3:30"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +4:00) Abu Dhabi, Muscat, Baku, Tbilisi",
      value: "+4:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +4:30) Kabul",
      value: "+4:30"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +5:00) Ekaterinburg, Islamabad, Karachi, Tashkent",
      value: "+5:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +5:30) Bombay, Calcutta, Madras, New Delhi",
      value: "+5:30"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +5:45) Kathmandu, Pokhara",
      value: "+5:45"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +6:00) Almaty, Dhaka, Colombo",
      value: "+6:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +6:30) Yangon, Mandalay",
      value: "+6:30"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +8:00) Beijing, Perth, Singapore, Hong Kong",
      value: "+8:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +7:00) Bangkok, Hanoi, Jakarta",
      value: "+7:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +8:45) Eucla",
      value: "+8:45"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +9:00) Tokyo, Seoul, Osaka, Sapporo, Yakutsk",
      value: "+9:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +9:30) Adelaide, Darwin",
      value: "+9:30"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +10:00) Eastern Australia, Guam, Vladivostok",
      value: "+10:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +10:30) Lord Howe Island",
      value: "+10:30"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +11:00) Magadan, Solomon Islands, New Caledonia",
      value: "+11:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +11:30) Norfolk Island",
      value: "+11:30"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +12:00) Auckland, Wellington, Fiji, Kamchatka",
      value: "+12:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +12:45) Chatham Islands",
      value: "+12:45"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +13:00) Apia, Nukualofa",
      value: "+13:00"
  ),
  const SharedTimeZoneModel(
      label: "(GMT +14:00) Line Islands, Tokelau",
      value: "+14:00"
  )
];



// const languages = [
//   { label: 'JavaScript', value: 'javascript' },
//   { label: 'C', value: 'c' },
//   { label: 'C++', value: 'cpp' },
//   { label: 'C#', value: 'csharp' },
//   { label: 'Java', value: 'java' },
//   { label: 'Python', value: 'python' },
//   { label: 'Go', value: 'go' },
//   { label: 'Ruby', value: 'ruby' },
//   { label: 'Rust', value: 'rust' },
//   { label: 'TypeScript', value: 'typescript' },
//   { label: 'Bash', value: 'bash' },
//   { label: 'SQL', value: 'sql' },
//   { label: 'React', value: 'jsx' },
//   { label: 'HTML', value: 'handlebars' },
//   { label: 'Dart', value: 'dart' },
//   { label: 'CSS', value: 'css' },
//   { label: 'JSON', value: 'json' },
//   { label: 'Solidity', value: 'solidity' },
//   { label: 'PHP', value: 'php' },
// ];