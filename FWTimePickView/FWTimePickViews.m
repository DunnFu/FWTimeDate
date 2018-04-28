//
//  FWTimePickViews.m
//  FWTimePickView
//
//  Created by fuwu on 2018/3/30.
//  Copyright © 2018年 符武. All rights reserved.
//

#import "FWTimePickViews.h"

@interface FWTimePickViews () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView *configuerView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIPickerView *pickView;

@property (nonatomic, strong) NSMutableArray *yearsArray;
@property (nonatomic, strong) NSMutableArray *monthsArray;
@property (nonatomic, strong) NSMutableArray *daysArray;
@property (nonatomic, strong) NSMutableArray *hoursArray;
@property (nonatomic, strong) NSMutableArray *minsArray;

@property (nonatomic, strong) NSMutableArray *dataYear;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger index1;
@property (nonatomic, assign) NSInteger index2;

@property (nonatomic , assign) NSInteger nowYear;
@property (nonatomic , assign) NSInteger nowMonth;
@property (nonatomic , assign) NSInteger nowDay;
@property (nonatomic , assign) NSInteger nowHour;

@end

@implementation FWTimePickViews

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        _index = 0;
        _index1 = 0;
        _index2 = 0;
        
        self.yearsArray = [NSMutableArray array];
        self.monthsArray = [NSMutableArray array];
        self.daysArray = [NSMutableArray array];
        
        self.dataYear = [NSMutableArray array];
        
        [self getFWTimes];
        [self setUIConfigus];

    }
    return self;
}
- (void)setUIConfigus {
    _configuerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 260, self.frame.size.width, 260)];
    _configuerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_configuerView];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelBtn.frame = CGRectMake(0, 0, 60, 40);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_cancelBtn  addTarget:self action:@selector(calcelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_configuerView addSubview:_cancelBtn];
    
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _sureBtn.frame = CGRectMake(self.frame.size.width - 60, 0, 60, 40);
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    _sureBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_configuerView addSubview:_sureBtn];
    
    UIView *colorV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cancelBtn.frame), self.frame.size.width, 1)];
    colorV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [_configuerView addSubview:colorV];
    
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(colorV.frame), self.frame.size.width, 219)];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    [_configuerView addSubview:_pickView];

    
}

#pragma mark - PickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSMutableArray *yearsArr = self.dataYear;
    NSArray *monthsArr;
    if (component == 0) {
        return yearsArr.count;
    }
    else if (component == 1) {
        if (_index >= yearsArr.count) {
            _index = 0;
        }
        NSDictionary *temp = yearsArr[_index];
        monthsArr = temp.allValues.firstObject;
        
        return monthsArr.count;
    } else if (component == 2) {
        NSDictionary *temp = yearsArr[_index];
        monthsArr = temp.allValues.firstObject;
        if (_index1 >= monthsArr.count) {
            _index1 = 0;
        }
        NSDictionary *daysDic = monthsArr[_index1];
        NSArray *days =  daysDic.allValues.firstObject;
        return days.count;
    } else {
        NSDictionary *temp = yearsArr[_index];
        monthsArr = temp.allValues.firstObject;
        if (_index1 >= monthsArr.count) {
            _index1 = 0;
        }
        NSDictionary *dItems = monthsArr[_index1];
        NSArray *datAr = dItems.allValues.firstObject;
        NSInteger year = [temp.allKeys.firstObject integerValue];
        NSInteger month = [dItems.allKeys.firstObject integerValue];
        if (_index2 >= datAr.count) {
            _index2 = 0;
        }
        NSInteger day = [datAr[_index2] integerValue];
        if (year == self.nowYear && month == self.nowMonth && day == self.nowDay) {
            
            return 24 - self.nowHour;
        } else {
            return 24;
        }
        
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*component/5.0, 0,self.frame.size.width/5.0, 30)];
    label.font=[UIFont systemFontOfSize:15.0];
    label.textAlignment=NSTextAlignmentCenter;
    label.backgroundColor = [UIColor orangeColor];
    NSMutableArray *years = self.dataYear;
    switch (component) {
        case 0:
            {
                NSDictionary *dict = years[row];
                label.text = [NSString stringWithFormat:@"%ld年",[dict.allKeys.firstObject integerValue]];
                
            }
            break;
            case 1:
        {
            NSDictionary *dict = years[_index];
            NSArray *array = dict.allValues;
            NSArray *dd = array.firstObject;
            NSDictionary *ditem = dd[row];
            NSInteger month = [ditem.allKeys.firstObject integerValue];
            label.text = [NSString stringWithFormat:@"%ld月",month];
        }
            break;
            case 2:
        {
            NSDictionary *temp = years[_index];
            NSArray *months = temp.allValues.firstObject;
            if (_index1 >= months.count) {
                _index1 = 0;
            }
            
            NSDictionary *ditem = months[_index1];
            NSArray *days = ditem.allValues.firstObject;
            label.text = [NSString stringWithFormat:@"%ld日",[days[row] integerValue]];
        }
            break;
            
            case 3:
        {
            
            NSDictionary *temp = years[_index];
            NSArray *months = temp.allValues.firstObject;
            NSDictionary *ditem = months[_index1];
            NSArray *days = ditem.allValues.firstObject;
            NSInteger year = [temp.allKeys.firstObject integerValue];
            NSInteger month = [ditem.allKeys.firstObject integerValue];
            if (_index2 >= days.count) {
                _index2 = 0;
            }
            NSInteger day = [days[_index2] integerValue];
            if (year == self.nowYear && month == self.nowMonth && day == self.nowDay) {
                label.text = [NSString stringWithFormat:@"%ld时",self.nowHour+row];
            } else {
                 label.text=[NSString stringWithFormat:@"%ld时",row];
            }
        }
            break;
        default:
            break;
    }
    
    
    
    
    return label;

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _index = [pickerView selectedRowInComponent:0];
        _index1 = [pickerView selectedRowInComponent:1];
        _index2 = [pickerView selectedRowInComponent:2];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView reloadComponent:3];
    }else if (component == 1){
        _index1 = [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:2];
        [pickerView reloadComponent:3];
    }else if (component == 2){
        _index2 = [pickerView selectedRowInComponent:2];
        [pickerView reloadComponent:3];
        
        
    } else if (component == 3) {
      
    }
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return ([UIScreen mainScreen].bounds.size.width-40)/4;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

