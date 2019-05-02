import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lite_animator/bloc/bloc.dart';
import 'package:lite_animator/models/models.dart';
import 'package:lite_animator/pages/draw_projects_page.dart';

class DrawPage extends StatefulWidget {
  final String drawProjectName;
  final String drawProjectURL;

  DrawPage({@required this.drawProjectName, this.drawProjectURL});

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  final PainterBloc _painterBloc = PainterBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _painterBloc,
      child: Scaffold(
        body: DrawPanel(_painterBloc, widget.drawProjectURL), //TODO give it project url as param for painting existing pic if any?
        bottomNavigationBar: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                _painterBloc.dispatch(RenderPainting(widget.drawProjectName));
                //TODO race condition between saving project and returning to list
                Navigator.of(context).pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DrawingProjectsPage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => _painterBloc.dispatch(Clear()),
            ),
            IconButton(
              icon: Icon(Icons.undo),
              onPressed: () => _painterBloc.dispatch(UndoStroke()),
            ),
            IconButton(
              icon: Icon(Icons.redo),
              //color: _painterBloc.undoHistory.isEmpty ? Colors.grey : Colors.black,
              onPressed: () => _painterBloc.dispatch(RedoStroke()),
            )
          ],
        ),
      ),
    );
  }
}
