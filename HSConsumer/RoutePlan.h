
#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@protocol RouteDelegate
-(void) showTransitRoute:(int)idx;
@end

@interface RoutePlan : UIView <UITableViewDelegate, UITableViewDataSource>

- (RoutePlan *)initWithData:(NSMutableArray *)result parentView:(UIView *)view delegate:(id)dele;

@end
