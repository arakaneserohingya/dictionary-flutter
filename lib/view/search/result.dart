part of 'main.dart';

class ViewResult extends StatefulWidget {
  ViewResult({Key key,this.query, this.search}) : super(key: key);

  final String query;
  final void Function(BuildContext context, String word) search;

  @override
  _ViewResultState createState() => _ViewResultState();
}

class _ViewResultState extends State<ViewResult> {
  final core = Core();

  @override
  Widget build(BuildContext context) {
    if (widget.query.isEmpty) {
      return new WidgetContent(key: widget.key, atLeast: 'search\na',enable:' Word ',task: 'or two\nto get ',message:'definition');
    }

    try {
      if (core.definition(widget.query).length > 0) {
        return result(core.collection.definition);
      } else {
        return WidgetContent(key: widget.key, atLeast: 'found no contain\nof ',enable:widget.query,task: '\nin ',message:'bibleInfo?.name');
      }
    } catch (e) {
      return WidgetMessage(key: widget.key, message: e.toString());
    }
  }

  Widget result(List<ResultModel> _r) {
    return new SliverList(
      key: widget.key,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int i) => _resultContainer(searchQuery: widget.query, index: i, data: _r.elementAt(i)),
        childCount: _r.length
      )
    );
  }

  Widget _resultContainer({String searchQuery, int index, ResultModel data}) {
    return Padding(
      padding: EdgeInsets.zero,
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _wordContainer(data.word),
          ListView.builder(
            key: UniqueKey(),
            shrinkWrap: true,
            primary: false,
            itemCount: data.sense.length,
            itemBuilder: (context, index) => _senseContainer(data.sense.elementAt(index))
          ),
          _thesaurusContainer(data.thesaurus)
        ]
      ),
    );
  }

  Widget _wordContainer(String word) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.zero,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 27,
                child: Icon(
                  CupertinoIcons.hand_thumbsup_fill,
                ),
                onPressed: null
              )
            )
          ),
          Expanded(
            flex: 5,
            child: Text(
              word,
              semanticsLabel: word,
              style:TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w400,
                shadows: <Shadow>[
                  Shadow(offset: Offset(0.9, 0.2),blurRadius: 0.4,color: Colors.black54)
                ]
              )
            )
          ),
        ],
      ),
    );
  }

  Widget _senseContainer(SenseModel sense){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(7)),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.7,
            offset: Offset(0.5, .1),
          )
        ]
      ),
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _posContainer(sense.pos),
          _clueContainer(sense.clue)
        ]
      ),
    );
  }

  Widget _posContainer(String pOS){
    return Container(
      padding: EdgeInsets.only(top:10, bottom:10, left:25, right:35),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(100)
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.7,
            offset: Offset(0.2, .2),
          )
        ]
      ),
      child: Text(
        pOS,
        style:TextStyle(
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w300,
          shadows: <Shadow>[
            Shadow(offset: Offset(0.2, 0.2),blurRadius: 0.4,color: Theme.of(context).scaffoldBackgroundColor)
          ]
        )
      ),
    );
  }

  Widget _clueContainer(List<ClueModel> clue) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: ListView.builder(
        key: UniqueKey(),
        shrinkWrap: true,
        primary: false,
        itemCount: clue.length,
        itemBuilder: (context, index){
          return new ListBody(
            children: <Widget>[
              _clueMeaning(clue[index].mean),
              _examContainer(clue[index].exam)
            ]
          );
        }
      ),
    );
  }

  Widget _clueMeaning(String mean) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical:15),
            child: Icon(
              CupertinoIcons.circle,
              size: 11,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: MakeUp(
            str: mean,
            search: widget.search,
            style: TextStyle(
              fontSize: 19,
              height: 1.7
            )
          )
        )
      ]
    );
  }

  Widget _examContainer(List<String> exam) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).primaryColorDark,
            width: 0.4
          )
        )
      ),
      child: ListView.builder(
        key: UniqueKey(),
        shrinkWrap: true,
        primary: false,
        itemCount: exam.length,
        itemBuilder: (context, index){
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical:10),
                  child: Icon(
                    Icons.circle,
                    size: 7,
                    color: Theme.of(context).backgroundColor,
                  ),
                )
              ),
              Expanded(
                flex: 8,
                // child: Text(exam[index]),
                child: MakeUp(
                  str:exam[index],
                  search: widget.search,
                  style:TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    height: 1.3
                  )
                )
              )
            ]
          );
        }
      ),
    );
  }

  Widget _thesaurusContainer(List<String> thes) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        textDirection: TextDirection.ltr,
        children: List<Widget>.generate(thes.length,
          (int index) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: CupertinoButton(
              child: Text(thes[index]),
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              padding: EdgeInsets.symmetric(vertical:7, horizontal:15),
              minSize:30,
              onPressed: () => widget.search(context,thes[index])
            ),
          )
        )
      ),
    );
  }
}

class MakeUp extends StatelessWidget {
  MakeUp({Key key, this.str, this.style, this.search}): super(key: key);
  final String str;
  final TextStyle style;
  final void Function(BuildContext context, String word) search;

  @override
  Widget build(BuildContext context) {
    if (str == null) {
      return RichText(text: TextSpan(text:''));
    }

    final exp = RegExp(r'\[(.*?)\]|\((.*?)\)',multiLine: true, dotAll: false, unicode: true);
    final List<String> chunks = str.split(" ");
    // final List<String> chunks = str.split(exp);
    final List<TextSpan> span = [];
    String current = '';
    for (int i = 0; i < chunks.length; i++) {
      if (exp.hasMatch(chunks[i])) {
        if (current.length > 0) {
          span.add(TextSpan(text: "$current "));
          current = '';
        }

        List<String> t = chunks[i].replaceAllMapped(exp, (Match e) => e.group(1)).toString().split(':');

        String name = t.first;
        String e = t.last;
        if (t.length == 2 && e.isNotEmpty) {
          // List<String> href = e.split('/').map((i) => '{-$i-}').toList();
          List<String> href = e.split('/');
          if (name == 'list'){
            span.add(
              TextSpan(
                text: '',
                children: link(context, href)
              )
            );
          } else {
            span.add(
              TextSpan(
                text: "$name ",
                style: TextStyle(
                  color: Colors.grey
                ),
                children: link(context, href)
              )
            );
          }
        } else {
          span.add(
            TextSpan(
              text: " ${chunks[i]}",
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                // color: Theme.of(context).backgroundColor.
              )
            )
          );
        }
      } else {
        current += " ${chunks[i]}";
      }
    }

    if (current.length > 0) {
      span.add(TextSpan(text: current));
    }

    return SelectableText.rich(
      TextSpan(
        style:style,
        // style:style.copyWith(height: 1.7),
        // style:style.copyWith(color:Colors.black, height: 1.7),
        children: span
      )
    );
  }

  List<TextSpan> link(BuildContext context, List<String> href){
    return mapIndexed(href,
      (int index, String item, String comma) => TextSpan(
        text: "$item$comma",
        style: TextStyle(
          inherit: false,
          color: Colors.blue
        ),
        recognizer: TapGestureRecognizer()..onTap = () => this.search(context, item)
      )
    ).toList();
  }

  Iterable<E> mapIndexed<E, T>(
    Iterable<T> items, E Function(int index, T item, String last) f) sync* {
    int index = 0;
    int last = items.length - 1;

    for (final item in items) {
      yield f(index, item, last == index?'':', ');
      index = index + 1;
    }
  }
}