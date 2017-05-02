//
//  CALayer+Animations.h
//  CALayer
//
//  Created by Steven Koposov on 05/6/16.
//
//

#import <QuartzCore/QuartzCore.h>

FOUNDATION_EXPORT CGFloat const kWMLayerAnimationDuration;

@interface CALayer (Animations)
- (CABasicAnimation*)addAnimationOfScaleTo:(CGFloat)toScale;
- (CABasicAnimation*)addAnimationOfOpacityTo:(CGFloat)toOpacity;
- (CABasicAnimation*)addAnimationOfYPositionTo:(CGFloat)toY;
- (CATransition*)addCrossFadeAnimationTransition;
- (CAKeyframeAnimation *)addBounceAnimationHorizontalAmplitude:(CGFloat)horizontalAmplitude;
- (CAKeyframeAnimation *)addBounceAnimationVerticalAmplitude:(CGFloat)verticalAmplitude;
- (CATransition *)addSlideToBottomAnimation;


@end
