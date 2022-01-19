import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musclatax/components/container.dart';
import 'package:musclatax/components/title.dart';
import 'package:musclatax/models/access.dart';
import 'package:musclatax/models/train.dart';

class WeekDisplay extends StatefulWidget {
  final Week week;

  const WeekDisplay({Key? key, required this.week}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeekDisplayState();
}

class _WeekDisplayState extends State<WeekDisplay> {
  List<Session> sessions = [];

  @override
  void initState() {
    super.initState();
    _initAsyncState();
  }

  void _initAsyncState() async {
    var _sessions = await _fetchData();
    setState(() {
      sessions = _sessions;
    });
  }

  Future<List<Session>> _fetchData() async {
    return await DBAccess.getSessions(widget.week);
  }

  @override
  Widget build(BuildContext context) {
    List<Session> _sessions = sessions;

    return Scaffold(
        body: DefaultContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(
                text: widget.week.toString(),
                fontSize: 28,
              ),
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: _sessions.length,
                  itemBuilder: (BuildContext context, int index) {
                    Session extracted = _sessions[index];
                    return InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Session.widget(extracted),
                          IconButton(
                            onPressed: () {
                              DBAccess.removeSession(widget.week, extracted);
                              _initAsyncState();
                            },
                            icon: const Icon(
                              Icons.delete,
                            ),
                            color: Colors.red,
                            iconSize: 28,
                          )
                        ],
                      ),
                      onTap: () => {
                        // Launch the session view
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          elevation: 5,
          onPressed: () async {
            Session newSession = Session(-1, DateTime.now());
            newSession.id =
                await DBAccess.insertNewSession(widget.week, newSession);
            _initAsyncState();
          },
        ));
  }
}
