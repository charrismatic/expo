#import <EXAdsFacebook/EXNativeAdView.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import <EXCore/EXUtilitiesInterface.h>

@interface EXNativeAdView ()

@property (nonatomic, weak) EXModuleRegistry *moduleRegistry;

@end

@implementation EXNativeAdView

- (instancetype)initWithModuleRegistry:(EXModuleRegistry *)moduleRegistry
{
  if (self = [super init]) {
    _moduleRegistry = moduleRegistry;
  }
  return self;
}

- (void)setOnAdLoaded:(EXDirectEventBlock)onAdLoaded
{
  _onAdLoaded = onAdLoaded;
  
  if (_nativeAd != nil) {
    [self callOnAdLoadedWithAd:_nativeAd];
  }
}

- (void)setNativeAd:(FBNativeAd *)nativeAd
{
  _nativeAd = nativeAd;
  [self callOnAdLoadedWithAd:_nativeAd];
}

- (void)callOnAdLoadedWithAd:(FBNativeAd *)nativeAd
{
  if (_onAdLoaded != nil) {
    _onAdLoaded(@{
                  @"headline": nativeAd.headline,
                  @"linkDescription": nativeAd.linkDescription,
                  @"advertiserName": nativeAd.advertiserName,
                  @"socialContext": nativeAd.socialContext,
                  @"callToActionText": nativeAd.callToAction,
                  @"bodyText": nativeAd.bodyText,
                  // TODO: Remove this deprecated field (in lieu of adTranslation) in SDK 32+
                  @"translation": nativeAd.adTranslation,
                  @"adTranslation": nativeAd.adTranslation,
                  @"promotedTranslation": nativeAd.promotedTranslation,
                  @"sponsoredTranslation": nativeAd.sponsoredTranslation,
                  });
  }
}

- (void)registerViewsForInteraction:(FBMediaView *)mediaView adIcon:(FBAdIconView *)adIconView clickableViews:(NSArray<UIView *> *)clickable
{

  [_nativeAd registerViewForInteraction:self
                                  mediaView:mediaView
                                   iconView:adIconView
                             viewController:[[_moduleRegistry getModuleImplementingProtocol:@protocol(EXUtilitiesInterface)] currentViewController]
                             clickableViews:clickable];
}

@end