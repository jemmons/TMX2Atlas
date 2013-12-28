@import Foundation;


@interface MCMLayer : NSObject
@property NSString *name;
@property (getter = isVisible) BOOL visible;
@property CGFloat opacity;
@property NSArray *tiles;
-(NSArray *)fullTiles;
+(instancetype)layerWithAttributes:(NSDictionary *)att;
-(void)addTile:(NSInteger)tileID;
@end
