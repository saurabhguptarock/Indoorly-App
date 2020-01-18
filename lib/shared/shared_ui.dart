import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 70,
        width: 220,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 60,
              width: 60,
              child: FlareActor("assets/flare/Rotating Progress Indicator.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "Loading"),
            ),
            Text(
              'Fetching Location',
              style:
                  GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}

Future<bool> handlePermission() async {
  await PermissionHandler().requestPermissions([
    PermissionGroup.camera,
    PermissionGroup.ignoreBatteryOptimizations,
    PermissionGroup.location,
    PermissionGroup.sensors,
    PermissionGroup.storage
  ]);
  PermissionStatus permissionStatus1 =
      await PermissionHandler().checkPermissionStatus(
    PermissionGroup.camera,
  );
  PermissionStatus permissionStatus2 =
      await PermissionHandler().checkPermissionStatus(
    PermissionGroup.ignoreBatteryOptimizations,
  );
  PermissionStatus permissionStatus3 =
      await PermissionHandler().checkPermissionStatus(
    PermissionGroup.location,
  );
  PermissionStatus permissionStatus4 =
      await PermissionHandler().checkPermissionStatus(
    PermissionGroup.sensors,
  );
  PermissionStatus permissionStatus5 =
      await PermissionHandler().checkPermissionStatus(
    PermissionGroup.storage,
  );
  if (permissionStatus1.value == 2 &&
      permissionStatus2.value == 2 &&
      permissionStatus3.value == 2 &&
      permissionStatus4.value == 2 &&
      permissionStatus5.value == 2)
    return Future.value(true);
  else
    return Future.value(false);
}
