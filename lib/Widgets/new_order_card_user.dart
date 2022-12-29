import 'package:flutter/material.dart';

class NewOrderCardUser extends StatelessWidget {
  int totalcloth;
  Map<String, int> map;
  String orderdate;
  bool isVerified;
  bool isDispatched;
  bool hasError;
  DateTime? deliveryDate;
  NewOrderCardUser(
      {required this.deliveryDate,
      required this.orderdate,
      required this.totalcloth,
      required this.map,
      required this.hasError,
      required this.isVerified,
      required this.isDispatched});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var widgth = MediaQuery.of(context).size.width;

    return Card(
      color: Colors.blue.shade100,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ExpansionTile(
        title: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ordered on " + orderdate.toString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        )),
        subtitle: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Count : " + totalcloth.toString(),
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            if (hasError)
              Text("Status : Declined",
                  style: TextStyle(
                      color: Color.fromARGB(255, 205, 27, 27),
                      fontWeight: FontWeight.bold))
            else if (isVerified && !isDispatched)
              Text(
                "Status : Verified",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              )
            else if (isDispatched)
              Text(
                "Status : Delivered",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )
            else
              Text(
                "Status : Under Process",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )
          ],
        )),
        children: [
          Container(
            child: Column(children: [
              if (isDispatched)
                Padding(
                  padding: EdgeInsets.only(bottom: height * 0.01),
                  child: Text(
                    "Delivered on :${deliveryDate} ",
                    style: TextStyle(
                        fontSize: height * 0.02, fontWeight: FontWeight.bold),
                  ),
                ),
              for (var i = 0; i < map.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: SizedBox(
                    width: widgth * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          map.keys.elementAt(i),
                          style: TextStyle(fontSize: height * 0.023),
                        ),
                        Text(" x " + map.values.elementAt(i).toString()),
                      ],
                    ),
                  ),
                )
            ]),
          )
        ],
      ),
    );
  }
}