#pragma mark - 获取时间
- (void)getFWTimes {
    NSDate *nowDate = [NSDate date];
    NSCalendar *caledar = [NSCalendar currentCalendar];
    NSUInteger uitfs = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *componets = [caledar components:uitfs fromDate:nowDate];
    
    NSInteger year = [componets year];
    NSInteger month = [componets month];
    NSInteger day = [componets day];
    NSInteger hour = [componets hour];
    
    self.nowYear = year;
    self.nowMonth = month;
    self.nowDay = day;
    self.nowHour = hour;
    NSLog(@"=======%ld,%ld,%ld,%ld",year,month,day,hour);

    
    NSInteger nowYear = year;
    NSInteger nowMonth = month;
    
    //年
    NSMutableArray *yearsArray  = [NSMutableArray array];
    for (NSInteger i = year; i < year + 2; i++) {
        NSInteger FromMonth;//月份
        if (i == nowYear) {
           //当前年
            FromMonth = nowMonth;
        } else {
             //明年
            FromMonth = 1;
            month = 1;
        }
        //月 1.如是当前年，剩余多少月  2.明年，月份从1开始
        NSMutableArray *monthsArray = [NSMutableArray array];
        for (NSInteger j = FromMonth; j <= 12; j++) {
            NSInteger FromDay;//日
            //日 1.如果是当前年月，剩余多少日  2.其他月份，日从1开始
            if (i == nowYear && month == nowMonth ) {
                FromDay = day;
            } else {
                FromDay = 1;
                day = 1;
            }
            //日
            NSMutableArray *daysArray = [NSMutableArray array];
            for (NSInteger k = FromDay; k <= [self isAllDay:year andMonth:month] ; k++) {
                
                [daysArray addObject:@(day)];
                day ++;
            }
            NSMutableDictionary *monthDict = @{@(month):daysArray}.mutableCopy;
            [monthsArray addObject:monthDict];
            month ++;
            
        }
        NSMutableDictionary *yearDict = @{@(i):monthsArray}.mutableCopy;
        [yearsArray addObject:yearDict];
    }
    self.dataYear = yearsArray;
   // NSLog(@"=====%@",yearsArray);
  
    
}
//返回天数
-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    
    return day;
}
#pragma mark 取消
- (void)calcelAction:(UIButton *)sender {
    [self removeFromSuperview];
}
#pragma mark 确定
- (void)sureAction:(UIButton *)sender {
    
}

@end
