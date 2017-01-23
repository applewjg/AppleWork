#import <Foundation/Foundation.h>

/*
定义分类的过程大致可分为以下几个步骤：
	第一步、创建一个带有接口的新文件，即创建已有类
 
	第二步、在新文件中添加需要扩展的方法及方法的实现，即需要添加的分类
 */
//NSString 表示将要添加分类的类名称，该类必须是已存在的。
//CamelCase 是为类添加的方法名称。
//只能添加方法，不能添加变量。
//头文件命名惯例:ClassName+CategoryName.h
@interface NSString (CamelCase)

-(NSString*) camelCaseString;

@end

@implementation NSString (CamelCase)

-(NSString*) camelCaseString
{
    //调用NSString的内部方法获取驼峰字符串。
    //self指向被添加分类的类。
    NSString *castr = [self capitalizedString];
	
    //创建数组来过滤掉空格, 通过分隔符对字符进行组合。
    NSArray *array = [castr componentsSeparatedByCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
	
    //把数组的字符输出
    NSString *output = @"";
    for(NSString *word in array)
    {
        output = [output stringByAppendingString:word];
    }
	
    return output;
	
}

@end
int main (int argc, const char * argv[])
{
	
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
    NSString *str = @"My name is bill.";
    NSLog(@"%@", str);
    str = [str camelCaseString];
    NSLog(@"%@", str);
	
    [pool drain];
    return 0;
}

