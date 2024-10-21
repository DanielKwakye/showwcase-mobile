#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "LaunchBackground" asset catalog image resource.
static NSString * const ACImageNameLaunchBackground AC_SWIFT_PRIVATE = @"LaunchBackground";

/// The "LaunchBackgroundBeta" asset catalog image resource.
static NSString * const ACImageNameLaunchBackgroundBeta AC_SWIFT_PRIVATE = @"LaunchBackgroundBeta";

/// The "LaunchBackgroundProduction" asset catalog image resource.
static NSString * const ACImageNameLaunchBackgroundProduction AC_SWIFT_PRIVATE = @"LaunchBackgroundProduction";

/// The "LaunchImage" asset catalog image resource.
static NSString * const ACImageNameLaunchImage AC_SWIFT_PRIVATE = @"LaunchImage";

/// The "LaunchImageBeta" asset catalog image resource.
static NSString * const ACImageNameLaunchImageBeta AC_SWIFT_PRIVATE = @"LaunchImageBeta";

/// The "LaunchImageProduction" asset catalog image resource.
static NSString * const ACImageNameLaunchImageProduction AC_SWIFT_PRIVATE = @"LaunchImageProduction";

/// The "betaLaunchImage" asset catalog image resource.
static NSString * const ACImageNameBetaLaunchImage AC_SWIFT_PRIVATE = @"betaLaunchImage";

/// The "liveLaunchImage" asset catalog image resource.
static NSString * const ACImageNameLiveLaunchImage AC_SWIFT_PRIVATE = @"liveLaunchImage";

/// The "productionLaunchImage" asset catalog image resource.
static NSString * const ACImageNameProductionLaunchImage AC_SWIFT_PRIVATE = @"productionLaunchImage";

#undef AC_SWIFT_PRIVATE