import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/theme.dart';
import 'package:flutter_login/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:login_example/DataObjects/FundDetails.dart';
import 'package:login_example/DataObjects/MemberDetails.dart';
import 'package:login_example/constants.dart';
import 'package:login_example/transition_route_observer.dart';
import 'package:login_example/widgets/animated_numeric_text.dart';
import 'package:login_example/widgets/fade_in.dart';
import 'package:login_example/widgets/round_button.dart';

import 'dashboard_screen.dart';

class FundsScreen extends StatefulWidget {
  static const routeName = '/funds';
  final emailId, memberId;
  final double memberBalance;
  const FundsScreen({Key? key, required this.emailId, required this.memberId,
    required this.memberBalance}) : super(key: key);

  @override
  _FundsScreenState createState() => _FundsScreenState();
}

class _FundsScreenState extends State<FundsScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/auth')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  List<Funds> fundsList = [];
  late Future<Funds> futureFunds;
  Future<Funds> getFunds() async {
    String url =
        'http://127.0.0.1:8085/api/v1/fund/b66fd36b-922b-486e-b679-973f2ad85e05';
    final fundResponse = await http.get(Uri.parse(url));
    if (fundResponse.statusCode == 200) {
      return Funds.fromJson(
          jsonDecode(fundResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load funds');
    }
  }

  final routeObserver = TransitionRouteObserver<PageRoute?>();
  static const headerAniInterval = Interval(.1, .3, curve: Curves.easeOut);
  late Animation<double> _headerScaleAnimation;
  AnimationController? _loadingController;

  @override
  void initState() {
    super.initState();
    futureFunds = getFunds();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation = Tween<double>(begin: .6, end: 1).animate(
      CurvedAnimation(
        parent: _loadingController!,
        curve: headerAniInterval,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
      this,
      ModalRoute.of(context) as PageRoute<dynamic>?,
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController!.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController!.forward();

  AppBar _buildAppBar(ThemeData theme) {
    final menuBtn = IconButton(
      color: theme.colorScheme.secondary,
      icon: const Icon(FontAwesomeIcons.bars),
      onPressed: () {},
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.rightFromBracket),
      color: theme.colorScheme.secondary,
      onPressed: () => _goToLogin(context),
    );
    final title = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Hero(
              tag: Constants.logoTag,
              child: Image.asset(
                'assets/images/moneyshadow_1.png',
                filterQuality: FilterQuality.high,
                height: 30,
              ),
            ),
          ),
          HeroText(
            Constants.appName,
            tag: Constants.titleTag,
            viewState: ViewState.shrunk,
            style: LoginThemeHelper.loginTextStyle,
          ),
          const SizedBox(width: 20),
        ],
      ),
    );

    return AppBar(
      leading: FadeIn(
        controller: _loadingController,
        offset: .3,
        curve: headerAniInterval,
        child: menuBtn,
      ),
      actions: <Widget>[
        FadeIn(
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
          child: signOutBtn,
        ),
      ],
      title: title,
      backgroundColor: theme.primaryColor.withOpacity(.1),
      elevation: 0,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final primaryColor =
        Colors.primaries.where((c) => c == theme.primaryColor).first;
    final accentColor =
        Colors.primaries.where((c) => c == theme.colorScheme.secondary).first;
    final linearGradient = LinearGradient(
      colors: [
        primaryColor.shade800,
        primaryColor.shade200,
      ],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 418.0, 78.0));

    return ScaleTransition(
      scale: _headerScaleAnimation,
      child: FadeIn(
        controller: _loadingController,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.bottomToTop,
        offset: .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'ZAR',
                  style: theme.textTheme.headline3!.copyWith(
                    fontWeight: FontWeight.w300,
                    color: accentColor.shade400,
                  ),
                ),
                const SizedBox(width: 5),
                AnimatedNumericText(
                  initialValue: 0,
                  targetValue: widget.memberBalance,
                  curve: const Interval(0, .5, curve: Curves.easeOut),
                  controller: _loadingController!,
                  style: theme.textTheme.headline3!.copyWith(
                    foreground: Paint()..shader = linearGradient,
                  ),
                ),
              ],
            ),
            Text('Account Balance', style: theme.textTheme.caption),
          ],
        ),
      ),
    );
  }


  Widget _buildDebugButtons() {
    const textStyle = TextStyle(fontSize: 12, color: Colors.white);

    return Positioned(
      bottom: 0,
      right: 0,
      child: Row(
        children: <Widget>[
        ],
      ),
    );
  }

  DataTable _createDataTable(
      String name,
      String capital,
      String capacity,
      String duration,
      String contribution,
      String agentCommission,
      String minimumBiddingPercentage,
      String status) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Fund Details',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Fund name: $name')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Monthly capital: $capital')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Capacity (members count): $capacity'))
          ],
        ),
        DataRow(
          cells: <DataCell>[DataCell(Text('Fund duration: $duration'))],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Monthly contribution: $contribution'))
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Agent commission %ge: $agentCommission'))
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Min bidding %ge: $minimumBiddingPercentage'))
          ],
        ),
        DataRow(
          cells: <DataCell>[DataCell(Text('Status: $status'))],
        ),
      ],
    );
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.red,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () => _goToLogin(context),
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(theme),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor.withOpacity(.1),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 40),
                    Expanded(
                      flex: 2,
                      child: _buildHeader(theme),
                    ),
                    Expanded(
                      flex: 8,
                      child: ShaderMask(
                        // blendMode: BlendMode.srcOver,
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Colors.deepPurpleAccent.shade100,
                              Colors.deepPurple.shade100,
                              Colors.deepPurple.shade100,
                              Colors.deepPurple.shade100,
                            ],
                          ).createShader(bounds);
                        },
                        // child: _buildDashboardGrid(),
                        child: FutureBuilder<Funds>(
                          future: futureFunds,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return _createDataTable(
                                snapshot.data!.name,
                                snapshot.data!.capital,
                                snapshot.data!.capacity,
                                snapshot.data!.duration,
                                snapshot.data!.contribution,
                                snapshot.data!.agentCommission,
                                snapshot.data!.minimumBiddingPercentage,
                                snapshot.data!.status,
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}',);
                            }
                            return CircularProgressIndicator();
                          },
                          // ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.focused))
                            return Colors.red;
                          if (states.contains(MaterialState.hovered))
                            return Colors.green;
                          if (states.contains(MaterialState.pressed))
                            return Colors.blue;
                          return null; // Defer to the widget's default.
                        },),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardScreen(emailId: widget.emailId, memberId: widget.memberId,),),);
                      },
                      child: Text('Back to dashboard'),
                    ),),
                  ],
                ),
                if (!kReleaseMode) _buildDebugButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
