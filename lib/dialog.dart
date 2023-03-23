import 'package:system_alert_window/system_alert_window.dart';
import 'package:flutter/material.dart';

///
/// Whenever a button is clicked, this method will be invoked with a tag (As tag is unique for every button, it helps in identifying the button).
/// You can check for the tag value and perform the relevant action for the button click
@pragma('vm:entry-point')
void callBack(String tag) {
  WidgetsFlutterBinding.ensureInitialized();
  SystemAlertWindow.closeSystemWindow(
      prefMode: SystemWindowPrefMode.OVERLAY);
}

// 全屏幕提醒
void showSystemDialog(
    {required String title, required int height, required int width}) {
  SystemWindowHeader header = SystemWindowHeader(
    title: SystemWindowText(text: ""),
  );

  SystemWindowFooter footer = SystemWindowFooter(
    buttons: [
      SystemWindowButton(
        text: SystemWindowText(
          text: "知道了",
          fontSize: 14,
          textColor: Colors.white,
        ),
        tag: "ignore",
        width: 0,
        padding: SystemWindowPadding(left: 10, right: 10, bottom: 5, top: 5),
        height: SystemWindowButton.WRAP_CONTENT,
        decoration: SystemWindowDecoration(
          startColor: Color.fromRGBO(250, 139, 97, 1),
          endColor: Color.fromRGBO(247, 28, 88, 1),
          borderWidth: 0,
          borderRadius: 30.0,
        ),
      )
    ],
    padding: SystemWindowPadding(left: 16, right: 16, bottom: 12),
    decoration: SystemWindowDecoration(startColor: Colors.white),
    buttonsPosition: ButtonPosition.CENTER,
  );

  SystemWindowBody body = SystemWindowBody(
    rows: [
      EachRow(
        columns: [
          EachColumn(
            text: SystemWindowText(
                text: title, fontSize: 14, textColor: Colors.black45),
          ),
        ],
        gravity: ContentGravity.CENTER,
      ),
    ],
    padding: SystemWindowPadding(left: 16, right: 16, bottom: 120, top: 120),
  );

  SystemAlertWindow.showSystemWindow(
    height: height - 20,
    header: header,
    body: body,
    footer: footer,
    gravity: SystemWindowGravity.TOP,
    notificationTitle: "到站了",
    notificationBody: "本次到站提醒已结束，感谢您的使用",
    prefMode: SystemWindowPrefMode.OVERLAY,
  );
  SystemAlertWindow.registerOnClickListener(callBack);
}