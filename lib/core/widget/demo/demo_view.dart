import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:reusekit/core.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

extension AppExampleViewStringExtension on String {
  String titleName() {
    //eg. Instance of 'InstructorDetail'
    // to Instructor Detail
    var value = this;
    if (value.indexOf('Instance of') != -1) {
      value = value.replaceAll('Instance of ', '');
    }
    value = value.replaceAll("'", "");
    return value;
  }
}

class DemoView extends StatelessWidget {
  final List<Map> items;
  final String title;
  final Function(String)? onReport;
  final Function(String)? onCheck;
  final bool reviewModeEnabled;
  const DemoView({
    super.key,
    required this.items,
    required this.title,
    this.onReport,
    this.onCheck,
    this.reviewModeEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    int allItemsCount = 0;

    for (var group in items) {
      allItemsCount += (group["items"] as List).length;
    }

    int itemIndex = 0;
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      bool isTablet = MediaQuery.of(context).size.width < 1100 &&
          MediaQuery.of(context).size.width >= 850;
      bool isDesktop = MediaQuery.of(context).size.width >= 1100;
      bool isMobile = MediaQuery.of(context).size.width < 850;
      return Scaffold(
        appBar: AppBar(
          title: Text("$title"),
          actions: [
            if (Platform.isWindows)
              InkWell(
                onTap: () async {
                  //Screenshot all items
                  var totalGroupItems = allItemsCount;
                  var indexc = 0;

                  for (var group in items) {
                    var groupItems = group["items"] as List<NavigationMenu>;
                    Directory("output").deleteSync(recursive: true);
                    if (Directory("output").existsSync() == false) {
                      Directory("output").createSync(recursive: true);
                    }

                    for (var it in groupItems) {
                      indexc++;
                      var index = groupItems.indexOf(it);
                      print(
                          "[$indexc / $allItemsCount] >>> Opening ${it.label} @ ${index + 1}/${groupItems.length}");
                      WidgetsToImageController controller =
                          WidgetsToImageController();
                      Widget view = WidgetsToImage(
                        controller: controller,
                        child: it.view!,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => view!,
                        ),
                      );

                      await Future.delayed(Duration(milliseconds: 1500));

                      controller.capture().then((image) {
                        print("Capture Done!");

                        var name = it.label;
                        //save image to output/{name}.png
                        File file =
                            File("output/${name.replaceAll(' ', '_')}.png");

                        file.writeAsBytes(image!);
                      });

                      await Future.delayed(Duration(milliseconds: 500));

                      //Screenshot current screen

                      await Future.delayed(Duration(milliseconds: 250));
                      Navigator.pop(context);
                    }
                  }
                },
                child: Icon(
                  Icons.screenshot,
                  size: 24.0,
                ),
              ),
            InkWell(
              onTap: () async {
                var totalGroupItems = allItemsCount;
                var indexc = 0;
                for (var group in items) {
                  var groupItems = group["items"] as List<NavigationMenu>;

                  for (var it in groupItems) {
                    indexc++;
                    var index = groupItems.indexOf(it);
                    print(
                        "[$indexc / $allItemsCount] >>> Opening ${it.label} @ ${index + 1}/${groupItems.length}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => it.view!,
                      ),
                    );
                    await Future.delayed(Duration(milliseconds: 250));
                    Navigator.pop(context);
                  }
                }
              },
              child: Icon(
                Icons.play_circle_outline_outlined,
                size: 24.0,
              ),
            ),
            const SizedBox(
              width: 12.0,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: spMd,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spMd),
                child: QDialog(
                  message: "https://tinyurl.com/reusekit",
                  color: primaryColor,
                ),
              ),
              SizedBox(height: spMd),
              ...items.map(
                (group) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: spMd,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: spSm,
                        children: [
                          Expanded(
                            child: Text(
                              group["group"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (Platform.isWindows)
                            InkWell(
                              onTap: () async {
                                var groupItems =
                                    group["items"] as List<NavigationMenu>;

                                for (var it in groupItems) {
                                  var index = groupItems.indexOf(it);
                                  print(
                                      "Opening ${it.label} @ ${index + 1}/${groupItems.length}");

                                  WidgetsToImageController controller =
                                      WidgetsToImageController();
                                  Widget view = WidgetsToImage(
                                    controller: controller,
                                    child: it.view!,
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => view!,
                                    ),
                                  );

                                  await Future.delayed(
                                      Duration(milliseconds: 1500));

                                  controller.capture().then((image) {
                                    print("Capture Done!");
                                    if (Directory("output").existsSync() ==
                                        false) {
                                      Directory("output")
                                          .createSync(recursive: true);
                                    }

                                    var name = it.label;
                                    //save image to output/{name}.png
                                    File file = File(
                                        "output/${name.replaceAll(' ', '_')}.png");

                                    file.writeAsBytes(image!);
                                  });

                                  await Future.delayed(
                                      Duration(milliseconds: 500));

                                  //Screenshot current screen

                                  await Future.delayed(
                                      Duration(milliseconds: 250));
                                  Navigator.pop(context);
                                }
                              },
                              child: Icon(
                                Icons.screenshot,
                                color: Colors.orange,
                                size: 24.0,
                              ),
                            ),
                          InkWell(
                            onTap: () async {
                              var groupItems =
                                  group["items"] as List<NavigationMenu>;

                              for (var it in groupItems) {
                                var index = groupItems.indexOf(it);
                                print(
                                    "Opening ${it.label} @ ${index + 1}/${groupItems.length}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => it.view!),
                                );
                                await Future.delayed(
                                    Duration(milliseconds: 1000));
                                Navigator.pop(context);
                              }
                            },
                            child: Icon(
                              Icons.play_circle_filled,
                              color: infoColor,
                              size: 24.0,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              var groupItems =
                                  group["items"] as List<NavigationMenu>;

                              for (var it in groupItems) {
                                var index = groupItems.indexOf(it);
                                print(
                                    "Opening ${it.label} @ ${index + 1}/${groupItems.length}");

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => it.view!),
                                );

                                //Screenshot current screen

                                await Future.delayed(
                                    Duration(milliseconds: 250));
                                Navigator.pop(context);
                              }
                            },
                            child: Icon(
                              Icons.play_circle_fill,
                              color: warningColor,
                              size: 24.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ResponsiveGridView(
                      minItemWidth: 220,
                      children: [
                        ...(group["items"] as List).map(
                          (item) {
                            var name = item.label;
                            var index = group["items"].indexOf(item);
                            name =
                                name.toString().replaceAll(group["prefix"], "");
                            name = name.replaceAll("View", "");
                            itemIndex++;

                            if (name[0] == "R" && name[1] == "K") {
                              name = name.substring(2);
                            }
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              padding: EdgeInsets.all(spSm),
                              child: InkWell(
                                onTap: () {
                                  Widget child = item.view;

                                  if (!isMobile) {
                                    child = Scaffold(
                                      backgroundColor: Colors.grey[200],
                                      body: Container(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: spMd,
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                spacing: spSm,
                                                children: [
                                                  QButton(
                                                    label: "Back",
                                                    color: infoColor,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  QButton(
                                                    label: "Copy code",
                                                    color: infoColor,
                                                    onPressed: () {
                                                      const snackBar = SnackBar(
                                                        content:
                                                            Text('Coming soon'),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    },
                                                  ),
                                                  QButton(
                                                    label: "Overflow issues",
                                                    color: warningColor,
                                                    onPressed: () {
                                                      const snackBar = SnackBar(
                                                        content: Text(
                                                            'Thanks for your feedback!'),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    },
                                                  ),
                                                  QButton(
                                                    label: "Missing Images",
                                                    color: warningColor,
                                                    onPressed: () {
                                                      const snackBar = SnackBar(
                                                        content: Text(
                                                            'Thanks for your feedback!'),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 40.0,
                                                      left: 8.0,
                                                      right: 8.0,
                                                      bottom: 8.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(12.0),
                                                      ),
                                                    ),
                                                    child: Container(
                                                      width:
                                                          constraints.maxWidth *
                                                              0.3,
                                                      child: item.view,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Column(
                                        children: [
                                          Expanded(
                                            child: child!,
                                          ),
                                          if (reviewModeEnabled)
                                            Material(
                                              child: Container(
                                                padding: EdgeInsets.all(4.0),
                                                color: Colors.orange[900]!,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  spacing: spSm,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        if (Navigator.canPop(
                                                            context)) {
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Icons.arrow_back,
                                                        size: 24.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        if (Navigator.canPop(
                                                            context)) {
                                                          onReport?.call(child
                                                              .toString()
                                                              .titleName());
                                                          Navigator.pop(
                                                              context);
                                                          const snackBar =
                                                              SnackBar(
                                                            content: Text(
                                                                'Report submitted!'),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .hideCurrentSnackBar();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Icons.report,
                                                        size: 24.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        if (Navigator.canPop(
                                                            context)) {
                                                          onCheck?.call(child
                                                              .toString()
                                                              .titleName());
                                                          Navigator.pop(
                                                              context);

                                                          const snackBar =
                                                              SnackBar(
                                                            content: Text(
                                                                'Issue resolved!'),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .hideCurrentSnackBar();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Icons.check,
                                                        size: 24.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  spacing: spSm,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: item.badgeCount != null &&
                                                item.badgeCount! > 0
                                            ? dangerColor
                                            : primaryColor,
                                      ),
                                      child: Text(
                                        "${itemIndex}",
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${name}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
