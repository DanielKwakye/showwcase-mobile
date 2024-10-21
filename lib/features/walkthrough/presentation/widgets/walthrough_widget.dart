import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class WalkThroughWidget extends StatelessWidget {
  final Map<String, String> page;
  const WalkThroughWidget({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimationLimiter(
        child: AnimationConfiguration.synchronized(
            duration: const Duration(milliseconds: 500),
        child: Column(
          // duration: 700,
          // animationType: AnimationType.slideUp,
          children: <Widget>[
            const SizedBox(height: kToolbarHeight,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(page['title'] as String, textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),),
            ),
            const SizedBox(height: 10,),
            SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(page['subTitle'] as String,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary, height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),

            Expanded(child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                  padding:  const EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(page['image'] as String)),
                ),
              ),
            )
            ),

          ],
        )),
      ),
    );
  }
}
