import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:checkmate/core/constants/constants.dart';
import 'package:checkmate/core/theme/app_theme.dart';
import 'package:checkmate/features/address/presentation/bloc/user_bloc.dart';
import 'package:checkmate/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:checkmate/features/auth/presentation/pages/login.dart';
import 'package:checkmate/features/auth/presentation/pages/splash.dart';
import 'package:checkmate/features/news/domain/usecases/get_article.dart';
import 'package:checkmate/features/news/presentation/bloc/article/article_bloc.dart';
import 'package:checkmate/features/news/presentation/bloc/article/article_event.dart';
import 'package:checkmate/features/news/presentation/pages/article_page.dart';
import 'package:checkmate/injection_container.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );

  await initializeDependencies();

  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OtpBloc>(create: (_) => s1<OtpBloc>()),

        BlocProvider<UserBloc>(create: (_) => s1<UserBloc>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844), // Typical iPhone size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}





    // return BlocProvider<ArticleBloc>(
    //   // create: (context) => BlocProvider.of<ArticleBloc>(context)..add(GetArticles()),
    //   create: (context) => s1<ArticleBloc>()..add(GetArticles()),
    //   child: MaterialApp(
    //     useInheritedMediaQuery: true,
    //     locale: DevicePreview.locale(context),
    //     builder: DevicePreview.appBuilder,
    //     debugShowCheckedModeBanner: false,
    //     theme: AppTheme.light,
    //     // home: const SplashScreen(),
    //     home: ArticlePage(),
    //   ),
    // );