//
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

#import "ALTimeSeriesView.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Private

@interface ALTimeSeriesView ()
@property (nonatomic, strong) CAShapeLayer *timeSeries;
@end

#pragma mark -

@implementation ALTimeSeriesView

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.timeSeries.frame = self.bounds;
//    NSLog(@"<%@ %p layoutSubviews series frame: %@ series bounds: %@>",
//        self.class, self, NSStringFromCGRect(self.timeSeries.frame), NSStringFromCGRect(self.timeSeries.bounds));
}

#pragma mark - ALBorderView

- (void)initView {
    [super initView];
    self.fillColor = [UIColor clearColor];
    self.dataSource = nil;
    self.timeSeries = [CAShapeLayer new];
    [self.layer addSublayer:self.timeSeries];
}

- (void)updateView {
    [super updateView];

    UIBezierPath *seriesPath = [UIBezierPath bezierPath];
    seriesPath.lineWidth = self.lineWidth;

    NSTimeInterval visibleInterval = ((self.bounds.size.width * 1.1) / self.timeScale);
    NSDate *now = [NSDate date];
    NSDate *then = [NSDate dateWithTimeInterval:-visibleInterval sinceDate:now];
    NSDate *lastSample = nil;
    NSArray* visibleSamples = nil;

    // try the single lookup version first, then ranged, then filer the array ourselves
    if ([self.dataSource respondsToSelector:@selector(sampleDatesAfter:)]) {
        visibleSamples = [self.dataSource sampleDatesAfter:then];
    }
    else if ([self.dataSource respondsToSelector:@selector(sampleDatesBetween:and:)]) {
        visibleSamples = [self.dataSource sampleDatesBetween:then and:now];
    }
    else {
        visibleSamples = [self.dataSource.sampleDates filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:
        ^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return (fabs([(NSDate*)evaluatedObject timeIntervalSinceDate:now]) < visibleInterval);
        }]];
    }

    // NSLog(@"<%@ %p updateView %lu samples %lu visible between %@ and %@>",
    //     self.class, self, self.dataSource.sampleDates.count, visibleSamples.count, then, now);

    // we have a list of visible samples, draw then into our view's frame
    for (NSDate *sampleDate in visibleSamples) {
        CGFloat samplePercentage = [self.dataSource sampleAtDate:sampleDate];
        CGRect graphFrame = self.timeSeries.bounds;
        CGFloat sampleX = [self horizontalPositionOfDate:sampleDate];
        CGFloat sampleY = (graphFrame.size.height - (graphFrame.size.height * samplePercentage));
        CGPoint samplePoint = CGPointMake(sampleX,sampleY);
        if( !lastSample) {
            CGPoint seriesOrigin = CGPointMake(sampleX,(CGFloat)fmin(sampleY,graphFrame.size.width));
            [seriesPath moveToPoint:seriesOrigin];
        }
        
        [seriesPath addLineToPoint:samplePoint];
        lastSample = sampleDate;
    }

    // NSLog(@"updateView path bounds: %@ series bounds: %@ series frame: %@",
    //     NSStringFromCGRect(seriesPath.bounds), NSStringFromCGRect(self.timeSeries.bounds), NSStringFromCGRect(self.timeSeries.bounds));

    self.timeSeries.path = seriesPath.CGPath;
    self.timeSeries.fillColor = self.fillColor.CGColor;
    self.timeSeries.strokeColor = self.lineColor.CGColor;
    self.timeSeries.lineWidth = self.lineWidth;
    self.timeSeries.mask = self.borderMask;
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> frame: %@ fill: %@ border: %@ line: %@ x %f",
        self.class, self, NSStringFromCGRect(self.frame), self.fillColor, self.borderColor, self.lineColor, self.lineWidth];
}

@end

NS_ASSUME_NONNULL_END
