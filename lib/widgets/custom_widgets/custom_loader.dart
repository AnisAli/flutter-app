import '../../exports/index.dart';

class CustomLoader extends StatefulWidget {
  final double size;

  const CustomLoader({Key? key, this.size = 100}) : super(key: key);

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with TickerProviderStateMixin {
  late AnimationController rotationController;
  late AnimationController bouncingController;

  late Animation bouncingAnimation;
  late Animation shadowAnimation;

  bool touchedFloor = false;

  @override
  void initState() {
    startAnimation();
    super.initState();
  }

  @override
  void dispose() {
    rotationController.dispose();
    bouncingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          bouncingWidget(),
          shadowWidget(),
        ],
      ),
    );
  }

  Widget bouncingWidget() {
    return Transform.translate(
      offset: bouncingAnimation.value,
      child: rotatingWidget(),
    );
  }

  Widget rotatingWidget() {
    return AnimatedBuilder(
      animation: rotationController,
      child: AppLogo(size: widget.size),
      builder: (BuildContext context, widget) {
        return Transform.rotate(
          angle: rotationController.value,
          child: widget,
        );
      },
    );
  }

  Widget shadowWidget() {
    double shadowOpacity = shadowAnimation.value;
    Color shadowColor = Colors.black.withOpacity(touchedFloor ? 0.3 : 0.1);
    double shadowHeight = touchedFloor ? 0.005 : 0.25;
    double shadowWidth = widget.size / (touchedFloor ? 5 : 2.5);
    BoxDecoration shadowDecoration = BoxDecoration(
      color: shadowColor,
      borderRadius: BorderRadius.circular(360),
      boxShadow: [
        BoxShadow(color: shadowColor, blurRadius: 5, spreadRadius: 5)
      ],
    );

    return AnimatedOpacity(
      duration: shadowDuration,
      opacity: shadowOpacity,
      child: AnimatedContainer(
        height: shadowHeight,
        width: shadowWidth,
        duration: shadowDuration,
        decoration: shadowDecoration,
      ),
    );
  }

  void startAnimation() {
    rotationController =
        AnimationController(vsync: this, duration: rotationDuration);
    bouncingController =
        AnimationController(vsync: this, duration: shadowDuration);

    bouncingAnimation = Tween(
      begin: const Offset(0, 0),
      end: const Offset(0, -10.0),
    ).animate(bouncingController);
    shadowAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          curve: const Interval(0.4, 1.0), parent: bouncingController),
    );

    rotationController.addListener(() => setState(() {}));
    bouncingController.addListener(() => setState(() {}));

    rotationController.forward();
    bouncingController.forward();

    rotationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await rotationController.repeat();
      }
    });

    bouncingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        bouncingController.reverse();
        touchedFloor = !touchedFloor;
      } else if (status == AnimationStatus.dismissed) {
        touchedFloor = !touchedFloor;
        bouncingController.forward(from: 0.0);
      }
    });
  }

  static const Duration shadowDuration = Duration(milliseconds: 1000);
  static const Duration rotationDuration = Duration(milliseconds: 1000);
}
