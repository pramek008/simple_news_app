import 'package:cached_network_image/cached_network_image.dart';
import 'package:exam_consume_api/models/NewsCategoriesModel.dart';
import 'package:exam_consume_api/view_models/news_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final NewsViewModel _newsViewModel = NewsViewModel();

  final dateFormat = DateFormat('dd MMMM');
  String categoryName = 'general';

  List<String> categoriesList = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology'
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Widget categoriesBtn(String text) {
      return InkWell(
        onTap: () {
          setState(() {
            categoryName = text;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: categoryName == text ? Colors.blue : Colors.grey[300],
          ),
          child: Center(
            child: Text(
              text[0].toUpperCase() + text.substring(1).toLowerCase(),
              style: TextStyle(
                color: categoryName == text ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    Widget newsListTile() {
      return Container(
        height: height - 150,
        child: FutureBuilder<NewsCategoriesModel>(
          future: _newsViewModel.fetchNewsCategoriesApi(categoryName),
          builder: (BuildContext context, snapshot) {
            if (ConnectionState.waiting == snapshot.connectionState) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.articles!.length,
                itemBuilder: (context, index) {
                  DateTime date = DateTime.parse(
                      snapshot.data!.articles![index].publishedAt.toString());
                  return Container(
                    height: height * 0.2,
                    width: width,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data!.articles![index].urlToImage
                                .toString(),
                            fit: BoxFit.cover,
                            width: width * 0.3,
                            height: height * 0.2,
                            placeholder: (context, url) => const Center(
                              child: SpinKitCircle(
                                color: Colors.black,
                                size: 40,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error_outline_rounded,
                              size: 40,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Container(
                          width: width * 0.6,
                          // color: Colors.grey[300],
                          child: Column(
                            children: [
                              Text(
                                snapshot.data!.articles![index].title
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 3,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      snapshot
                                          .data!.articles![index].source!.name
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    dateFormat.format(date),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  return categoriesBtn(
                    categoriesList[index].toString(),
                  );
                },
              ),
            ),
            newsListTile(),
          ],
        ),
      ),
    );
  }
}
