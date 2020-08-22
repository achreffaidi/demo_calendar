import 'dart:async';
import 'dart:math';

import 'package:customizable_date_picker/customizable_date_picker.dart';
import 'package:customizable_date_picker/models.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CustomDatePickerController _controller = new CustomDatePickerController(
    generateCustomDay: _generateDay,
    start: DateTime.now().subtract(Duration(days: 31*3)),
    end: DateTime.now().add(Duration(days: 31*3)),
  );
  DateTime start,end;

  @override
  void initState(){
    _controller.onRangeSelected= (DateTime s , DateTime e){
      setState(() {
        start = s;
        end = e;
      });
    };
    Future.delayed(Duration(seconds: 1),()=>_controller.scrollTo(DateTime.now()));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: Card(
            child: CustomDatePicker(_controller,
            dayItemBuilder: _dayItemBuilder,
            background: _getBackground(),
            monthTitleBuilder: _monthTitleBuilder,
            headerBackgroundColor: Color.lerp(Colors.black, Colors.blue, 0.1),
            headerTextStyle: TextStyle(color: Colors.white,fontSize: 20),),
          )
        ),
      ),
    );
  }

  static CustomDay _generateDay(DateTime date) {
    var random = new Random();
    return CustomDay(date,Activities(random.nextInt(5)));
  }

  Widget _dayItemBuilder(CustomDay day, int index) {
    bool isSelected = true;
    var br;
    var borderSide = BorderSide(
      color: Colors.blue,
      width: 1.0,
    );
    Color color = Colors.white;
    if(start==null||day.date.isBefore(start) || day.date.isAfter(end)){
      isSelected=false;
    }
    if(isSelected){
      color = Color.lerp(Colors.white, Colors.purple, index/30);
      if (start.isAtTheSameDayAs(end)) {
        br = Border(
            right: borderSide,
            left: borderSide,
            top: borderSide,
            bottom: borderSide
        );
      } else if (day.date.isAtTheSameDayAs(start)) {
        br = Border(
            left: borderSide,
            top: borderSide,
            bottom: borderSide
        );
      } else if (day.date.isAtTheSameDayAs(end)) {
        br = Border(
            right: borderSide,
            top: borderSide,
            bottom: borderSide
        );
      } else {
        br =  br = Border(
            top: borderSide,
            bottom: borderSide
        );
      }
    }


    return
      Expanded(
          child: Opacity(
            opacity: day.hidden?0:1,
            child: GestureDetector(
              onTap: (){
                if(!day.hidden) _controller.onDaySelect(day.date);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    border: br,
                    shape: BoxShape.rectangle,
                    color: Color.lerp(color, Colors.transparent, 0.5),
                  ),
                child:
                AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Text(day.date.day.toString(),style: TextStyle(fontSize: 20,color: Colors.white),),
                      ),
                      day.data==null?Container():Positioned(
                        child: Icon(day.data.icon,color: day.data.color,size: 30,),
                        bottom: 0,
                        right: 0,
                      )
                    ],
                  ),
                )
              ),
            ),
          ),
        );
  }

  Widget _getBackground() {
    return new FlareActor("assets/background.flr", alignment:Alignment.center, fit:BoxFit.cover, animation:"0");
  }

  Widget _monthTitleBuilder(DateTime date) {
      final f = new DateFormat('MMMM, yyyy');
      String formattedText = f.format(date);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width*.7,
            height: 3,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white,Colors.transparent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 15, top: 10),
                  child: Text(
                    formattedText,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500,color: Colors.white),
                  )),
            ],
          ),
          SizedBox(height: 20,),
        ],
      );
    }

}

class Activities{
  IconData icon;
  Color color;
  Activities(int index){
    switch(index){
      case 0 : icon = Icons.directions_bike; color = Colors.pinkAccent; break ;
      case 1 : icon = Icons.style; color = Colors.blue; break ;
      case 2 : icon = Icons.filter_hdr; color = Colors.green; break ;
      case 3 : icon = Icons.beach_access; color = Colors.yellow; break ;
    }
  }
}
