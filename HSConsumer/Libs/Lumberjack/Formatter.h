
#import "DDDispatchQueueLogFormatter.h"
#import "DDTTYLogger.h"
#import "CocoaLumberjack.h"

#define kLogFormatter [Formatter shareInstance]
@interface Formatter : DDDispatchQueueLogFormatter<DDLogFormatter>

+ (Formatter *)shareInstance;

@end
