//
//  CALayer+Animations.m
//  CALayer
//
//  Created by Steven Koposov on 05/6/16.
//
//

#import "CALayer+Animations.h"

CGFloat const kLayerAnimationDuration = 0.5;

@implementation CALayer (Animations)

- (CABasicAnimation*)addAnimationOfScaleTo:(CGFloat)toScale
{
    CGFloat fromScale = self.transform.m11;

    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.removedOnCompletion = YES;
    animation.fromValue = @(fromScale);
    animation.toValue = @(toScale);
    animation.duration = kLayerAnimationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeRemoved;

    self.transform = CATransform3DMakeScale(toScale, toScale, 1.0);
    [self addAnimation:animation forKey:@"AnimationOfScale"];

    return animation;
}

- (CABasicAnimation*)addAnimationOfOpacityTo:(CGFloat)toOpacity
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.removedOnCompletion = YES;
    animation.fromValue = @(self.opacity);
    animation.toValue = @(toOpacity);
    animation.duration = kLayerAnimationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeRemoved;

    self.opacity = toOpacity;
    [self addAnimation:animation forKey:@"AnimationOfOpacity"];

    return animation;
}

- (CABasicAnimation*)addAnimationOfYPositionTo:(CGFloat)toY
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.removedOnCompletion = YES;
    animation.fromValue = @(self.position.y);
    animation.toValue = @(toY);
    animation.duration = kLayerAnimationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeForwards;

    self.position = CGPointMake(self.position.x, toY);
    [self addAnimation:animation forKey:@"AnimationOfYPosition"];

    return animation;
}

- (CATransition*)addCrossFadeAnimationTransition {
    CATransition* transition = [CATransition animation];
    transition.duration = kLayerAnimationDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self addAnimation:transition forKey:nil];
    return transition;
}

- (CAKeyframeAnimation *)addBounceAnimationHorizontalAmplitude:(CGFloat)horizontalAmplitude
{
    NSUInteger const kNumFactors = 22;
    CGFloat factors[kNumFactors] = {0,  60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 32, 0, 0, 18, 28, 32, 28, 18, 0};

    NSMutableArray *values = [NSMutableArray array];

    for (int i = 0; i < kNumFactors; i++)
    {
        CGFloat positionOffset = factors[i]/128.0f * horizontalAmplitude;

        CATransform3D transform = CATransform3DMakeTranslation(-positionOffset, 0, 0);
        [values addObject:[NSValue valueWithCATransform3D:transform]];
    }


    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.repeatCount = 1;
    animation.duration = kLayerAnimationDuration;
    animation.fillMode = kCAFillModeForwards;
    animation.values = values;
    animation.removedOnCompletion = YES; // final stage is equal to starting stage
    animation.autoreverses = NO;
    [self addAnimation:animation forKey:@"transform"];
    return animation;
}

- (CAKeyframeAnimation *)addBounceAnimationVerticalAmplitude:(CGFloat)verticalAmplitude
{
    NSUInteger const kNumFactors    = 22;
    CGFloat factors[kNumFactors] = {0,  60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 32, 0, 0, 18, 28, 32, 28, 18, 0};

    NSMutableArray *values = [NSMutableArray array];

    for (int i = 0; i < kNumFactors; i++)
    {
        CGFloat positionOffset = factors[i] / 128.0f * verticalAmplitude;

        CATransform3D transform = CATransform3DMakeTranslation(0, -positionOffset, 0);
        [values addObject:[NSValue valueWithCATransform3D:transform]];
    }

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.repeatCount = 1;
    animation.duration = kLayerAnimationDuration;
    animation.fillMode = kCAFillModeForwards;
    animation.values = values;
    animation.removedOnCompletion = YES; // final stage is equal to starting stage
    animation.autoreverses = NO;
    [self addAnimation:animation forKey:@"transform"];
    return animation;
}

- (CATransition *)addSlideToBottomAnimation {
    CATransition *transition = [CATransition animation];
    transition.duration = kLayerAnimationDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = [self transitionSubtype];
    [self addAnimation:transition forKey:@"slideToBottom"];
    return transition;
}

- (NSString *)transitionSubtype {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    NSString *transitionSubtype = nil;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            transitionSubtype = kCATransitionFromBottom;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            transitionSubtype = kCATransitionFromLeft;
            break;
        case UIInterfaceOrientationLandscapeRight:
            transitionSubtype = kCATransitionFromRight;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            transitionSubtype = kCATransitionFromTop;
            break;

        default:
            break;
    }
    return transitionSubtype;
}

@end
