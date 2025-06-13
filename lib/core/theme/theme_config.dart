import 'package:flutter/material.dart';

// RULES
/*
1. normal-nya, jika widget di dalam column/row/grid tidak memerlukan margin 
untuk memberikan jarak , gunakan property spacing di column/row
2. Padding scaffold selalu spMd
3. Padding card menggunakan spSm
4. spacing Column/Row/Grid menggunakan spSm
5. Jika ingin menambahkan padding/margin, gunakan spXs, spSm, spMd, spLg, spXl, sp2xl, sp3xl, sp

Flutter version 3.24+
Selalu ubah
.withValues(n)
menjadi
.withValues(alpha: n)

Selalu ubah
primary: 
menjadi
backgroundColor:

6. Warna icon, text secondaryButton selalu menggunakan disabledBoldColor

7. Jangan pernah ubah contentPadding dari ListTile
*/
//@ My Config
Color primaryColor = Color(0xff4E50FC);
Color secondaryColor = Color(0xFFE8E9ED);
Color successColor = Color(0xff00D6AC);
Color dangerColor = Color(0xFFD81B60);
Color infoColor = Color(0xff2196F3);
Color warningColor = Color(0xffF83E07);
Color disabledBoldColor = Color(0xFF626C7F);
Color disabledColor = Color(0xFFB0B0B0);
Color disabledOutlineBorderColor = Color(0xFFB0B0B0);

Color scaffoldBackgroundColor = Colors.grey[300]!;
Color scaffoldWhiteBackgroundColor = Colors.white;
// final scaffoldBackgroundColor = Colors.white;
Color textColor = Colors.black;
final spXxs = 4.0;
final spXs = 8.0;
final spSm = 12.0;
final spMd = 16.0;
final spLg = 20.0;
final spXl = 24.0;
final sp2xl = 32.0;
final sp3xl = 40.0;
final sp4xl = 48.0;

final radiusNone = 0.0;
final radiusXxs = 2.0;
final radiusXs = 4.0;
final radiusSm = 6.0;
final radiusMd = 8.0;
final radiusLg = 10.0;
final radiusXl = 12.0;
final radius2xl = 16.0;
final radius3xl = 20.0;
final radius4xl = 24.0;

/*
Example of usage
boxShadow: [
  shadowMd,
],
*/
final shadowNone = BoxShadow(
  color: Colors.transparent,
  blurRadius: 0,
  spreadRadius: 0,
  offset: Offset(0, 0),
);
final shadowXxs = BoxShadow(
  color: Colors.grey[300]!.withValues(alpha: 0.5),
  blurRadius: 2,
  spreadRadius: 1,
  offset: Offset(0, 1),
);
final shadowXs = BoxShadow(
  color: Colors.grey[300]!.withValues(alpha: 0.5),
  blurRadius: 4,
  spreadRadius: 1,
  offset: Offset(0, 2),
);
final shadowSm = BoxShadow(
  color: Colors.grey[300]!.withValues(alpha: 0.5),
  blurRadius: 6,
  spreadRadius: 1,
  offset: Offset(0, 3),
);
final shadowMd = BoxShadow(
  color: Colors.grey[300]!.withValues(alpha: 0.5),
  blurRadius: 8,
  spreadRadius: 1,
  offset: Offset(0, 4),
);
final shadowLg = BoxShadow(
  color: Colors.grey[300]!.withValues(alpha: 0.5),
  blurRadius: 10,
  spreadRadius: 1,
  offset: Offset(0, 5),
);
final shadowXl = BoxShadow(
  color: Colors.grey[300]!.withValues(alpha: 0.5),
  blurRadius: 12,
  spreadRadius: 1,
  offset: Offset(0, 6),
);
final shadowXxl = BoxShadow(
  color: Colors.grey[300]!.withValues(alpha: 0.5),
  blurRadius: 16,
  spreadRadius: 1,
  offset: Offset(0, 8),
);
final shadow3xl = BoxShadow(
  color: Colors.grey[300]!.withValues(alpha: 0.5),
  blurRadius: 20,
  spreadRadius: 1,
  offset: Offset(0, 10),
);
final shadow4xl = BoxShadow(
  color: Colors.grey[300]!.withValues(alpha: 0.5),
  blurRadius: 24,
  spreadRadius: 1,
  offset: Offset(0, 12),
);

// base size for text
final fsXxs = 8.0;
final fsXs = 10.0;
final fsSm = 11.0;
final fsMd = 12.0;
final fsLg = 14.0;
final fsXl = 16.0;
final fs2xl = 18.0;
final fs3xl = 20.0;
final fs4xl = 22.0;

