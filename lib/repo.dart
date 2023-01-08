class Repo {
  String name;
  //String login; // hmtl_url
  //int id; //stargazers_count
  //String url;

  Repo({required this.name});

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
      //login: json['login'],
      //id: json['id'],
      //url: json['url'],
    );
  }
}

class All {
  List<Repo> repos;

  All({required this.repos});

  factory All.fromJson(List<dynamic> json) {
    List<Repo> repos = <Repo>[];
    repos = json.map((r) => Repo.fromJson(r)).toList();
    return All(repos: repos);
  }
}
