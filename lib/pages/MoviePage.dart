import 'dart:convert';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:jumbotron/types.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:webview_windows/webview_windows.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/services.dart';

Map<String, String> options = {
  'accept': 'application/json',
  'Authorization':
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZDZlMjU5NmJlNjJjOTVkNjFiYzUzNDMwMDlmZDBlNCIsInN1YiI6IjVmMGVlOGIxNWMwNzFiMDAzNDc0ZGQxYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SsMUeKvgSjpe531AmHp6mKRXRcurxahX25exIisqURM'
};

class MoviePage extends StatefulWidget {
  const MoviePage({super.key, required this.movie});
  final Movie movie;
  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final _youtube_controller = WebviewController();

  late Movie movie;
  String ageRating = '';
  bool downloadsLoading = false;
  final List torrentProviders = [
    '1337x',
    'torlock',
    'zooqle',
    'magnetdl',
    'tgx',
    'nyaasi',
    'piratebay',
    'bitsearch',
    'kickass',
    'limetorrent',
    'torrentfunk',
    'glodls',
    'torrentproject',
    'ybt'
  ];

  @override
  void initState() {
    initPlatformState();

    movie = widget.movie;
    http
        .get(
            Uri.parse(
                'https://api.themoviedb.org/3/movie/${widget.movie.id.toString()}?language=en-US'),
            headers: options)
        .then((value) {
      Map<String, dynamic> data = jsonDecode(value.body);
      setState(() {
        movie = Movie.fromJson(data);
      });
    });
    String rating = '';
    http
        .get(
            Uri.parse(
                'https://api.themoviedb.org/3/movie/${movie.id}/release_dates'),
            headers: options)
        .then((value) {
      Map data = jsonDecode(value.body);
      for (Map element in data['results']) {
        element['release_dates'].forEach((e) {
          if (e['certification'] != '') {
            rating = e['certification'];
          }
        });
        setState(() {
          ageRating = rating;
        });
      }
    });
    super.initState();
  }

