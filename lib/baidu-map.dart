import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFMapSDK, BMF_COORD_TYPE;
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:permission_handler/permission_handler.dart';

class BaiduMapLoc {
  static LocationFlutterPlugin? locPlugin;
  static Function(BaiduLocation)? locCallback;
  static bool isOnce = false;

  // 初始化定位组件
  static initPlugin(BuildContext context) async {
    if (locPlugin != null) return;

    locPlugin = LocationFlutterPlugin();
    // 动态申请定位权限
    requestPermission(context);
    // 设置是否隐私政策
    locPlugin!.setAgreePrivacy(true);
    BMFMapSDK.setAgreePrivacy(true);

    if (Platform.isIOS) {
      // locPlugin!.authAK(BAIDU_KEY_IOS);
      // BMFMapSDK.setApiKeyAndCoordType(BAIDU_KEY_IOS, BMF_COORD_TYPE.BD09LL);
    } else if (Platform.isAndroid) {
      BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
    }
    locPlugin!.getApiKeyCallback(callback: (String result) {
      print('iOS端鉴权结果：${result}');
    });
    locPlugin!.seriesLocationCallback(callback: _handleLocationCallback);
  }

  // 更新定位配置
  static updateLocOption({isOnce = true, scanspan = 2}) {
    /// 设置android端和ios端定位参数
    Map iosMap = _initIOSOptions(isOnce: isOnce).getMap();
    Map androidMap =
    _initAndroidOptions(isOnce: isOnce, scanspan: scanspan * 1000).getMap();

    locPlugin!.prepareLoc(androidMap, iosMap);
  }

  static stop() {
    locPlugin!.stopLocation();
    locCallback = null;
  }

  // 动态申请定位权限
  static Future requestPermission(BuildContext context) async {
    // 申请权限
    var status = await Permission.location.request();
    if (status.isLimited || status.isGranted) return;
  }

  static _handleLocationCallback(BaiduLocation location) {
    if (locCallback == null) return;
    locCallback!(location);
    if (isOnce) {
      stop();
    }
  }

  // 单次定位
  static singleLocation({required void Function(BaiduLocation) callback}) {
    isOnce = true;
    locCallback = callback;
    updateLocOption(isOnce: true, scanspan: 1);
    locPlugin!.singleLocation({'isReGeocode': true, 'isNetworkState': true});
  }

  // 连续定位
  static seriesLocation({required void Function(BaiduLocation) callback}) {
    isOnce = false;
    locCallback = callback;
    updateLocOption(isOnce: false, scanspan: 1);
    locPlugin!.singleLocation({'isReGeocode': true, 'isNetworkState': true});
  }

  static BaiduLocationAndroidOption _initAndroidOptions(
      {isOnce = true, scanspan = 4000}) {
    if (isOnce) {
      return BaiduLocationAndroidOption(
        locationMode: BMFLocationMode.hightAccuracy,
        isNeedAddress: true,
        isNeedAltitude: true,
        isNeedLocationPoiList: true,
        isNeedNewVersionRgc: true,
        isNeedLocationDescribe: true,
        openGps: true,
        scanspan: scanspan,
        coordType: BMFLocationCoordType.bd09ll,
      );
    }
    return BaiduLocationAndroidOption(
      locationMode: BMFLocationMode.batterySaving,
      isNeedAltitude: true,
      isNeedLocationPoiList: false,
      isNeedNewVersionRgc: false,
      openGps: true,
      scanspan: scanspan,
      locationPurpose: BMFLocationPurpose.sport,
      coordType: BMFLocationCoordType.bd09ll,
    );
  }

  static BaiduLocationIOSOption _initIOSOptions({isOnce = true}) {
    if (isOnce) {
      return BaiduLocationIOSOption(
        coordType: BMFLocationCoordType.bd09ll,
        BMKLocationCoordinateType: 'BMKLocationCoordinateTypeBMK09LL',
        desiredAccuracy: BMFDesiredAccuracy.best,
      );
    }
    return BaiduLocationIOSOption(
      coordType: BMFLocationCoordType.bd09ll,
      BMKLocationCoordinateType: 'BMKLocationCoordinateTypeBMK09LL',
      desiredAccuracy: BMFDesiredAccuracy.best,
      allowsBackgroundLocationUpdates: true,
      pausesLocationUpdatesAutomatically: false,
    );
  }
}
