//
//  Copyright © 2016 AutomaticLabs. All rights reserved.
//

#import <ALGaugeKit/ALGaugeKit.h>

#import "GaugesDataSource.h"
#import "GaugesTableViewCell.h"
#import "GaugesTableController.h"

#pragma mark -

@interface GaugesTableController ()
@property (nonatomic, retain) GaugesDataSource *gaugesDataSource;
@end

#pragma mark -

@implementation GaugesTableController

+ (NSArray<NSNumber *>*)gaugeStyles {
    static NSArray<NSNumber *>*styles = nil;
    if( !styles) {
        styles = @[
            @(ALLevelIndicatorStyleText),
            @(ALLevelIndicatorStyleVertical),
            @(ALLevelIndicatorStyleHorizontal),
            @(ALLevelIndicatorStyleSquare),
            @(ALLevelIndicatorStyleCircle),
            @(ALLevelIndicatorStyleRing),
            @(ALLevelIndicatorStylePie),
            @(ALLevelIndicatorStyleDial)
        ];
    }
    return styles;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.gaugesDataSource = [GaugesDataSource new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GaugesTableController gaugeStyles].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger gaugeIndex = [indexPath indexAtPosition:(indexPath.length-1)];
    NSInteger gaugeStyle = [[GaugesTableController gaugeStyles][gaugeIndex] integerValue];
    GaugesTableViewCell *cell = (GaugesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GaugeCell" forIndexPath:indexPath];
    cell.indicatorView.style = (ALLevelIndicatorStyle)gaugeStyle;
    cell.indicatorView.dataSource = self.gaugesDataSource;
    cell.indicatorView.borderColor = [UIColor grayColor];
    cell.timeseriesView.borderColor = [UIColor grayColor];
    cell.labelView.text = [NSString stringWithFormat:@"style: %li", gaugeIndex];
    [cell.indicatorView updateView];
    [cell.timeseriesView updateView];
    return cell;
}

@end
