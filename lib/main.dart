import 'dart:convert';
import 'package:apitest/webview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// Import for Android features.
import 'package:webview_flutter/webview_flutter.dart';
import 'model.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    theme: ThemeData.dark(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Model> list = <Model>[];
  String? text;
  final url =
      'https://api.edamam.com/search?q=chicken&app_id=06143f44&app_key=66f5ddd4c72ae635f3e46a0ca8c55766&from=0&to=100&health=alcohol-free';
  Future<void> getApiData() async {
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> json = jsonDecode(response.body);
    json['hits'].forEach((e) {
      Model model = Model(
        url: e['recipe']['url'],
        image: e['recipe']['image'],
        source: e['recipe']['source'],
        label: e['recipe']['label'],
        // other properties
      );
      setState(() {
        list.add(model);
      });
      // use the model object
    });
  }

  @override
  void initState() {
    super.initState();
    getApiData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('recipe'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (v) {
                  text = v;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Searchpage(
                                    search: text,
                                  )));
                    },
                    icon: Icon(Icons.search),
                  ),
                  hintText: "tìm kiếm công thức",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.green.withOpacity(0.04),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  primary: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebPage(
                                      url: x.url,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(x.image.toString()),
                        )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              height: 40,
                              color: Colors.grey.withOpacity(0.5),
                              child: Center(
                                child: Text(
                                  x.label.toString(),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(3),
                              height: 40,
                              color: Colors.grey.withOpacity(0.5),
                              child: Center(
                                child: Text(
                                  "Source: " + x.source.toString(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class WebPage extends StatelessWidget {
  final url;
  WebPage({this.url});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        initialUrl: url,
      ),
    );
  }
}

class Searchpage extends StatefulWidget {
  String? search;
  Searchpage({this.search});
  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  List<Model> list = <Model>[];
  String? text;

  Future<void> getApiData(search) async {
    final url =
        'https://api.edamam.com/search?q=${search}&app_id=06143f44&app_key=66f5ddd4c72ae635f3e46a0ca8c55766&from=0&to=100&health=alcohol-free';
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> json = jsonDecode(response.body);
    json['hits'].forEach((e) {
      Model model = Model(
        url: e['recipe']['url'],
        image: e['recipe']['image'],
        source: e['recipe']['source'],
        label: e['recipe']['label'],
        // other properties
      );
      setState(() {
        list.add(model);
      });
      // use the model object
    });
  }

  @override
  void initState() {
    super.initState();
    getApiData(widget.search);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('recipe'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  primary: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebPage(
                                      url: x.url,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(x.image.toString()),
                        )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              height: 40,
                              color: Colors.grey.withOpacity(0.5),
                              child: Center(
                                child: Text(
                                  x.label.toString(),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(3),
                              height: 40,
                              color: Colors.grey.withOpacity(0.5),
                              child: Center(
                                child: Text(
                                  "Source: " + x.source.toString(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
