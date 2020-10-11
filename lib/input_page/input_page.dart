import 'package:bmi_calculator/input_page/pacman_slider.dart';
import 'package:flutter/material.dart';

import 'appbar.dart';
import 'fade_route.dart';
import 'gender/gender.dart';
import 'gender/gender_card.dart';
import 'height/height_card.dart';
import 'input_page_styles.dart';
import 'input_summary_card.dart';
import 'result_page.dart';
import 'transition_dot.dart';
import 'weight/weight_card.dart';
import '../widget_utils.dart' show screenAwareSize;

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> with TickerProviderStateMixin {
  AnimationController _submitAnimationController;

  Gender gender = Gender.other;
  int height = 170;
  int weight = 70;

  @override
  void initState() {
    super.initState();
    _submitAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _submitAnimationController.addStatusListener((status) {
      //add a listener
      if (status == AnimationStatus.completed) {
        _goToResultPage().then((_) => _submitAnimationController
            .reset()); //reset controller when coming back
      }
    });
  }

  _goToResultPage() async {
    return Navigator.of(context).push(FadeRoute(
      //use the FadeRoute
      builder: (context) => ResultPage(
        weight: weight,
        height: height,
        gender: gender,
      ),
    ));
  }

  @override
  void dispose() {
    _submitAnimationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            child: BmiAppBar(),
            preferredSize: Size.fromHeight(appBarHeight(context)),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InputSummaryCard(
                  gender: gender,
                  weight: weight,
                  height: height,
                ),
                Expanded(child: _buildCards(context)),
                _buildBottom(context),
              ],
            ),
          ),
        ),
        TransitionDot(animation: _submitAnimationController),
      ],
    );
  }

  Widget _buildCards(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 14.0,
        right: 14.0,
        top: screenAwareSize(32.0, context),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: GenderCard(
                  gender: gender,
                  onChanged: (val) => setState(() => gender = val),
                )),
                Expanded(
                    child: WeightCard(
                  weight: weight,
                  onChanged: (val) => setState(() => weight = val),
                )),
              ],
            ),
          ),
          Expanded(
              child: HeightCard(
            height: height,
            onChanged: (val) => setState(() => height = val),
          ))
        ],
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenAwareSize(16.0, context),
        right: screenAwareSize(16.0, context),
        bottom: screenAwareSize(22.0, context),
        top: screenAwareSize(14.0, context),
      ),
      child: PacmanSlider(
        onSubmit: onPacmanSubmit,
        submitAnimationController: _submitAnimationController,
      ),
    );
  }

  void onPacmanSubmit() {
    _submitAnimationController.forward();
  }
}
