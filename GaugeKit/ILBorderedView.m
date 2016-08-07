#import "ILBorderedView.h"

NS_ASSUME_NONNULL_BEGIN

CGFloat const ILBorderlineWidth = 1.0f;
CGFloat const ILHairlineWidth = 0.5f;
CGFloat const ILFinelineWidth = 0.8f;
CGFloat const ILBoldlineWidth = 1.6f;

CGRect ILCGRectSquareInRect(CGRect rect) {
    CGFloat sideLength = (CGFloat)fmin(rect.size.width,rect.size.height);
    CGFloat xOffset = (rect.size.width-sideLength)/2;
    CGFloat yOffset = (rect.size.height-sideLength)/2;
    return CGRectIntegral(CGRectMake(xOffset,yOffset,sideLength,sideLength));
}

CGPoint ILCGPointCenteredInRect(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGVector ILCGVectorFromPointToPoint(CGPoint from, CGPoint to) {
    return CGVectorMake(from.x-to.x,from.y-to.y);
}

CGFloat ILCGVectorLength(CGVector delta) {
    return (CGFloat)sqrt(fabs(delta.dx*delta.dx) + fabs(delta.dy*delta.dy));
}

CGFloat ILCGVectorRadians(CGVector delta) {
    return (CGFloat)atan2(delta.dx, delta.dy);
}

CGPoint ILCGPointOnLineToPointAtDistance(CGPoint from, CGPoint to, CGFloat distance) {
    CGVector lineVector = ILCGVectorFromPointToPoint(from, to);
    CGFloat lineDistance = ILCGVectorLength(lineVector);
    CGVector scaledVector = CGVectorMake(lineVector.dx/lineDistance, lineVector.dy/lineDistance);
    CGVector segmentVector = CGVectorMake( scaledVector.dx*distance, scaledVector.dy*distance);
    return CGPointMake(from.x-segmentVector.dx, from.y-segmentVector.dy);
}

#pragma mark - Private

@interface ILBorderedView ()
@property (nonatomic, readonly) CAShapeLayer* borderLayer;
@end

#pragma mark -

@implementation ILBorderedView

#pragma mark - UIView

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

- (void)layoutSubviews {
    self.borderLayer.frame = self.frame;
//    NSLog(@"<%@ %p layoutSubviews frame: %@ layer frame: %@ layer bounds: %@>",
//        self.class, self, NSStringFromCGRect(self.frame), NSStringFromCGRect(self.borderLayer.frame), NSStringFromCGRect(self.borderLayer.bounds));
}

#pragma mark - ILBorderedView

- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    self.circularBorder = NO;
    self.lineWidth = ILBorderlineWidth;
    self.borderFillColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    self.borderColor = [UIColor blackColor];
    self.fillColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.lineColor = [UIColor whiteColor];
}

- (void)updateView {
    self.borderLayer.path = self.borderPath.CGPath;
    self.borderLayer.fillColor = self.borderFillColor.CGColor;
    self.borderLayer.strokeColor = self.borderColor.CGColor;
    self.borderLayer.lineWidth = ILHairlineWidth;
}

- (CAShapeLayer *)borderLayer {
    return (CAShapeLayer *)self.layer;
}

- (UIBezierPath*)borderPath {
    UIBezierPath *borderPath = nil;
    if (self.circularBorder) {
        borderPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(ILCGRectSquareInRect(self.bounds),ILBorderlineWidth,ILBorderlineWidth)];
    }
    else {
        borderPath = [UIBezierPath bezierPathWithRect:self.bounds];
    }
    return borderPath;
}

- (CAShapeLayer *)borderMask {
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.path = self.borderPath.CGPath;
    mask.frame = self.bounds;
    return mask;
}

@end

NS_ASSUME_NONNULL_END
