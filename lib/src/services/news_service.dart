import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
final _UrlNews = 'https://newsapi.org/v2';
// ignore: non_constant_identifier_names
final _ApiKey = '5a035b12a0014099a37c635437c4053b';

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  String _selectedCategory = 'business';

  List<Catergory> categories = [
    Catergory(FontAwesomeIcons.businessTime, 'business'),
    Catergory(FontAwesomeIcons.tv, 'entertainment'),
    Catergory(FontAwesomeIcons.addressCard, 'general'),
    Catergory(FontAwesomeIcons.headSideVirus, 'health'),
    Catergory(FontAwesomeIcons.vials, 'science'),
    Catergory(FontAwesomeIcons.volleyballBall, 'sports'),
    Catergory(FontAwesomeIcons.memory, 'technology'),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadlines();
    categories.forEach((item) {
      this.categoryArticles[item.name] = new List();
    });
  }

  get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor) {
    this._selectedCategory = valor;
    this.getArticlesByCategory(valor);

    notifyListeners();
  }

  List<Article> get getArticulosCategoria => this.categoryArticles[this.selectedCategory];

  getTopHeadlines() async {
    final url = '$_UrlNews/top-headlines?apiKey=$_ApiKey&country=co';

    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson(resp.body);

    this.headlines.addAll(newsResponse.articles);

    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    if (this.categoryArticles[category].length > 0) {
      return this.categoryArticles[category];
    }

    final url =
        '$_UrlNews/top-headlines?apiKey=$_ApiKey&country=co&category=$category';

    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson(resp.body);

    this.categoryArticles[category].addAll(newsResponse.articles);

    notifyListeners();
  }
}
