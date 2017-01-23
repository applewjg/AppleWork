#import <Foundation/Foundation.h>

@interface Person:NSObject {
	NSString* name;
}
@property (nonatomic,retain) NSString* name;
@end
 
@implementation Person
@synthesize name = _name; 
@end

@interface PersonMe:Person {
	NSUInteger age;
}
@property (nonatomic,assign) NSUInteger age;
- (void) setName:(NSString*) yourName andAge:(NSUInteger) yourAge;
@end

@implementation PersonMe
@synthesize age = _age;
- (void) setName:(NSString*) yourName andAge:(NSUInteger) yourAge {
	_age = yourAge;
	[super setName:yourName];
}
@end

int main(int argc, char* argv[]) {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	PersonMe* me = [[PersonMe alloc] init];
	[me setName:@"asdf" andAge:18];
	NSLog(@"name: %@, age: %lu", me.name, me.age);
	me.age = 19;
	me.name = @"gaga";
	NSLog(@"name: %@, age: %lu", me.name, me.age);
	
	NSString *str = [NSString stringWithFormat:@"%s,%d", "test_str",6];
	NSLog(@"str:%@  retainCount:%lu",str, [str retainCount]); // 1
    me.name = str;  
    NSLog(@"name: %@, age: %lu", me.name, me.age);
    NSLog(@"string_Point:%p  %@  retainCount:%lu", me.name, me.name, [me.name retainCount]); 
    
    NSString *s1 = [NSString stringWithString:@"test"];
	NSString *s2 = [NSString stringWithString:[NSString stringWithFormat:@"test,%d",1]];

	NSLog(@"s1:%lu",[s1 retainCount]); // 2147483647
	NSLog(@"s2:%lu",[s2 retainCount]); // 2

	NSString *str2_2 = [NSString stringWithFormat:@"%s,%d", "str2_2",22];
	NSLog(@"str2_2:%d",[str2_2 retainCount]); //1
	[me release];
	[pool drain];
	return 0;
}
