import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:github_api/repo.dart';

Future<List<dynamic>>
getRepositories(String username) async{
  final response =  await http.get(Uri.parse('https://api.github.com/users/freeCodeCamp/repos'));
  if (response.statusCode==200){
    final repos = jsonDecode(response.body);
      List repo = [];
      for (int i = 0; i < repos.length; i++) {
        final commitResponse = await http.get(Uri.parse(
            'https://api.github.com/repos/freeCodeCamp/1Aug2015GameDev/commits'
        ));
        if (commitResponse.statusCode == 200) {
          final commits = jsonDecode(commitResponse.body);
          repos[i]['lastCommit'] = commits[0]['commit']['message'];
        }
        repo.add(
            [repos[i]['name'],repos[i]['id'].toString(),repos[i]['html_url'],repos[i]['description'],repos[i]['lastCommit']]
            //login: repos[i]['login'],
            //id: repos[i]['id'],
            //url: repos[i]['url'],
          );

      }
      return(repo);
    return repos;
  } else{
    throw Exception('Failed to get repositories');
  }
}

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'GitHub API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Repositories'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getRepositories('freeCodeCamp'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List? repos = snapshot.data;
            return ListView.builder(
                itemCount: repos?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name: "+
                              repos?[index][0],
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text("ID: "+
                              repos?[index][1],
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text("Description: "+
                              repos?[index][2],
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text("Last commit: "+
                              repos?[index][4],
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });


                } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}





