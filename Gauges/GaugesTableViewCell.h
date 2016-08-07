#import <UIKit/UIKit.h>
#import <GaugeKit/GaugeKit.h>

@interface GaugesTableViewCell : UITableViewCell
@property (nonatomic, assign) IBOutlet ILIndicatorView *indicatorView;
@property (nonatomic, assign) IBOutlet ILTimeSeriesView *timeseriesView;
@property (nonatomic, assign) IBOutlet UILabel *labelView;

@end
