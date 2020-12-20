import 'dart:convert';

import 'package:bookstore/details.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  final Details details;

  const DetailScreen({Key key, this.details}) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List bookDetails;
  String titlecenter = "Loading Details...";
  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          widget.details.booktitle,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blue,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  child: CachedNetworkImage(
                imageUrl:
                    "http://slumberjer.com/bookdepo/bookcover/${widget.details.cover}.jpg",
                fit: BoxFit.none,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(
                  Icons.broken_image,
                ),
              )),
              SizedBox(height: 10),
              Container(
                color: Colors.white70,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                  child: Column(
                    children: [
                      Text("Book ID:" + widget.details.bookid),
                      Text("Book Author:" + widget.details.author),
                      Text("Book Price: RM" + widget.details.price),
                      Text("Book Description:" + widget.details.description),
                      Text("Book Rating:" + widget.details.rating),
                      Text("Book Publisher:" + widget.details.publisher),
                      Text("Book ISBN:" + widget.details.isbn),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadDetails() {
    print("Load Details Data");
    http.post("http://slumberjer.com/bookdepo/php/load_books.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        bookDetails = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); //decode json data
          bookDetails = jsondata["books"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
