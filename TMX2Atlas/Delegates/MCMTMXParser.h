@import Foundation;
@class MCMMap;

@interface MCMTMXParser : NSObject <NSXMLParserDelegate>
-(id)initWithURL:(NSURL *)aURL;
-(MCMMap *)parse;
@end