  void initPlatformState() async {
    await _youtube_controller.initialize();
    await _youtube_controller.setBackgroundColor(Colors.transparent);
    await _youtube_controller
        .setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
    http
        .get(Uri.parse('https://api.themoviedb.org/3/movie/${movie.id}/videos'),
            headers: options)
        .then((value) {
      String youtubeId = '';
      jsonDecode(value.body)['results'].forEach((el) {
        print(el['site']);
        print(el['type']);
        if (el['site'] == 'YouTube' && el['type'] == 'Trailer') {
          youtubeId = el['key'];
          print(el);
        }
      });
      print(youtubeId);
      _youtube_controller.loadUrl('https://www.youtube.com/embed/$youtubeId');
    });
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(movie.runtime);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://image.tmdb.org/t/p/original/${widget.movie.backdrop_path}'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.black.withOpacity(.3),
                Colors.black.withOpacity(.9),
              ])),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 45,
                  ),
                  Flexible(
                    flex: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                                'https://image.tmdb.org/t/p/h632/${widget.movie.poster_path}'),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          flex: 7,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 30.0, sigmaY: 30.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Colors.grey[900]?.withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Overview",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Opacity(
                                            opacity: .9,
                                            child: SelectableText(
                                                '“${movie.tagline}”',
                                                style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 17)),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          SelectableText(widget.movie.overview,
                                              style: const TextStyle(
                                                  fontSize: 17)),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              for (var genre in movie.genres)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: Chip(
                                                    side: BorderSide.none,
                                                    backgroundColor: Colors
                                                        .grey[800]
                                                        ?.withOpacity(.5),
                                                    label: Text(genre['name']),
                                                  ),
                                                )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    movie.runtime,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text('Movie Length')
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${(movie.vote_average * 10).toInt()}%',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text('Movie Rating')
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    ageRating,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text('Age Rating')
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ))),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                            flex: 4,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 30.0, sigmaY: 30.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[900]
                                                ?.withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 200,
                                                width: 400,
                                                child: Card(
                                                    color: Colors.transparent,
                                                    elevation: 0,
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    child: Stack(
                                                      children: [
                                                        Webview(
                                                            _youtube_controller,
                                                            height: 200,
                                                            width: 400,
                                                            permissionRequested:
                                                                (String url,
                                                                    WebviewPermissionKind
                                                                        kind,
                                                                    bool
                                                                        isUserInitiated) {
                                                          return WebviewPermissionDecision
                                                              .deny;
                                                        }),
                                                        StreamBuilder<
                                                                LoadingState>(
                                                            stream:
                                                                _youtube_controller
                                                                    .loadingState,
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .hasData &&
                                                                  snapshot.data ==
                                                                      LoadingState
                                                                          .loading) {
                                                                return const LinearProgressIndicator();
                                                              } else {
                                                                return const SizedBox();
                                                              }
                                                            }),
                                                      ],
                                                    )),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              SizedBox(
                                                width: 500,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Dialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0)),
                                                                child: ReviewsPage(
                                                                    movie: widget
                                                                        .movie));
                                                          });
                                                    },
                                                    child: const Text(
                                                        'Read Reviews')),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              SizedBox(
                                                  width: 500,
                                                  child: OutlinedButton(
                                                      onPressed: () async {
                                                        final _controller =
                                                            WebviewController();
                                                        bool fullscreen = false;
                                                        await _controller
                                                            .initialize();
                                                        await _controller
                                                            .setBackgroundColor(
                                                                Colors
                                                                    .transparent);
                                                        await _controller
                                                            .setPopupWindowPolicy(
                                                                WebviewPopupWindowPolicy
                                                                    .deny);

                                                        await _controller
                                                            .loadStringContent(
                                                                '<style>html,body{width:100%,height:100%;margin:0;padding:0;}</style><iframe frameborder="0" src="https://2embed.skin/embed/${widget.movie.id}" width="100%" height="100%" frameborder="0" scrolling="no" allowfullscreen></iframe>');

                                                        await _controller
                                                            .executeScript(
                                                                'window.open = null');
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return StatefulBuilder(
                                                                  builder: (context,
                                                                      setState) {
                                                                _controller
                                                                    .containsFullScreenElementChanged
                                                                    .listen(
                                                                        (flag) async {
                                                                  print(_controller
                                                                      .containsFullScreenElementChanged);
                                                                  fullscreen =
                                                                      !fullscreen;
                                                                  await WindowManager
                                                                      .instance
                                                                      .setFullScreen(
                                                                    fullscreen,
                                                                  );
                                                                  setState(
                                                                      () {});
                                                                });
                                                                return Dialog
                                                                    .fullscreen(
                                                                        child: Stack(
                                                                            children: [
                                                                      Webview(
                                                                          _controller),
                                                                      if (fullscreen ==
                                                                          false) ...[
                                                                        Positioned(
                                                                            top:
                                                                                10,
                                                                            right:
                                                                                5,
                                                                            child: ElevatedButton.icon(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                icon: Icon(Icons.close),
                                                                                label: Text('Close'))),
                                                                      ],
                                                                    ]));
                                                              });
                                                            }).then((value) {
                                                          _controller.dispose();
                                                        });
                                                      },
                                                      child: const Text(
                                                          'Watch Online'))),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              FilledButton(
                                                style: ButtonStyle(
                                                    padding: MaterialStateProperty
                                                        .resolveWith((states) =>
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        0))),
                                                onPressed: downloadsLoading
                                                    ? null
                                                    : () {},
                                                child: DropdownButton(
                                                  isDense: true,
                                                  iconEnabledColor:
                                                      Colors.black87,
                                                  borderRadius:
                                                      BorderRadius.circular(19),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 8),
                                                  hint: !downloadsLoading
                                                      ? Text(
                                                          'Download',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87),
                                                        )
                                                      : const SizedBox(
                                                          height: 15,
                                                          width: 15,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          )),
                                                  isExpanded: true,
                                                  alignment: Alignment.center,
                                                  icon: Icon(Icons
                                                      .arrow_drop_down_sharp),
                                                  underline: Container(),
                                                  onChanged: downloadsLoading
                                                      ? null
                                                      : (value) {},
                                                  items: torrentProviders
                                                      .map((item) {
                                                    return DropdownMenuItem(
                                                        value: item,
                                                        onTap: () {
                                                          setState(() {
                                                            downloadsLoading =
                                                                true;
                                                          });
                                                          print(item);
                                                          http
                                                              .get(
                                                                  Uri.parse(
                                                                      'https://torrent-api.glitch.me/api/v1/search/?site=$item&query=${Uri.encodeFull(widget.movie.title)}&limit=10&page=1'),
                                                                  headers:
                                                                      options)
                                                              .then((value) {
                                                            Map data =
                                                                jsonDecode(
                                                                    value.body);
                                                            print(data);

                                                            setState(() {
                                                              downloadsLoading =
                                                                  false;
                                                            });
                                                            if (data['data'] ==
                                                                null) {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          'Request Failed'),
                                                                      content: Text(
                                                                          '${data['error']}'),
                                                                      actions: [
                                                                        FilledButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text('Close'))
                                                                      ],
                                                                    );
                                                                  });
                                                              return;
                                                            }
                                                            List movies = [];
                                                            data['data']
                                                                .forEach(
                                                                    (torrent) {
                                                              if (torrent['category'] !=
                                                                      null
                                                                  ? torrent['category']
                                                                          .toLowerCase() ==
                                                                      'movies'
                                                                  : true) {
                                                                movies.add(
                                                                    torrent);
                                                              }
                                                            });
                                                            data['data'] =
                                                                movies;
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return DownloadsPage(
                                                                      data: data[
                                                                          'data']);
                                                                });
                                                          });
                                                        },
                                                        child: Text(item));
                                                  }).toList(),
                                                ),
                                              )
                                            ],
                                          ),
                                        )))))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      widget.movie.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key, required this.movie});
  final Movie movie;
  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  List reviews = [];
  @override
  void initState() {
    http
        .get(
            Uri.parse(
                'https://api.themoviedb.org/3/movie/${widget.movie.id}/reviews'),
            headers: options)
        .then((value) {
      Map<String, dynamic> data = jsonDecode(value.body);
      setState(() {
        reviews = data['results'];
        print(data);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return SizedBox(
        width: constrains.maxWidth / 1.1,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: (Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reviews",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MasonryView(
                      listOfItem: reviews,
                      numberOfColumn: 2,
                      itemPadding: 1,
                      itemBuilder: (review) {
                        return SizedBox(
                          width: 300,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                          radius: 15,
                                          child: const Icon(Icons.person),
                                          foregroundImage: NetworkImage(
                                              (review['author_details']
                                                          ['avatar_path'] ??
                                                      '')
                                                  .replaceFirst('/', ''))),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(review['author'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(fontSize: 17)),
                                      const Spacer(),
                                      RatingBarIndicator(
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        rating: review['author_details']
                                                ['rating'] ??
                                            0,
                                        itemSize: 15,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.blueAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SelectableLinkify(
                                    onOpen: (link) =>
                                        launchUrl(Uri.parse(link.url)),
                                    text: review['content'],
                                    linkStyle: const TextStyle(
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.none),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                ])),
          ),
        ),
      );
    });
  }
}

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key, required this.data});
  final List data;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SizedBox(
              width: constrains.maxWidth / 1.1,
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(
                      'Downloads',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FixedColumnWidth(75),
                      },
                      children: [
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ))
                                ]),
                          ),
                          const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Size', style: TextStyle(fontSize: 20.0))
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    !data.isEmpty &&
                                            data[0]['downloads'] != null
                                        ? 'Date'
                                        : 'Downloads',
                                    style: const TextStyle(fontSize: 20.0))
                              ]),
                          const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Seeder/Leechers',
                                    style: TextStyle(fontSize: 20.0))
                              ]),
                          const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('', style: TextStyle(fontSize: 20.0))
                              ]),
                        ]),
                        for (Map download in data)
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8, right: 30),
                              child: SelectableText(
                                download['name'],
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  download['size'],
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                    download['downloads'] ?? download['date'])),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                    '${download['seeders'].toString()}/${download['leechers'].toString()}')),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: IconButton(
                                    onPressed: () {
                                      String link = download['magnet'] ??
                                          download['torrent'];
                                      Clipboard.setData(
                                          ClipboardData(text: link));
                                      launchUrl(Uri.parse(link));

                                      CherryToast.success(
                                        enableIconAnimation: false,
                                        backgroundColor: Colors.black54,
                                        animationType: AnimationType.fromBottom,
                                        toastPosition: Position.bottom,
                                        title: const Text("Link opened",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600)),
                                        shadowColor: Colors.black54,
                                        description: const Text(
                                            "The download link is also copied to your clipboard"),
                                      ).show(context);
                                    },
                                    icon: const Icon(Icons.download_rounded)))
                          ]),
                      ],
                    ),
                  ]))),
        ),
      );
    });
  }
}
