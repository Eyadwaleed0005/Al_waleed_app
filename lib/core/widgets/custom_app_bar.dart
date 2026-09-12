import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleColor,
    this.backButtonColor,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.toolbarHeight,
    this.bottom,
  });

  static const double _portraitHeight = 76;
  static const double _landscapeHeight = 56;
  static const double _leadingWidth = 56;
  static const double _backIconSize = 20;
  static const double _actionIconSize = 24;

  final String? title;
  final Color? titleColor;
  final Color? backButtonColor;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final double? toolbarHeight;
  final PreferredSizeWidget? bottom;

  bool get _isLandscape {
    return ScreenUtil().screenWidth > ScreenUtil().screenHeight;
  }

  double get _effectiveToolbarHeight {
    if (toolbarHeight != null) {
      return toolbarHeight!;
    }

    return _isLandscape ? _landscapeHeight : _portraitHeight;
  }

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0;

    return Size.fromHeight(_effectiveToolbarHeight + bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    final effectiveHeight =
        toolbarHeight ?? (isLandscape ? _landscapeHeight : _portraitHeight);

    return AppBar(
      toolbarHeight: effectiveHeight,
      leadingWidth: _leadingWidth,
      elevation: elevation,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? ColorPalette.background,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      titleSpacing: isLandscape ? 12 : 8,
      leading: _buildLeading(context),
      title: _buildTitle(isLandscape: isLandscape),
      actions: actions,
      actionsIconTheme: IconThemeData(
        size: _actionIconSize,
        color: titleColor ?? ColorPalette.textPrimary,
      ),
      bottom: bottom,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    final shouldShowBackButton =
        showBackButton && Navigator.of(context).canPop();

    if (!shouldShowBackButton) {
      return leading;
    }

    return SizedBox(
      width: _leadingWidth,
      height: _leadingWidth,
      child: IconButton(
        tooltip: 'رجوع',
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: _leadingWidth,
          minHeight: _leadingWidth,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: _backIconSize,
          color: backButtonColor ?? ColorPalette.textPrimary,
        ),
      ),
    );
  }

  Widget? _buildTitle({required bool isLandscape}) {
    final normalizedTitle = title?.trim();

    if (normalizedTitle == null || normalizedTitle.isEmpty) {
      return titleWidget;
    }

    return Text(
      normalizedTitle,
      maxLines: isLandscape ? 1 : 2,
      softWrap: !isLandscape,
      overflow: TextOverflow.clip,
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      style: AppTextStyle.font18TextPrimarySemiBoldKufam().copyWith(
        color: titleColor,
        fontSize: 18,
        height: isLandscape ? 1.2 : 1.35,
      ),
    );
  }
}
