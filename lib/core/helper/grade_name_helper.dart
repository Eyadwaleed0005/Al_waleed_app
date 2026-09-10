class GradeNameHelper {
  const GradeNameHelper._();

  static String getGradeName(String gradeId) {
    switch (gradeId.trim().toLowerCase()) {
      case 'secondary_1':
        return 'الصف الأول الثانوي';

      case 'secondary_2':
        return 'الصف الثاني الثانوي';

      case 'secondary_3':
        return 'الصف الثالث الثانوي';

      default:
        return 'الصف الدراسي';
    }
  }
}