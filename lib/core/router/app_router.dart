import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/landing_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';

import '../../features/profile/presentation/pages/profile_page.dart';

import '../../features/home/presentation/pages/home_page.dart';

import '../../features/info/presentation/pages/about_page.dart';
import '../../features/info/presentation/pages/anxiety_info_page.dart';

import '../../features/dass21/presentation/pages/dass_intro_page.dart';
import '../../features/dass21/presentation/pages/dass_test_page.dart';
import '../../features/dass21/presentation/pages/dass_result_page.dart';
import '../../features/dass21/presentation/pages/adaptive_recommendation_page.dart';
import '../../features/dass21/presentation/pages/logbook_page.dart';

import '../../features/monitoring/data/models/monitoring_user.dart';
import '../../features/monitoring/presentation/monitoring_page.dart';
import '../../features/monitoring/presentation/monitoring_detail_page.dart';

import '../../features/dass21/data/models/activity_model.dart';

import '../../features/info/presentation/pages/education_result_page.dart';

import 'routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.landing,
    routes: [
      /// Auth
      GoRoute(
        path: AppRoutes.landing,
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),

      /// Home
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),

      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePage(),
      ),

      /// Info
      GoRoute(
        path: AppRoutes.about,
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: AppRoutes.anxietyInfo,
        builder: (context, state) => const AnxietyInfoPage(),
      ),

      /// dass Flow
      GoRoute(
        path: AppRoutes.dassIntro,
        builder: (context, state) => const DassIntroPage(),
      ),
      GoRoute(
        path: AppRoutes.dassTest,
        builder: (context, state) => const DassTestPage(),
      ),

      /// result page
      GoRoute(
        path: AppRoutes.dassResults,
        builder: (context, state) {
          final extra = state.extra;

          if (extra is DassResultData) {
            return DassResultPage(data: extra);
          }

          /// fallback biar ga crash
          return const DassResultPage(
            data: DassResultData(
              depressionScore: 0,
              anxietyScore: 0,
              stressScore: 0,
              depressionLabel: "Resiko Rendah",
              anxietyLabel: "Resiko Rendah",
              stressLabel: "Resiko Rendah",
              overallLabel: "Resiko Rendah",
            ),
          );
        },
      ),

      /// edukasi hasil
      GoRoute(
        path: AppRoutes.education,
        builder: (context, state) {
          final label = state.extra as String? ?? "Resiko Rendah";
          return EducationResultPage(label: label);
        },
      ),

      /// LOGBOOK
      GoRoute(
        path: AppRoutes.logbook,
        builder: (context, state) => const LogbookPage(),
      ),

      ///  REKOMENDASI
      GoRoute(
        path: AppRoutes.adaptiveRecommendation,
        builder: (context, state) {
          final extra = state.extra;

          if (extra is List<Activity>) {
            return AdaptiveRecommendationPage(activities: extra);
          }

          return const AdaptiveRecommendationPage(activities: []);
        },
      ),
      GoRoute(
        path: AppRoutes.monitoring,
        builder: (_, __) => const MonitoringPage(),
      ),

      GoRoute(
        path: AppRoutes.monitoringDetail,
        builder: (_, state) {
          final user = state.extra as MonitoringUser;

          return MonitoringDetailPage(
            user: user,
          );
        },
      ),
    ],
  );
});
