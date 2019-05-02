import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lite_animator/bloc/bloc.dart';
import 'package:lite_animator/pages/draw_page.dart';

class CreateNewDrawProjectPage extends StatefulWidget {
  @override
  _CreateNewDrawProjectPageState createState() =>
      _CreateNewDrawProjectPageState();
}

class _CreateNewDrawProjectPageState extends State<CreateNewDrawProjectPage> {
  final ProjectNameBloc _projectNameBloc = ProjectNameBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Draw Project"),
      ),
      body: CreateNewDrawProjectForm(projectNameBloc: _projectNameBloc),
    );
  }

  @override
  void dispose() {
//    _loginBloc.dispose();
    super.dispose();
  }
}

class CreateNewDrawProjectForm extends StatefulWidget {
  final ProjectNameBloc projectNameBloc;

  CreateNewDrawProjectForm({@required this.projectNameBloc});

  @override
  _CreateNewDrawProjectFormState createState() =>
      _CreateNewDrawProjectFormState();
}

class _CreateNewDrawProjectFormState extends State<CreateNewDrawProjectForm> {
  ProjectNameBloc get _projectNameBloc => widget.projectNameBloc;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _projectNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectNameEvent, ProjectNameState>(
      bloc: _projectNameBloc,
      builder: (BuildContext context, ProjectNameState state) {
        if (state is ProjectNameValid) {
          return DrawPage(drawProjectName: _projectNameController.text, drawProjectURL: null,);
        }
        else {
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Project name'),
                    controller: _projectNameController,
                    autofocus: true,
                    validator: (value) {
                      //Note: this validator only checks empty strings. Non-conflicting names are checked by the ProjectNameBloc.
                      if (value.isEmpty) {
                        return 'Please enter a name for your project';
                      }
                    },
                  ),
                ),
                RaisedButton(
                  onPressed: state is! ProjectNameValidating
                      ? _onCreateButtonPressed
                      : null,
                  child: Text('Create!'),
                ),
                Container(
                  child: state is ProjectNameValidating
                      ? CircularProgressIndicator()
                      : null,
                ),
                state is ProjectNameInvalid ?
                  NameConflictAlert(projectNameBloc: _projectNameBloc, projectNameController: _projectNameController,) : Container(),
              ],
            ),
          );
        }
      },
    );
  }

  _onCreateButtonPressed() {
    if (_formKey.currentState.validate()) {
      _projectNameBloc.dispatch(
          ProjectNameEntered(projectName: _projectNameController.text, overwrite: false));
    }
  }
}

class NameConflictAlert extends StatelessWidget {
  const NameConflictAlert({
    Key key,
    @required ProjectNameBloc projectNameBloc,
    @required TextEditingController projectNameController,
  }) : _projectNameBloc = projectNameBloc, _projectNameController = projectNameController,
        super(key: key);

  final ProjectNameBloc _projectNameBloc;
  final TextEditingController _projectNameController;

  @override
  Widget build(BuildContext context) {
    //TODO make pretty
    return AlertDialog(
        title: Text('A project already has that name'),
        content: Text('Would you like to overwrite it?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Rename'),
            onPressed: () {
              _projectNameBloc.dispatch(ProjectNameEntryRestarted());
            },
          ),
          FlatButton(
            child: Text('Overwrite',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              _projectNameBloc.dispatch(ProjectNameEntered(projectName: _projectNameController.text, overwrite: true));
            },
          ),
        ]
    );
  }
}
