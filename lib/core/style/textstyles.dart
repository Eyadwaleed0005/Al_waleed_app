import 'package:flutter/material.dart';

import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/fontweighthelper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  const AppTextStyle._();

  /*static TextStyle font20HighlightSemiBold() {
    return TextStyle(
      fontSize: 20.sp,
      color: ColorPalette.highlight,
    );
  }*/

  static const String tajawal = 'Tajawal';
  static const String kufam = 'Kufam';

  static TextStyle font20TextLightRegularTajawal() {
    return TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeightHelper.regular,
      fontFamily: tajawal,
      color: ColorPalette.textLight,
    );
  }

  static TextStyle font20TextPrimarySemiBoldKufam() {
    return TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: kufam,
      color: ColorPalette.textPrimary,
    );
  }

  static TextStyle font14TextSecondaryRegularTajawal() {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeightHelper.regular,
      fontFamily: tajawal,
      color: ColorPalette.textSecondary,
    );
  }

  //will change to textOceanBlue in lesson exam
  static TextStyle font13TextPrimaryMediumTajawal() {
    return TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeightHelper.medium,
      fontFamily: tajawal,
      color: ColorPalette.textPrimary,
    );
  }

  static TextStyle font15TextMutedRegularTajawal() {
    return TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeightHelper.regular,
      fontFamily: tajawal,
      color: ColorPalette.textMuted,
    );
  }

  static TextStyle font15TextLightBoldTajawal() {
    return TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeightHelper.bold,
      fontFamily: tajawal,
      color: ColorPalette.textLight,
    );
  }

  static TextStyle font13TextSecondaryRegularTajawal() {
    return TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeightHelper.regular,
      fontFamily: tajawal,
      color: ColorPalette.textSecondary,
    );
  }

  static TextStyle font18TextPrimarySemiBoldKufam() {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: kufam,
      color: ColorPalette.textPrimary,
    );
  }

  static TextStyle font14TextPrimaryMediumKufam() {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeightHelper.medium,
      fontFamily: kufam,
      color: ColorPalette.textPrimary,
    );
  }

  static TextStyle font11TextHighLightMediumTajawal() {
    return TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeightHelper.medium,
      fontFamily: tajawal,
      color: ColorPalette.textHighLight,
    );
  }

  static TextStyle font11TextSoftSagaMediumTajawal() {
    return TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeightHelper.medium,
      fontFamily: tajawal,
      color: ColorPalette.textSoftSaga,
    );
  }

  static TextStyle font15TextBlackSemiBoldKufam() {
    return TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: kufam,
      color: ColorPalette.textBlack,
    );
  }

  static TextStyle font14TextBlackRegularTajawal() {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeightHelper.regular,
      fontFamily: tajawal,
      color: ColorPalette.textBlack,
    );
  }

  static TextStyle font20TextBlackSemiBoldKufam() {
    return TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: kufam,
      color: ColorPalette.textBlack,
    );
  }

  static TextStyle font12TextSecondaryRegularTajawal() {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeightHelper.regular,
      fontFamily: tajawal,
      color: ColorPalette.textSecondary,
    );
  }

  static TextStyle font12TextPrimaryRegularTajawal() {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeightHelper.regular,
      fontFamily: tajawal,
      color: ColorPalette.primary,
    );
  }

  static TextStyle font16TextPrimarySemiBoldKufam() {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: kufam,
      color: ColorPalette.textPrimary,
    );
  }

  static TextStyle font13TextPrimaryBoldTajawal() {
    return TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeightHelper.bold,
      fontFamily: tajawal,
      color: ColorPalette.primary,
    );
  }

  //change color to textRed if needed
  static TextStyle font14TextLightBoldTajawal() {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeightHelper.bold,
      fontFamily: tajawal,
      color: ColorPalette.textLight,
    );
  }

  static TextStyle font17TextPrimarySemiBoldKufam() {
    return TextStyle(
      fontSize: 17.sp,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: kufam,
      color: ColorPalette.primary,
    );
  }

  static TextStyle font29TextPrimaryBoldTajawal() {
    return TextStyle(
      fontSize: 29.sp,
      fontWeight: FontWeightHelper.bold,
      fontFamily: tajawal,
      color: ColorPalette.textPrimary,
    );
  }

  static TextStyle font12TextSecondaryMediumTajawal() {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeightHelper.medium,
      fontFamily: tajawal,
      color: ColorPalette.textSecondary,
    );
  }

  static TextStyle font11TextSecondaryRegularTajawal() {
    return TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeightHelper.regular,
      fontFamily: tajawal,
      color: ColorPalette.textSecondary,
    );
  }

  static TextStyle font13TextOceanBlueBoldTajawal() {
    return TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeightHelper.bold,
      fontFamily: tajawal,
      color: ColorPalette.textOceanBlue,
    );
  }

  static TextStyle font11TextHighlightBoldTajawal() {
    return TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeightHelper.bold,
      fontFamily: tajawal,
      color: ColorPalette.textHighLight,
    );
  }

  static TextStyle font19TextLightSemiBoldKufam() {
    return TextStyle(
      fontSize: 19.sp,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: kufam,
      color: ColorPalette.textLight,
    );
  }

  static TextStyle font12TextSoftSagaMediumTajawal() {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeightHelper.medium,
      fontFamily: tajawal,
      color: ColorPalette.textSoftSaga,
    );
  }

  static TextStyle font18TextLightBoldTajawal() {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeightHelper.bold,
      fontFamily: tajawal,
      color: ColorPalette.textLight,
    );
  }

  static TextStyle font12TextLightMediumTajawal() {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeightHelper.medium,
      fontFamily: tajawal,
      color: ColorPalette.textLight,
    );
  }

  static TextStyle font13TextHighlightBoldTajawal() {
    return TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeightHelper.bold,
      fontFamily: tajawal,
      color: ColorPalette.textHighLight,
    );
  }

  static TextStyle font12TextPrimaryBoldTajawal() {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeightHelper.bold,
      fontFamily: tajawal,
      color: ColorPalette.textPrimary,
    );
  }

  static TextStyle font19TextOceanBlueSemiBoldKufam() {
    return TextStyle(
      fontSize: 19.sp,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: kufam,
      color: ColorPalette.textOceanBlue,
    );
  }

  static TextStyle font14TextRedBoldTajawal() {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeightHelper.bold,
      fontFamily: tajawal,
      color: ColorPalette.textRed,
    );
  }

  static TextStyle font12ErrorRegularTajawal() {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeightHelper.regular,
      fontFamily: tajawal,
      color: ColorPalette.error,
    );
  }

  static TextStyle font15ErrorBoldTajawal() {
    return TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeightHelper.bold,
      fontFamily: tajawal,
      color: ColorPalette.error,
    );
  }

  static TextStyle font14ErrorSemiBoldTajawal() {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: tajawal,
      color: ColorPalette.error,
    );
  }

  static TextStyle font26PageTitleBoldKufam() {
    return TextStyle(
      fontSize: 26.sp,
      fontWeight: FontWeightHelper.bold,
      fontFamily: kufam,
      color: ColorPalette.highlight,
    );
  }
}
