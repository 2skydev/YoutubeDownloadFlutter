import 'package:flutter/material.dart';

import 'package:ytdl/components/Template/index.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Template(
      child: Container(
        child: Center(
          child: Text('IndexPage'),
        ),
      ),
    );
  }
}
