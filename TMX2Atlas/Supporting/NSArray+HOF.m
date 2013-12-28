#import "NSArray+HOF.h"

@implementation NSArray (HOF)

//Create a new array by applying a transform to the elements of an existing one.
-(NSArray *)map:(id (^)(id it))appliedBlock{
  __block NSMutableArray *map = [NSMutableArray arrayWithCapacity:[self count]];
  
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    id x = appliedBlock(obj);
    if(x){
      [map addObject:x];
    }
  }];

  return map;
}


//Applies the block to each element of the array. Similar to «map», but doesn't create a new array.
-(void)apply:(void (^)(id it))appliedBlock{
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    appliedBlock(obj);
  }];
}



//Create a new array containing elements of an existing one for which the given predicate is true.
-(NSArray *)filter:(BOOL (^)(id it))predicateBlock{
  __block NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];

  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if(predicateBlock(obj)){
      [result addObject:obj];
    }
  }];

  return result;
}


//Return the first element of an existing array for which the predicate is true.
-(id)findFirst:(BOOL (^)(id it))predicateBlock{
  __block id found = nil;
  
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if(predicateBlock(obj)){
      found = obj;
      *stop = YES;
    }
  }];
  
  return found;
}


//Returns true if the given predicate returns true for all elements. Else false.
-(BOOL)allTrue:(BOOL (^)(id it))predicateBlock{
  __block BOOL allTrue = YES;
  
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if( ! predicateBlock(obj)){
      allTrue = NO;
      *stop = YES;
    }
  }];
  
  return allTrue;
}

@end
