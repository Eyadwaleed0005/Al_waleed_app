import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    this.controller,
    this.hintText = 'ابحث...',
    this.onChanged,
    this.onSubmitted,
    this.onSearchTap,
    this.onClear,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSearchTap;
  final VoidCallback? onClear;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;
  late bool _ownsController;

  bool get _hasText => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(CustomSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_handleControllerChanged);

      if (_ownsController) {
        _controller.dispose();
      }

      _initializeController();
    }
  }

  void _initializeController() {
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);

    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

    return Theme(
      data: currentTheme.copyWith(
        colorScheme: currentTheme.colorScheme.copyWith(
          primary: ColorPalette.primary,
          surface: ColorPalette.surface,
          onSurface: ColorPalette.textPrimary,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ColorPalette.primary,
          selectionColor: ColorPalette.accent.withOpacity(0.45),
          selectionHandleColor: ColorPalette.primary,
        ),
      ),
      child: TextField(
        controller: _controller,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        cursorColor: ColorPalette.primary,
        style: AppTextStyle.font15TextPrimaryMediumTajawal(),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintTextDirection: TextDirection.rtl,
          hintStyle: AppTextStyle.font15TextMutedRegularTajawal(),
          filled: true,
          fillColor: ColorPalette.surface,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 17.h,
          ),
          suffixIcon: _buildSuffixIcon(),
          suffixIconConstraints: BoxConstraints(
            minWidth: 56.w,
            minHeight: 56.h,
            maxWidth: 56.w,
            maxHeight: 56.h,
          ),
          enabledBorder: _buildBorder(color: ColorPalette.border, width: 1.w),
          focusedBorder: _buildBorder(
            color: ColorPalette.primary,
            width: 1.3.w,
          ),
          disabledBorder: _buildBorder(color: ColorPalette.divider, width: 1.w),
        ),
      ),
    );
  }

  Widget _buildSuffixIcon() {
    return InkWell(
      onTap: _hasText ? _clearSearch : widget.onSearchTap,
      borderRadius: BorderRadius.circular(18.r),
      splashColor: ColorPalette.primarySoftBackground,
      highlightColor: ColorPalette.primarySoftBackground,
      child: Icon(
        _hasText ? Icons.close_rounded : Icons.search_rounded,
        size: 24.sp,
        color: ColorPalette.primary,
      ),
    );
  }

  OutlineInputBorder _buildBorder({
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
