//
//  Copyright © 2016 AutomaticLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ALGaugeKit/ALGaugeKit.h>

@interface GaugesTableViewCell : UITableViewCell
@property (nonatomic, assign) IBOutlet ALIndicatorView *indicatorView;
@property (nonatomic, assign) IBOutlet ALTimeSeriesView *timeseriesView;
@property (nonatomic, assign) IBOutlet UILabel *labelView;

@end
