import 'package:flutter/material.dart';

class Template extends StatelessWidget {
  Widget child;

  Template({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () {
          // 화면을 터치시 현재 포커스를 off
          // 주의: 작동이 안되면 Container 위젯에 colors: Colors.transparent 추가 (터치 영역으로 선언이 안되어서 그럼)
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: child,
        ),
      ),
    );
  }
}
