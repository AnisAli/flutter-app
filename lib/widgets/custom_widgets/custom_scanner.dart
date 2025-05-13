import 'dart:math';
import '../../exports/index.dart';

class CustomBarcodeQRScanner extends StatefulWidget {
  final bool showQrScanner;
  final bool torchEnabled;
  final CameraFacing cameraFace;
  final Function(BarcodeCapture capture) onDetect;

  const CustomBarcodeQRScanner({
    Key? key,
    this.showQrScanner = false,
    this.torchEnabled = false,
    this.cameraFace = CameraFacing.back,
    required this.onDetect,
  }) : super(key: key);

  @override
  State<CustomBarcodeQRScanner> createState() => _CustomBarcodeQRScannerState();
}

class _CustomBarcodeQRScannerState extends State<CustomBarcodeQRScanner> {
  late final MobileScannerController scanController;
  final bool _torchEnabled = true;

  @override
  void initState() {
    scanController = MobileScannerController(
        torchEnabled: widget.torchEnabled,
        formats: [BarcodeFormat.all],
        facing: widget.cameraFace,
        detectionSpeed: DetectionSpeed.noDuplicates);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: MobileScanner(
              controller: scanController,
              fit: BoxFit.contain,
              onDetect: widget.onDetect,
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Container(
              decoration: ShapeDecoration(
                shape: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: Sizes.RADIUS_14,
                  borderLength: Sizes.WIDTH_30,
                  borderWidth: Sizes.WIDTH_20,
                  cutOutSize: Sizes.HEIGHT_400,
                  cutOutBottomOffset: 0,
                ),
              ),
            ),
          ),
          _buildBackButton(context),
          // _buildTorchButton()
        ],
      ),
    );
  }

  Padding _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Sizes.PADDING_28,
        right: Sizes.PADDING_28,
        left: Sizes.PADDING_28,
      ),
      child: InkWell(
        onTap: Get.back,
        child: Container(
          height: Sizes.HEIGHT_50 + 5,
          width: Sizes.WIDTH_60 + Sizes.WIDTH_10,
          margin: const EdgeInsets.all(Sizes.MARGIN_10),
          padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_10),
          decoration: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(Sizes.RADIUS_10),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: Sizes.ICON_SIZE_30,
            color: context.buttonTextColor,
          ),
        ),
      ),
    );
  }

  Padding _buildTorchButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: Sizes.PADDING_40,
        right: Sizes.PADDING_28,
        left: Sizes.PADDING_28,
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            height: Sizes.HEIGHT_50,
            width: Sizes.WIDTH_50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.5),
            ),
            child: Icon(
              _torchEnabled ? Icons.flash_on : Icons.flash_off,
              size: Sizes.ICON_SIZE_30,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scanController.dispose();
    super.dispose();
  }
}

class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutWidth;
  final double cutOutHeight;
  final double cutOutBottomOffset;

  QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    double? cutOutSize,
    double? cutOutWidth,
    double? cutOutHeight,
    this.cutOutBottomOffset = 0,
  })  : cutOutWidth = cutOutWidth ?? cutOutSize ?? 250,
        cutOutHeight = cutOutHeight ?? cutOutSize ?? 250 {
    assert(
      borderLength <=
          min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2,
      "Border can't be larger than ${min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2}",
    );
    assert(
      (cutOutWidth == null && cutOutHeight == null) ||
          (cutOutSize == null && cutOutWidth != null && cutOutHeight != null),
      'Use only cutOutWidth and cutOutHeight or only cutOutSize',
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final borderLength = this.borderLength >
            min(this.cutOutHeight, this.cutOutHeight) / 2 + borderWidth * 2
        ? borderWidthSize / 2
        : this.borderLength;
    final cutOutWidth =
        this.cutOutWidth < width ? this.cutOutWidth : width - borderOffset;
    final cutOutHeight =
        this.cutOutHeight < height ? this.cutOutHeight : height - borderOffset;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - cutOutWidth / 2 + borderOffset,
      -cutOutBottomOffset +
          rect.top +
          height / 2 -
          cutOutHeight / 2 +
          borderOffset,
      cutOutWidth - borderOffset * 2,
      cutOutHeight - borderOffset * 2,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
      // Draw top right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - borderLength,
          cutOutRect.top,
          cutOutRect.right,
          cutOutRect.top + borderLength,
          topRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw top left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.top,
          cutOutRect.left + borderLength,
          cutOutRect.top + borderLength,
          topLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - borderLength,
          cutOutRect.bottom - borderLength,
          cutOutRect.right,
          cutOutRect.bottom,
          bottomRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.bottom - borderLength,
          cutOutRect.left + borderLength,
          cutOutRect.bottom,
          bottomLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
