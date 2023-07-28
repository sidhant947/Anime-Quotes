import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ApiConstants {
  static String baseUrl = 'https://animechan.xyz/api';
  static String AnimesEndpoint = '/quotes';
}

class ApiService {
  Future<List<AnimeModel>?> getAnimes() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.AnimesEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<AnimeModel> _model = AnimeModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

class Anime extends StatefulWidget {
  const Anime({super.key});

  @override
  State<Anime> createState() => _AnimeState();
}

class _AnimeState extends State<Anime> {
  late List<AnimeModel>? _AnimeModel = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _AnimeModel = (await ApiService().getAnimes())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anime Quotes"),
        centerTitle: true,
      ),
      body: _AnimeModel == null || _AnimeModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _AnimeModel!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 113, 142, 145),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  _AnimeModel![index].quote.toString(),
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 20),
                                ),
                                Text(
                                  'by ' +
                                      _AnimeModel![index].character.toString(),
                                  style: TextStyle(
                                      textBaseline: TextBaseline.alphabetic,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'from ' +
                                      _AnimeModel![index].anime.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    // Text(_AnimeModel![index].quote.toString()),
                    // Text(_AnimeModel![index].anime.toString()),
                  ],
                );
              },
            ),
    );
  }
}

List<AnimeModel> AnimeModelFromJson(String str) =>
    List<AnimeModel>.from(json.decode(str).map((x) => AnimeModel.fromJson(x)));

String AnimeModelToJson(List<AnimeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnimeModel {
  String? anime;
  String? character;
  String? quote;

  AnimeModel({this.anime, this.character, this.quote});

  AnimeModel.fromJson(Map<String, dynamic> json) {
    anime = json['anime'];
    character = json['character'];
    quote = json['quote'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['anime'] = this.anime;
    data['character'] = this.character;
    data['quote'] = this.quote;
    return data;
  }
}
