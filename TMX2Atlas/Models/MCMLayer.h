@import Foundation;

FOUNDATION_EXPORT NSString * const TMXLayerNameKey;
FOUNDATION_EXPORT NSString * const TMXLayerIsVisibleKey;
FOUNDATION_EXPORT NSString * const TMXLayerOpacityKey;
FOUNDATION_EXPORT NSString * const TMXLayerTilesKey;


@interface MCMLayer : NSObject
@property NSString *name;
@property (getter = isVisible) BOOL visible;
@property CGFloat opacity;
@property NSArray *tiles;
-(NSArray *)fullTiles;
+(instancetype)layerWithAttributes:(NSDictionary *)att;
-(void)addTile:(NSInteger)tileID;
-(NSDictionary *)serialize;
@end
