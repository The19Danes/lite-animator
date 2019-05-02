import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lite_animator/pages/create_new_draw_project_page.dart';
import 'package:lite_animator/bloc/bloc.dart';
import 'package:lite_animator/pages/draw_page.dart';

class DrawingProjectsPage extends StatefulWidget {
  @override
  _DrawingProjectsPageState createState() => _DrawingProjectsPageState();
}

class _DrawingProjectsPageState extends State<DrawingProjectsPage> {
  UserProjectsBloc userProjectsBloc;

  @override
  void initState() {
    userProjectsBloc = UserProjectsBloc();
    userProjectsBloc.dispatch(Fetch());
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing Projects'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 5.0,
        backgroundColor: Colors.black,
        tooltip: "new project",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNewDrawProjectPage()),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: BlocBuilder<UserProjectsEvent, UserProjectsState>(
          bloc: userProjectsBloc,
          builder: (BuildContext context, UserProjectsState state) {
            if (state is UserProjectsListLoaded) {
              final List projectsDataList = state.userInfo.entries.toList();
              projectsDataList.sort((a, b) => a.key.compareTo(b.key));
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: projectsDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Card(
                      color: Colors.white30,
                      child: Column(children: [
                        Text(
                          '${projectsDataList[index].key}',
                          textScaleFactor: 1.3,
                        ),
                        Flexible(
                            child: CachedNetworkImage(
                          imageUrl: projectsDataList[index].value,
                          placeholder: (content, url) =>
                              LinearProgressIndicator(
                                backgroundColor: Colors.grey,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                          errorWidget: (context, url, error) => Container(
                                color: Colors.grey,
                              ),
                        )),
                      ]),
                    ),
                    onTap: () {
                      print('opening project : ${projectsDataList[index].key}');
                      final String projectName = projectsDataList[index].key;
                      final String projectURL = projectsDataList[index].value;
                      Navigator.push(
                        context,
                          MaterialPageRoute(builder: (context) => DrawPage(drawProjectName: projectName, drawProjectURL: projectURL,)),
                      );
                    },
                  );
                },
              );
            }
            else{
              return Center( child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ));
            }
          }),
    );
  }
}

