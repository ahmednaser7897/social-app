// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// ignore: must_be_immutable
class Pdf extends StatelessWidget{
  final GlobalKey<SfPdfViewerState> pc = GlobalKey();
  String file;
  Pdf(this.file, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCupit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCupit cupit=SocialCupit.get(context);
        return Directionality(
          textDirection: (cupit.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(),
            body: SizedBox(
              height: double.infinity,
              child: SfPdfViewer.network(file,key: pc,)
            ),
          ),
        );
        }
    );
  }
}