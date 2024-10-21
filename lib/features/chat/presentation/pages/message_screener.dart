import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/sliver_appbar_tabbar_delegate.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/chat/presentation/widgets/new_screener_widget.dart';
import 'package:showwcase_v3/features/chat/presentation/widgets/rejected_screener_widget.dart';


class MessageScreener extends StatefulWidget {
  const MessageScreener({Key? key}) : super(key: key);

  @override
  State<MessageScreener> createState() => _MessageScreenerState();
}

class _MessageScreenerState extends State<MessageScreener> with TickerProviderStateMixin{
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: ExtendedNestedScrollView(
          floatHeaderSlivers: true,
          onlyOneScrollInBody: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: theme.colorScheme.background,
                iconTheme: IconThemeData(
                  color: theme.colorScheme.onBackground,
                ),
                title: Text(
                  'Message Screener',
                  style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w700,fontSize: defaultFontSize ),
                ),
                centerTitle: true,
                actions:  [
                  // const SizedBox(width: 5.0,),
                  //  Tooltip(
                  //    message:,
                  //      waitDuration: Duration(seconds: 1),
                  //      showDuration: Duration(seconds: 2),
                  //      padding: EdgeInsets.all(12),
                  //      height: 35,
                  //      verticalOffset: 100,
                  //      preferBelow: true,
                  //      child: ),
                  Builder(builder: (ctx) {
                    return IconButton(onPressed: () {
                      showPopover(
                        context: ctx,
                        bodyBuilder: (ctx) =>  Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                              'The people below are messaging you for the first time. You can decide if you want to bring them into your Messages. Click Accept to add them in. Click Reject to move them to your Discard History.',
                            style: TextStyle(color: theme.colorScheme.onBackground, height: 1.5),
                          ),
                        ),
                        direction: PopoverDirection.bottom,
                        backgroundColor: theme.brightness == Brightness.dark ? theme.colorScheme.surface : theme.colorScheme.background,
                        width: MediaQuery.of(context).size.width * 0.7,
                        // arrowDxOffset:  -20,
                        arrowHeight: 0,
                        arrowWidth: 0
                        // height: 200,
                        // arrowHeight: 15,
                        // arrowWidth: 30,
                      );
                    },  icon: const Icon(Icons.help_outline,size: 18,));
                  }),
                  // const SizedBox(width: 15.0,),
                ],
              ),
              // SliverToBoxAdapter(
              //     child: Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'The people below are messaging you for the first time. You can decide if you want to bring them into your Messages. Click Accept to add them in. Click Reject to move them to your Discard History.',
              //         style: TextStyle(
              //             color: theme.colorScheme.onPrimary,
              //             fontWeight: FontWeight.w400),
              //       ),
              //     ],
              //   ),
              // )),
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarTabBarDelegate(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                    tabBar: TabBar(
                     // isScrollable: true,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      indicator:  const UnderlineTabIndicator(
                          insets: EdgeInsets.only(
                            left: 0,
                            right: 20,
                            bottom: 0,
                          ),
                          borderSide: BorderSide(color: kAppBlue, width: 2)),
                      labelPadding: const EdgeInsets.only(left: 0, right: 20),
                      controller: tabController,
                      labelColor: theme.colorScheme.onBackground,
                      tabs: const [
                        Tab(
                          child: Text(
                           'New',
                            style: TextStyle(
                                fontSize: defaultFontSize  ,
                                fontWeight: FontWeight.w600),
                          ),),
                        Tab(
                          child: Text(
                           'Discard History',
                            style: TextStyle(
                                fontSize: defaultFontSize  ,
                                fontWeight: FontWeight.w600),
                          ),),
                      ],
                    )),
              ),
            ];
          },
          body: TabBarView(
              controller: tabController,
              children: const [
                NewScreener(),
                RejectedScreener()

                ])



          ),
    );
  }
}
