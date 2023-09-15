import 'package:cached_network_image/cached_network_image.dart';
import 'package:exam_consume_api/models/NewsHeadlinesModel.dart';
import 'package:exam_consume_api/view_models/news_view_model.dart';
import 'package:exam_consume_api/views/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, cnnNews, foxNews, googleNews, nbcNews }

class _HomeScreenState extends State<HomeScreen> {
  final NewsViewModel _newsViewModel = NewsViewModel();
  FilterList? selectedFilter;
  final dateFormat = DateFormat('dd MMMM yy');
  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategoriesScreen()));
          },
          icon: const Icon(
            Icons.apps_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          'News',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedFilter,
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ),
              onSelected: (FilterList item) {
                if (FilterList.bbcNews == item) {
                  name = 'bbc-news';
                } else if (FilterList.aryNews == item) {
                  name = 'al-jazeera-english';
                } else if (FilterList.cnnNews == item) {
                  name = 'cnn';
                } else if (FilterList.foxNews == item) {
                  name = 'fox-news';
                } else if (FilterList.googleNews == item) {
                  name = 'bbc-sport';
                } else if (FilterList.nbcNews == item) {
                  name = 'abc-news';
                }
                setState(() {
                  selectedFilter = item;
                });
              },
              itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
                    const PopupMenuItem<FilterList>(
                      value: FilterList.bbcNews,
                      child: Text('BBC News'),
                    ),
                    const PopupMenuItem<FilterList>(
                      value: FilterList.aryNews,
                      child: Text('Al-Jazeera English'),
                    ),
                    const PopupMenuItem<FilterList>(
                      value: FilterList.cnnNews,
                      child: Text('CNN'),
                    ),
                    const PopupMenuItem<FilterList>(
                      value: FilterList.foxNews,
                      child: Text('Fox News'),
                    ),
                    const PopupMenuItem<FilterList>(
                      value: FilterList.googleNews,
                      child: Text('BBC Sport'),
                    ),
                    const PopupMenuItem<FilterList>(
                      value: FilterList.nbcNews,
                      child: Text('ABC News'),
                    ),
                  ])
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.5,
              width: width,
              // color: Colors.blue.shade100,
              child: FutureBuilder<NewsHeadlinesModel>(
                future: _newsViewModel.fetchNewsHeadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        color: Colors.black,
                        size: 40,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: ((context, index) {
                        DateTime date = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        return SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: width * 0.9,
                                height: height,
                                padding: EdgeInsets.symmetric(
                                  horizontal: height * 0.02,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const Center(child: spinKit2),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: height * 0.01,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    height: height * 0.22,
                                    width: width * 0.7,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: height * 0.02,
                                      vertical: height * 0.01,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.blue.shade700),
                                            ),
                                            Text(
                                              dateFormat.format(date),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black
                                                      .withOpacity(0.7)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    );
                  }
                },
              ),
            ),
            Container(
              height: height - 150,
              child: FutureBuilder<NewsHeadlinesModel>(
                future: _newsViewModel.fetchNewsHeadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (ConnectionState.waiting == snapshot.connectionState) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime date = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
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
                                  imageUrl: snapshot
                                      .data!.articles![index].urlToImage
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
                                  errorWidget: (context, url, error) =>
                                      const Icon(
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
                                            snapshot.data!.articles![index]
                                                .source!.name
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
            )
          ],
        ),
      ),
    );
  }
}

const spinKit2 = SpinKitCircle(
  color: Colors.black,
  size: 40,
);
