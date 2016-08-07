#import "ILTimelineView.h"

NS_ASSUME_NONNULL_BEGIN

static CGFloat const ILTimelineDefaultScale = 0.5f;
static NSTimeInterval const ILTimelineZeroOffset = 0.0f;

#pragma mark -

@implementation ILTimelineView

- (NSDate *)earliestVisibleDate {
    CGFloat widthInPixels = self.frame.size.width;
    NSTimeInterval visibleInterval = (widthInPixels / ILTimelineDefaultScale);
    NSDate *earliest = [NSDate dateWithTimeInterval:-visibleInterval sinceDate:self.mostRecentVisibleDate];
    return earliest;
}

- (NSDate *)mostRecentVisibleDate {
    return [NSDate dateWithTimeInterval:self.timeOffset sinceDate:[NSDate date]];
}

- (CGFloat)horizontalPositionOfDate:(NSDate *)timelineDate {
    NSTimeInterval elapsed = [timelineDate timeIntervalSinceDate:self.mostRecentVisibleDate];
    return (self.bounds.size.width - ((CGFloat)fabs(elapsed) * self.timeScale));
}

#pragma mark - ILBorderedView

- (void)initView {
    [super initView];

    /* pinching the view adjusts the time scale */
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self addGestureRecognizer:pinchGesture];

    /* swiping the view adjust the time offset */
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight & UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeGesture];

    /* tapping the view resets the scale and offset to their defaults */
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    [self handleTap:tapGesture];
}

#pragma mark - UIGestureRecognizer

-(void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    // adjust the timeScale
    NSLog(@"%@ handlePinch: %@ -> %f", self.class, pinch, self.timeScale);
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    // adjust the timeOffset
    NSLog(@"%@ handleSwipe: %@ -> %f", self.class, swipe, self.timeOffset);
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    self.timeScale = ILTimelineDefaultScale;
    self.timeOffset = ILTimelineZeroOffset;
    NSLog(@"%@ handleTap: %@", self.class, tap);
}

@end

NS_ASSUME_NONNULL_END