//base size for icon
final iconXxs = 12.0;
final iconXs = 16.0;
final iconSm = 20.0;
final iconMd = 24.0;
final iconLg = 28.0;
final iconXl = 32.0;
final icon2xl = 48.0;
final icon3xl = 46.0;
final icon4xl = 64.0;

//base size form input values like textfield, dropdown, etc
final formFsXxs = 8.0;
final formFsXs = 10.0;
final formFsSm = 12.0;
final formFsMd = 14.0;
final formFsLg = 16.0;
final formFsXl = 18.0;
final formFs2xl = 20.0;
final formFs3xl = 22.0;
final formFs4xl = 24.0;

// Styling for buttons
//bs is ButtonSize
enum bs {
  xxs,
  xs,
  sm,
  md,
  lg,
  xl,
  xxl,
  xxxl,
  xxxxl,
}
// bs.md is always default size

//Please implement this for Button
//B1. RULE
//bs.xxs use verticalPadding: spXxs, horizontalPadding: spXxs, fontSize: textXxs
//bs.xs use verticalPadding: spXs, horizontalPadding: spXs, fontSize: textXs
//bs.sm use verticalPadding: spSm, horizontalPadding: spSm, fontSize: textSm
//bs.md use verticalPadding: spMd, horizontalPadding: spMd, fontSize: textMd
//bs.lg use verticalPadding: spLg, horizontalPadding: spLg, fontSize: textLg
//bs.xl use verticalPadding: spXl, horizontalPadding: spXl, fontSize: textXl
//bs.xxl use verticalPadding: sp2xl, horizontalPadding: sp2xl, fontSize: text2xl
//bs.xxxl use verticalPadding: sp3xl, horizontalPadding: sp3xl, fontSize: text3xl
//bs.xxxxl use verticalPadding: sp4xl, horizontalPadding: sp4xl, fontSize: text4xl

//:@ My Config

Color getBackgroundColor({
  Color? color,
  bool isOutlined = false,
}) {
  if (isOutlined && color == secondaryColor) {
    return disabledBoldColor;
  }
  if (isOutlined) {
    return color ?? primaryColor;
  }
  return color ?? primaryColor;
}

Color getForegroundColor({
  Color? color,
  bool isOutlined = false,
}) {
  if (isOutlined && color == secondaryColor) {
    return disabledBoldColor;
  } else if (color == secondaryColor) {
    return disabledBoldColor;
  }

  if (isOutlined) {
    return color ?? primaryColor;
  }
  return Colors.white;
}

/*
eg: 
var mainColor = getBackgroundColor(
  color: widget.color,
  isOutlined: widget.isOutlined,
);
var iconOrTextColor = getForegroundColor(
  color: widget.color,
  isOutlined: widget.isOutlined,
);
*/

EdgeInsets getPadding(bs size) {
  switch (size) {
    case bs.xxs:
      return EdgeInsets.symmetric(horizontal: spXxs, vertical: spXxs);
    case bs.xs:
      return EdgeInsets.symmetric(horizontal: spXs, vertical: spXs);
    case bs.sm:
      return EdgeInsets.symmetric(horizontal: spSm, vertical: spSm);
    case bs.md:
      return EdgeInsets.symmetric(horizontal: spMd, vertical: 0);
    case bs.lg:
      return EdgeInsets.symmetric(horizontal: spLg, vertical: spLg);
    case bs.xl:
      return EdgeInsets.symmetric(horizontal: spXl, vertical: spXl);
    case bs.xxl:
      return EdgeInsets.symmetric(horizontal: sp2xl, vertical: sp2xl);
    case bs.xxxl:
      return EdgeInsets.symmetric(horizontal: sp3xl, vertical: sp3xl);
    case bs.xxxxl:
      return EdgeInsets.symmetric(horizontal: sp4xl, vertical: sp4xl);
  }
}

Color getFormBorder() {
  return Colors.grey[300]!;
}

double getFormFontSize(bs size) {
  switch (size) {
    case bs.xxs:
      return formFsXxs;
    case bs.xs:
      return formFsXs;
    case bs.sm:
      return formFsSm;
    case bs.md:
      return formFsMd;
    case bs.lg:
      return formFsLg;
    case bs.xl:
      return formFsXl;
    case bs.xxl:
      return formFs2xl;
    case bs.xxxl:
      return formFs3xl;
    case bs.xxxxl:
      return formFs4xl;
  }
}
