@import Foundation;
@class MCMTileset, MCMLayer;

FOUNDATION_EXPORT NSString * const TMXMapVersionKey;
FOUNDATION_EXPORT NSString * const TMXMapOrientationKey;
FOUNDATION_EXPORT NSString * const TMXMapWidthKey;
FOUNDATION_EXPORT NSString * const TMXMapHeightKey;
FOUNDATION_EXPORT NSString * const TMXMapTileWidthKey;
FOUNDATION_EXPORT NSString * const TMXMapTileHeightKey;
FOUNDATION_EXPORT NSString * const TMXMapTilesetsKey;
FOUNDATION_EXPORT NSString * const TMXMapLayersKey;


@interface MCMMap : NSObject
@property NSString *version;
@property NSString *orientation; //Only supports "orthoganal" at the moment.
@property NSUInteger width, height;
@property CGFloat tileWidth, tileHeight;
@property NSColor *backgroundColor; //Unused.
@property NSArray *tilesets;
@property NSArray *layers;

+(instancetype)mapWithAttributes:(NSDictionary *)att;
-(void)addTileset:(MCMTileset *)aTileset;
-(void)addLayer:(MCMLayer *)aLayer;
-(NSDictionary *)serialize;
-(NSDictionary *)tileImages;
@end
