import '../../exports/index.dart';

class CounterView extends StatefulWidget {
  late RxDouble initNumber;
  final VoidCallback? onTap;
  final Function(double) counterCallback;
  CounterView({
    super.key,
    required this.initNumber,
    required this.counterCallback,
    required this.onTap,
  });
  @override
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  late Function _counterCallback;
  late TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    _counterCallback = widget.counterCallback;
    quantityController.text = widget.initNumber.string;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createIncrementDecrementButton(CupertinoIcons.minus,
              () => _decrement(dec: widget.initNumber.value - 1)),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 35,
              alignment: Alignment.center,
              color: context.scaffoldBackgroundColor,
              child: Obx(
                () => InkWell(
                  onTap: widget.onTap,
                  child: Text(
                    widget.initNumber.toStringAsFixed(1),
                    style: context.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
              ),
          _createIncrementDecrementButton(CupertinoIcons.add,
              () => _increment(inc: widget.initNumber.value + 1)),
        ],
      ),
    );
  }

  void _increment({double inc = 1}) {
    widget.initNumber.value = inc;
    quantityController.text = widget.initNumber.string;
    _counterCallback(widget.initNumber.value);
  }

  void _decrement({double dec = 1}) {
    widget.initNumber.value = dec;
    quantityController.text = widget.initNumber.string;
    _counterCallback(widget.initNumber.value);
  }

  Widget _createIncrementDecrementButton(IconData icon, Function()? onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: DarkTheme.darkShade3,
          size: Sizes.ICON_SIZE_20,
        ),
      ),
    );
  }
}
