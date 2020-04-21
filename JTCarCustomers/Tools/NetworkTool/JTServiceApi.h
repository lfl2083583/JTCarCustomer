//
//  JTServiceApi.h
//  JTSocial
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#ifndef JTServiceApi_h
#define JTServiceApi_h

//手机号+验证码登录
#define PhoneLoginApi @"client/user/auth/login"

//Token登录
#define TokenLoginApi @"client/user/auth/tokenLogin"

//第三方登录
#define ThirdLoginApi @"client/user/auth/oauthLogin"

//修改用户资料
#define EditeUserInfoApi @"client/user/user/setUserInfo"

//获取七牛上传Token
#define GetQiNiuTokenApi @"client/system/other/getQiniuToken"

//获取系统标签
#define GetSystemTagApi @"client/system/label/getDefaultLabel"

//获取个人/他人用户资料
#define UserInfoApi @"client/user/user/detail"

//设置标签
#define SetSystemTagAPi @"client/system/label/diyLabel"

//获取短信验证码
#define SendSmsApi @"client/user/auth/sendSms"

//绑定手机号码
#define BindingPhoneApi @"client/user/auth/oauthPhone"

//获取附近的人
#define GetNearbyUserApi @"client/user/other/getNearbyUser"

//匹配通讯录好友
#define MatchingAddressListApi @"client/user/phone/contacts"

//关注、取消关注
#define FocusApi @"client/user/follow/follow"

//搜索用户
#define SearchUserApi @"client/user/other/searchUser"

//表情商店列表
#define EmoticonListApi @"client/chat/Emoticon/emoticonList"

//表情包详情
#define EmoticonsDetailApi @"client/chat/Emoticon/emoticonsDetail"

//我的表情包
#define MyEmoticonsApi @"client/chat/Emoticon/myEmoticons"

//表情下载
#define DownloadApi @"client/chat/emoticon/download"

//我的表情
#define EmoticonsSortApi @"client/chat/emoticon/emoticonsSort"

//移除表情
#define RemoveEmoticonsApi @"client/chat/emoticon/removeEmoticons"

//创建群
#define CreatTeamApi @"client/social/group/createGroup"

//我的群列表
#define GetTeamListApi @"client/social/group/getGroupList"

//群分类列表
#define GetTeamClassfyListApi @"client/social/group/getGroupCategory"

//发送红包
#define SendPacketApi @"client/social/packet/sendPacket"

//点击红包
#define ClickPacketApi @"client/social/packet/clickPacket"

//用户抢红包
#define RobPacketApi @"client/social/packet/robPacket"

//获取红包详情
#define GetPacketApi @"client/social/packet/getPacket"

//设置支付密码
#define SetPasswordApi @"client/user/password/set"

//搜索群
#define SearchTeamApi @"client/user/other/searchGroup"

//获取可创建群的个数
#define GetTeamNumApi @"client/social/group/getGroupNum"

//附近的群
#define NearbyTeamApi @"client/social/group/getNearbyGroup"

//推荐的群
#define RecommendTeamApi @"client/social/group/getRecommendGroup"

//解散群
#define BreakTeamApi @"client/social/group/disbandGroup"

//退出群
#define QuitTeamApi @"client/social/group/quitGroup"

//加入群
#define NormalJoinTeamApi @"client/social/group/applyJoinGroup"

//群公告列表
#define AnnounceListApi @"client/social/group/getGroupNoticeList"

//删除群公告
#define DeleteAnnounceApi @"client/social/group/delGroupNotice"

//发布群公告
#define PostAnnounceApi @"client/social/group/addGroupNotice"

//弹幕列表
#define BulletListApi @"client/user/barrage/getUserBarrageList"

//实名认证
#define RealCertificationApi @"client/user/verifie/real"

//设置个人相册
#define SetUserAlbumApi @"client/user/user/setAlbum"

//用户处理邀请加入群操作
#define UserOperateInviteApi @"client/social/group/userOperateInvite"

//邀请用户加入群聊
#define InviteUserApi @"client/social/group/inviteUser"

//群主处理申请加群操作
#define AuditJoinGroupApi @"client/social/group/auditJoinGroup"

//转让群
#define MakeOverGroupApi @"client/social/group/makeOverGroup"

//一键关注所有群成员
#define BatchFollowApi @"client/social/group/batchFollow"

//设置群权限
#define SetGroupPermissionsApi @"client/social/group/setGroupPermissions"

//群禁言（正常权限禁言和解除禁言）
#define GroupBatChatApi @"client/social/group/groupBatChat"

//主动取消禁言
#define CancelBanApi @"client/social/group/cancelBan"

//设置入群审核方式
#define SetJoinGroupModeApi @"client/social/group/setJoinGroupMode"

//收藏
#define AddFavoriteApi @"client/user/favorite/addfavorite"

//收藏列表
#define getuserfavoriteApi @"client/user/favorite/getuserfavorite"

//删除收藏
#define delfavoriteApi @"client/user/favorite/delfavorite"

//门店列表
#define getStoreListApi @"client/store/store/getStoreList"

//获取车品牌
#define getCarBrandApi @"share/car/brand/getList"

//获取车系
#define getCarLineApi @"share/car/series/getMergeListByBid"

//获取车型
#define getCarModelApi @"share/car/spec/getMergeListBySid"

//故障自查分类
#define getCategoryListApi @"client/store/fault/getCategoryList"

