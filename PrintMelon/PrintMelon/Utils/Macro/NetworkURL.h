//
//  NetworkURL.h
//  DeepEyeAPP
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#ifndef NetworkURL_h
#define NetworkURL_h

//DE_BUG : 0外网环境（生产环境），1内网环境（测试环境）
#define DE_BUG 1
//#define HOST_URL DE_BUG ? @"http://192.168.11.101:7000" : @"http://202.105.113.102:17000"
//#define HOST_IMAGE_URL DE_BUG ? @"http://192.168.11.101:17005" : @"http://202.105.113.102:17005"

#define HOST_URL DE_BUG ? @"http://www.inggua.com" : @"http://202.105.113.102:17000"
#define HOST_IMAGE_URL DE_BUG ? @"http://192.168.11.101:17005" : @"http://202.105.113.102:17005"


#define register_URL @"/home/login/register"
#define login_URL @"/home/login/dologin"
#define wxLogin_URL @"/home/login/wxlogin"

#define modifyPwd_URL @"/home/login/forget"

#define userSet_URL @"/home/user/set"
#define modifyNick_URL @"/home/user/updateuser"
#define home_URL @"/home/index/index"
#define orderList_URL @"/home/order/order"
#define printEdit_URL @"/home/order/edit"

#define modifyAddress_URL @"/home/order/updateAddress"
#define payMethod_URL @"/home/order/paymode"
#define orderDetail_URL @"/home/order/orderinfo"
#define deleteOrder_URL @"/home/order/delorder"
#define modifyOrderStatus_URL @"/home/order/status"

#define confirmOrder_URL @"/home/order/sures"
#define payment_URL @"/home/order/pay"
#define uploadFile_URL @"/home/user/uploadfile"
#define sendVerificationCode_URL @"/home/login/sendcode"
#define myDoc_URL @"/home/user/myfile"
#define deleteDoc_URL @"/home/user/delfile"
#define userInfo_URL @"/home/user/info"
#define modifyHeadImage_URL @"/home/user/updatehead"
#define bindPhone_URL @"/home/login/bandphone"
#define serviceArea_URL @"/home/index/amap"




#endif /* NetworkURL_h */
