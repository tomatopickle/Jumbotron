import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:http/http.dart' as http;
import 'package:jumbotron/pages/MoviePage.dart';
import './types.dart';
import 'dart:ui';
import 'package:skeletons/skeletons.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(900, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    title: 'Jumbotron',
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.maximize();
    await windowManager.focus();
  });

  // Add this your main method.
  // used to show a webview title bar.
  if (runWebViewTitleBarWidget(args, backgroundColor: Colors.black)) {
    return;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: FlexThemeData.light(
        scheme: FlexScheme.blue,
        surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
        blendLevel: 2,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          blendTextTheme: true,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          outlinedButtonOutlineSchemeColor: SchemeColor.primary,
          outlinedButtonPressedBorderWidth: 2.0,
          toggleButtonsBorderSchemeColor: SchemeColor.primary,
          segmentedButtonSchemeColor: SchemeColor.primary,
          segmentedButtonBorderSchemeColor: SchemeColor.primary,
          unselectedToggleIsColored: true,
          sliderValueTinted: true,
          inputDecoratorSchemeColor: SchemeColor.primary,
          inputDecoratorBackgroundAlpha: 21,
          inputDecoratorRadius: 12.0,
          inputDecoratorUnfocusedHasBorder: false,
          inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
          popupMenuRadius: 6.0,
          popupMenuElevation: 8.0,
          drawerIndicatorSchemeColor: SchemeColor.primary,
          bottomNavigationBarMutedUnselectedLabel: false,
          bottomNavigationBarMutedUnselectedIcon: false,
          menuRadius: 6.0,
          menuElevation: 8.0,
          menuBarRadius: 0.0,
          menuBarElevation: 1.0,
          navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
          navigationBarMutedUnselectedLabel: false,
          navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
          navigationBarMutedUnselectedIcon: false,
          navigationBarIndicatorSchemeColor: SchemeColor.primary,
          navigationBarIndicatorOpacity: 1.00,
          navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
          navigationRailMutedUnselectedLabel: false,
          navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
          navigationRailMutedUnselectedIcon: false,
          navigationRailIndicatorSchemeColor: SchemeColor.primary,
          navigationRailIndicatorOpacity: 1.00,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.blue,
        surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
        blendLevel: 8,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 8,
          blendTextTheme: true,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          outlinedButtonOutlineSchemeColor: SchemeColor.primary,
          outlinedButtonPressedBorderWidth: 2.0,
          toggleButtonsBorderSchemeColor: SchemeColor.primary,
          segmentedButtonSchemeColor: SchemeColor.primary,
          segmentedButtonBorderSchemeColor: SchemeColor.primary,
          unselectedToggleIsColored: true,
          sliderValueTinted: true,
          inputDecoratorSchemeColor: SchemeColor.primary,
          inputDecoratorBackgroundAlpha: 43,
          inputDecoratorRadius: 12.0,
          inputDecoratorUnfocusedHasBorder: false,
          popupMenuRadius: 6.0,
          popupMenuElevation: 8.0,
          drawerIndicatorSchemeColor: SchemeColor.primary,
          bottomNavigationBarMutedUnselectedLabel: false,
          bottomNavigationBarMutedUnselectedIcon: false,
          menuRadius: 6.0,
          menuElevation: 8.0,
          menuBarRadius: 0.0,
          menuBarElevation: 1.0,
          navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
          navigationBarMutedUnselectedLabel: false,
          navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
          navigationBarMutedUnselectedIcon: false,
          navigationBarIndicatorSchemeColor: SchemeColor.primary,
          navigationBarIndicatorOpacity: 1.00,
          navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
          navigationRailMutedUnselectedLabel: false,
          navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
          navigationRailMutedUnselectedIcon: false,
          navigationRailIndicatorSchemeColor: SchemeColor.primary,
          navigationRailIndicatorOpacity: 1.00,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String> options = {
    'accept': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZDZlMjU5NmJlNjJjOTVkNjFiYzUzNDMwMDlmZDBlNCIsInN1YiI6IjVmMGVlOGIxNWMwNzFiMDAzNDc0ZGQxYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SsMUeKvgSjpe531AmHp6mKRXRcurxahX25exIisqURM'
  };
  List trending = [];
  bool searching = false;
  void initState() {
    loadTrending();
    super.initState();
  }

  void loadTrending() async {
    var text = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc'),
        headers: options);
    print(text.body);
    jsonDecode(text.body)['results'].forEach((el) {
      if (el['vote_average'] != 0) {
        trending.add(Movie.fromJson(el));
      } else {
        print(el);
      }
    });
    print(trending);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jumbotron')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                  child: FractionallySizedBox(
                      widthFactor: .6,
                      child: TextField(
                        onSubmitted: (value) async {
                          trending = [];
                          searching = true;
                          var text = await http.get(
                              Uri.parse(
                                  'https://api.themoviedb.org/3/search/movie?query=$value&include_adult=false&language=en-US&page=1'),
                              headers: options);
                          print(text.body);
                          jsonDecode(text.body)['results'].forEach((el) {
                            if (el['vote_average'] != 0) {
                              trending.add(Movie.fromJson(el));
                            }
                          });
                          print(trending);
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search_rounded),
                            hintText: 'Search Movies'),
                      ))),
              const SizedBox(
                height: 30,
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Text(
                    searching ? 'Results' : 'Trending',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const Spacer(),
                  if (searching) ...[
                    OutlinedButton.icon(
                        onPressed: () {
                          searching = false;
                          trending = [];
                          loadTrending();
                        },
                        icon: const Icon(Icons.close_rounded),
                        label: const Text("Clear Search"))
                  ]
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                runSpacing: 15,
                children: [
                  for (Movie movie in trending)
                    Tooltip(
                      richMessage: WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            constraints: const BoxConstraints(maxWidth: 250),
                            child: Text(
                              movie.overview,
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                      preferBelow: false,
                      verticalOffset: 150,
                      waitDuration: const Duration(seconds: 1),
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MoviePage(movie: movie);
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          'https://image.tmdb.org/t/p/h632/${movie.poster_path}',
                                          width: 170,
                                          fit: BoxFit.fitWidth,
                                          errorBuilder:
                                              (context, error, stacktrace) {
                                            return const SizedBox(
                                              height: 250,
                                              width: 170,
                                              child: Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                size: 24,
                                              ),
                                            );
                                          },
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress != null) {
                                              return const SkeletonAvatar(
                                                  style: SkeletonAvatarStyle(
                                                shape: BoxShape.rectangle,
                                                width: 170,
                                                height: 250,
                                              ));
                                            } else {
                                              return child;
                                            }
                                          },
                                        )),
                                    Positioned(
                                      bottom: -10,
                                      right: -5,
                                      child: ClipOval(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10.0, sigmaY: 10.0),
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey[900]
                                                    ?.withOpacity(0.9)),
                                            child: Text(
                                              (movie.vote_average * 10)
                                                  .toInt()
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 170,
                                  child: Text(movie.title,
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600)),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Opacity(
                                    opacity: .8,
                                    child: Text(movie.release_date))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
