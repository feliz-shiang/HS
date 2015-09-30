#import "Formatter.h"

@interface Formatter ()

@property (nonatomic, strong) NSDateFormatter *threadUnsafeDateFormatter;   // for date/time formatting

@end


@implementation Formatter

- (id)init {
    if (self = [super init]) {
        _threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
		[_threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [_threadUnsafeDateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    }
    
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *dateAndTime = [self.threadUnsafeDateFormatter stringFromDate:(logMessage->timestamp)];
    
    NSString *logLevel = nil;
    switch (logMessage->logFlag) {
        case LOG_FLAG_ERROR     : logLevel = @"E"; break;
        case LOG_FLAG_WARN      : logLevel = @"W"; break;
        case LOG_FLAG_INFO      : logLevel = @"I"; break;
        case LOG_FLAG_DEBUG     : logLevel = @"D"; break;
		case LOG_FLAG_VERBOSE   : logLevel = @"V"; break;
        default                 : logLevel = @"?"; break;
    }
    
    NSString *formattedLog = [NSString stringWithFormat:@"%@ |%@| [%@ %@] #%d: %@",
                              dateAndTime,
                              logLevel,
                              logMessage.fileName,
                              logMessage.methodName,
                              logMessage->lineNumber,
                              logMessage->logMsg];
    
    return formattedLog;
}

+ (Formatter *)shareInstance
{
    static Formatter* sFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sFormatter = [[super allocWithZone:NULL] init];
    });
    return sFormatter;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self shareInstance];
}

@end
