#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark Line Widths

/*! @const ILBorderlineWidth - default width of a border line */
extern CGFloat const ILBorderlineWidth;

/*! @const ILHairlineWidth - default width of a very thin line */
extern CGFloat const ILHairlineWidth;

/*! @const ILFinelineWidth - default width of a thin line */
extern CGFloat const ILFinelineWidth;

/*! @const ILBoldlineWidth - default width of a thick line */
extern CGFloat const ILBoldlineWidth;

#pragma mark - Geometry Functions

/*! @returns the largest square which can be centered in the rectangle provided */
CGRect ILCGRectSquareInRect(CGRect rect);

/*! @returns the center point of the rectangle provided */
CGPoint ILCGPointCenteredInRect(CGRect rect);

/*! @returns a CGVector describing the distance between the two points provided */
CGVector ILCGVectorFromPointToPoint(CGPoint from, CGPoint to);

/*! @returns the length of a CGVector */
CGFloat ILCGVectorLength(CGVector delta);

/*! @returns the angle of a vector in radians */
CGFloat ILCGVectorRadians(CGVector delta);

/*! @returns a CGPoint projected along the vector from one point to another at the provided distance */
CGPoint ILCGPointOnLineToPointAtDistance(CGPoint from, CGPoint to, CGFloat distance);

#pragma mark -

/*! @abstract a UIView which can have a rectangular or circular border */
@interface ILBorderedView : UIView

/*! @abstract YES if the border is drawn as the diameter of the largest circle which can be fit into it's bounds */
@property (nonatomic, assign) BOOL circularBorder;

/*! @abstract the color of the border, if not set the border path is not stroked */
@property (nonatomic, strong) UIColor* borderColor;

/*! @abstract the fill color of the borlder, if not se the border is not filled */
@property (nonatomic, strong) UIColor* borderFillColor;

/*! @abstract the stroke color of lines drawn inside of the border by a subclass */
@property (nonatomic, strong) UIColor* lineColor;

/*! @abstract the fill color of shapes drawn inside of the border by a subclass */
@property (nonatomic, strong) UIColor* fillColor;

/*! @abstract the width of the border line */
@property (nonatomic, assign) CGFloat lineWidth;

/*! @abstract the bezier path of the border */
@property (nonatomic, readonly) UIBezierPath* borderPath;

/*! @abstract the layer mask of the border */
@property (nonatomic, readonly) CAShapeLayer* borderMask;

#pragma mark - Subclass Overrides

/*! @abstract overriden by subclasses to initilize the view */
- (void) initView;

/*! @abstract overriden by subclasses to update the view */
- (void) updateView;

@end

NS_ASSUME_NONNULL_END
