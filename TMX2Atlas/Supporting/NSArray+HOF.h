@import Foundation;

@interface NSArray (HOF)

-(NSArray *)map:(id (^)(id it))appliedBlock;
-(void)apply:(void (^)(id it))appliedBlock;
-(NSArray *)filter:(BOOL (^)(id it))predicateBlock;
-(id)findFirst:(BOOL(^)(id it))appliedBlock;
-(BOOL)allTrue:(BOOL (^)(id it))predicateBlock;
@end
