part of themes;

const _superBold = FontWeight.w900;
const _bold = FontWeight.w700;
const _semiBold = FontWeight.w600;
const _medium = FontWeight.w500;
const _regular = FontWeight.w400;
const _light = FontWeight.w300;

TextTheme buildTextTheme({
  required Color textColor,
  required Color buttonColor,
}) =>
    TextTheme(
      headline1: TextStyle(
        fontSize: Sizes.TEXT_SIZE_96,
        color: textColor,
        fontWeight: _superBold,
        fontStyle: FontStyle.normal,
        fontFamily: AppStrings.WORK_SANS,
      ),
      headline2: TextStyle(
        fontSize: Sizes.TEXT_SIZE_60,
        color: textColor,
        fontWeight: _bold,
        fontStyle: FontStyle.normal,
        fontFamily: AppStrings.WORK_SANS,
      ),
      headline3: TextStyle(
        fontSize: Sizes.TEXT_SIZE_48,
        color: textColor,
        fontWeight: _bold,
        fontStyle: FontStyle.normal,
        fontFamily: AppStrings.WORK_SANS,
      ),
      headline4: TextStyle(
        fontSize: Sizes.TEXT_SIZE_34,
        color: textColor,
        fontWeight: _bold,
        fontStyle: FontStyle.normal,
        fontFamily: AppStrings.WORK_SANS,
      ),
      headline5: TextStyle(
        fontSize: Sizes.TEXT_SIZE_24,
        color: textColor,
        fontWeight: _bold,
        fontStyle: FontStyle.normal,
        fontFamily: AppStrings.WORK_SANS,
      ),
      headline6: TextStyle(
        fontSize: Sizes.TEXT_SIZE_20,
        color: textColor,
        fontWeight: _bold,
        fontStyle: FontStyle.normal,
        fontFamily: AppStrings.WORK_SANS,
      ),
      subtitle1: TextStyle(
        fontSize: Sizes.TEXT_SIZE_16,
        color: textColor,
        fontWeight: _semiBold,
        fontStyle: FontStyle.normal,
        fontFamily: AppStrings.WORK_SANS,
      ),
      subtitle2: TextStyle(
        fontSize: Sizes.TEXT_SIZE_14,
        color: textColor,
        fontWeight: _semiBold,
        fontStyle: FontStyle.normal,
        fontFamily: AppStrings.WORK_SANS,
      ),
      bodyText1: TextStyle(
        fontSize: Sizes.TEXT_SIZE_16,
        color: textColor,
        fontWeight: _light,
        fontStyle: FontStyle.normal,
        fontFamily: AppStrings.WORK_SANS,
      ),
      bodyText2: TextStyle(
        fontSize: Sizes.TEXT_SIZE_14,
        color: textColor,
        fontWeight: _light,
        fontStyle: FontStyle.normal,
        fontFamily: AppStrings.WORK_SANS,
      ),
      button: TextStyle(
        fontSize: Sizes.TEXT_SIZE_14,
        color: buttonColor,
        fontStyle: FontStyle.normal,
        fontFamily: AppStrings.WORK_SANS,
        fontWeight: _medium,
      ),
      caption: TextStyle(
        fontSize: Sizes.TEXT_SIZE_12,
        color: textColor,
        fontWeight: _regular,
        fontStyle: FontStyle.normal,
        fontFamily: AppStrings.WORK_SANS,
      ),
    );
