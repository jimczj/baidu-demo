import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// 退出确定弹窗
Future<bool> confirmDialog(
    {required BuildContext context,
      required String title,
      required void Function() onConfirm}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(fontSize: 14)),
        actions: <Widget>[
          TextButton(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(false), // 关闭对话框
          ),
          TextButton(
            child: const Text('确认'),
            onPressed: onConfirm,
          ),
        ],
      );
    },
  ).then((value) {
    if (value == null) return false;
    return value;
  });
}


// 申请权限
Future<void> requestPermissions(BuildContext context) async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.notification,
  ].request();

  print(statuses);
  if (statuses[Permission.location] == PermissionStatus.denied ||
      statuses[Permission.location] == PermissionStatus.permanentlyDenied) {
    confirmDialog(
      context: context,
      title: '请打开定位权限',
      onConfirm: () {
        openAppSettings();
      },
    );
  }
  if (statuses[Permission.location] == PermissionStatus.granted ||
      statuses[Permission.location] == PermissionStatus.limited) {
    var status = await Permission.locationAlways.request();

    if (status.isPermanentlyDenied) {
      confirmDialog(
        context: context,
        title: '为了更好的服务，请设置始终允许定位',
        onConfirm: () {
          openAppSettings();
        },
      );
    }
  }
  if (statuses[Permission.notification] == PermissionStatus.denied ||
      statuses[Permission.notification] == PermissionStatus.permanentlyDenied) {
    confirmDialog(
      context: context,
      title: '请打开通知权限',
      onConfirm: () {
        openAppSettings();
      },
    );
  }
}