//搜索故障
#define searchFaultApi @"client/store/fault/searchFault"

//保养手册
#define maintenanceManualApi @"client/car/Maintenance/manual"

//添加爱车
#define addCarApi @"client/car/car/add"

//我的爱车
#define getCarApi @"client/car/car/get"

//设置默认汽车
#define setCarApi @"client/car/car/set"

//删除爱车
#define delCarApi @"client/car/car/del"

//编辑爱车
#define editCarApi @"client/car/car/edit"

//第三方绑定（手机号检查）
#define CheckOauthPhoneApi @"client/user/auth/checkOauthPhone"

//移除群成员
#define RemoveGroupUserApi @"client/social/group/removeGroupUser"

//邀请群成员
#define InviteUserApi @"client/social/group/inviteUser"

//群公告详情
#define GroupNoticeInfoApi @"client/social/group/groupNoticeInfo"

//群详情
#define GroupInfoApi @"client/social/group/groupInfo"

//编辑群资料
#define EditGroupApi @"client/social/group/editGroup"

//设置群名片
#define SetGroupCardApi @"client/social/group/setGroupCard"

//群成员列表
#define GetGroupMemberApi @"client/social/group/getMember"

//达人评价
#define ExpertCommentApi @"client/chat/expert/expertComment"

//达人列表
#define ExpertListApi @"client/chat/expert/expertList"

//活动列表
#define ActivityListApi @"client/activity/activity/getactivitylist"

//活动搜索
#define ActivitySearchApi @"client/activity/activity/searchActivity"

//推荐的活动
#define RecommendActivityApi @"client/activity/activity/recommendActivity"

//活动详情
#define GetActivityInfoApi @"client/activity/activity/getActivityInfo"

//活动收藏
#define ActivityFavoriteApi @"client/activity/activity/favorite"

//我加入的活动
#define UserActivityApi @"client/activity/activity/userActivity"

//活动评论列表
#define ActivityCommentListApi @"client/activity/activity/commentList"

//删除活动评论
#define DetActivityCommentApi @"client/activity/activity/delComment"

//发布活动评论
#define PostActivityCommentApi @"client/activity/activity/comment"

//参与活动
#define JoinActivityApi @"client/activity/activity/joinActivity"

//投诉
#define UserComplaintsApi @"client/user/other/userComplaints"

//设置黑名单
#define SetBlackApi @"client/user/follow/black"

//黑名单列表
#define BlackListApi @"client/user/follow/blackList"

//绑定第三方
#define BindUserApi @"client/user/Oauth/bindUser"

//分享统计
#define ShareStatisticsApi @"client/user/other/share"

//发送弹幕
#define SendBarrageApi @"client/user/barrage/sendBarrage"

//删除弹幕
#define DeleteBarrageApi @"client/user/barrage/delBarrage"

//弹幕列表
#define BarrageListApi @"client/user/barrage/getUserBarrageList"

//零钱明细
#define GetAccLogApi @"client/user/account/getAccLog"

//设置标签
#define SetUserExtInfoApi @"client/user/user/setUserExtInfo"

//我领取的红包
#define GetRobPacketApi @"client/social/packet/getRobPacket"

//我发出的红包
#define GetSendPacketApi @"client/social/packet/getSendPacket"

//找回支付密码发送验证码
#define GetPayPswSendSmsApi @"client/user/password/sendSms"

//找回支付密码
#define ResetPayPswApi @"client/user/password/reset"

//首次设置支付密码
#define SetPayPswApi @"client/user/password/set"

//修改支付密码
#define EditePayPswApi @"client/user/password/edit"

//更换手机号发送验证码至老的手机号
#define SendSmsForOriginalApi @"client/user/phone/sendSms"

//更换手机号验证6位验证码
#define CheckCodeForOriginalApi @"client/user/phone/checkCode"

//更换手机号验证新手机号码
#define CheckPhoneForNewApi @"client/user/phone/checkPhone"

//更换手机号发送验证码至新的手机号
#define SendSmsForNewApi @"client/user/phone/sendCode"

//更换手机号
#define ReplacePhoneApi @"client/user/phone/replacePhone"

//车生活
#define GetCarLifeurlApi @"share/system/url/getcarlifeurl"

//收藏表情包列表
#define EmoticonFavoriteListApi @"client/chat/emoticon/favoriteList"

//添加到收藏表情
#define EmoticonAddFavoriteApi @"client/chat/emoticon/addFavorite"

//排序我的收藏表情
#define EmoticonSortFavoriteApi @"client/chat/emoticon/sortFavorite"

//移除收藏表情
#define EmoticonRemoveFavoriteApi @"client/chat/emoticon/removeFavorite"

//道路救援价格
#define RescueOutlayApi @"client/store/rescue/rescueOutlay"

//计算拖车距离、价格
#define TrailerPriceApi @"client/store/rescue/trailerPrice"

//门店详情
#define StoreDetailsApi @"client/store/store/storeDetails"

//门店评论列表
#define StoreCommentListApi @"client/store/store/commentList"

//收藏门店
#define StoreFavoriteApi @"client/store/store/favorite"

//获取分类服务列表
#define GetStoreCategoryServiceApi @"client/store/store/getCategoryService"

//client/store/store/getReplaceGoods
#define GetReplaceGoodsApi @"client/store/store/getReplaceGoods"

#endif /* JTServiceApi_h */

