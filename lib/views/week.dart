import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musclatax/components/button.dart';
import 'package:musclatax/components/container.dart';
import 'package:musclatax/components/title.dart';
import 'package:musclatax/components/utils.dart' as mu_utils;
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
      _sessions.sort((s1, s2) => s1.dateTime.compareTo(s2.dateTime));
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

                    Color getColor(Set<MaterialState> states) {
                      return extracted.done
                          ? Colors.green.shade400
                          : Colors.grey.shade600;
                    }

                    return InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Session.widget(extracted),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  DBAccess.removeSession(
                                      widget.week, extracted);
                                  _initAsyncState();
                                },
                                icon: const Icon(
                                  Icons.delete,
                                ),
                                color: Colors.red,
                                iconSize: 32,
                              ),
                              Transform.scale(
                                scale: 1.4,
                                child: Checkbox(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                  onChanged: (val) {
                                    extracted.done = val!;
                                    DBAccess.updateSession(
                                        widget.week, extracted);
                                    _initAsyncState();
                                  },
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                  value: extracted.done,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      onTap: () => {
                        // Launch the session view
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    thickness: 1,
                  ),
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
            final value = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => _AddSessionInWeek(
                          week: widget.week,
                          sessions: _sessions,
                        )));
            _initAsyncState();
          },
        ));
  }
}

class _AddSessionInWeek extends StatelessWidget {
  final Week week;
  final List<Session> sessions;

  const _AddSessionInWeek(
      {Key? key, required this.week, required this.sessions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime startOfWeek = mu_utils.DateUtils.startOfWeekDate(week.dateTime);

    isPresent(int day) {
      return sessions
          .any((element) => element.dateTime.day == startOfWeek.day + day);
    }

    addSession(int day) {
      return isPresent(day)
          ? null
          : () async {
              DateTime dateSession = startOfWeek.add(Duration(days: day));
              Session newSession = Session(-1, dateSession);
              newSession.id = await DBAccess.insertNewSession(week, newSession);
              Navigator.pop(context);
            };
    }

    return Scaffold(
      body: DefaultContainer(
        topbottom: 80,
        child: Stack(children: [
          HeaderText(text: "Ajouter une session"),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DefaultButton(
                    content: "Lundi",
                    fontSize: 28,
                    paddingLeftRight: 20,
                    paddingTopBottom: 20,
                    disabled: isPresent(0),
                    onPressed: addSession(0),
                  ),
                  DefaultButton(
                    content: "Mardi",
                    fontSize: 28,
                    paddingLeftRight: 20,
                    paddingTopBottom: 20,
                    disabled: isPresent(1),
                    onPressed: addSession(1),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DefaultButton(
                    content: "Mercredi",
                    fontSize: 28,
                    paddingLeftRight: 20,
                    paddingTopBottom: 20,
                    disabled: isPresent(2),
                    onPressed: addSession(2),
                  ),
                  DefaultButton(
                    content: "Jeudi",
                    fontSize: 28,
                    paddingLeftRight: 20,
                    paddingTopBottom: 20,
                    disabled: isPresent(3),
                    onPressed: addSession(3),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DefaultButton(
                    content: "Vendredi",
                    fontSize: 28,
                    paddingLeftRight: 20,
                    paddingTopBottom: 20,
                    disabled: isPresent(4),
                    onPressed: addSession(4),
                  ),
                  DefaultButton(
                    content: "Samedi",
                    fontSize: 28,
                    paddingLeftRight: 20,
                    paddingTopBottom: 20,
                    disabled: isPresent(5),
                    onPressed: addSession(5),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultButton(
                    content: "Dimanche",
                    fontSize: 28,
                    paddingLeftRight: 20,
                    paddingTopBottom: 20,
                    disabled: isPresent(6),
                    onPressed: addSession(6),
                  )
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}
