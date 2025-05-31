import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muhjaaa/cubits/auth/auth_cubit.dart';
import 'package:muhjaaa/cubits/chat/chat_list_cubit.dart';
import 'package:muhjaaa/cubits/chat/conversation_cubit.dart';
import 'package:muhjaaa/cubits/subscription/subscription_cubit.dart';
import 'package:muhjaaa/repositories/auth_repository.dart';
import 'package:muhjaaa/repositories/chat_repository.dart';
import 'package:muhjaaa/repositories/subscription_repository.dart';
import 'package:muhjaaa/screens/ai_mama_chat_screen.dart';
import 'package:muhjaaa/screens/chat_list_screen.dart';
import 'package:muhjaaa/screens/login_screen.dart';
import 'package:muhjaaa/screens/signup_screen.dart';
import 'package:muhjaaa/screens/subscription_screen.dart';
import 'package:muhjaaa/utils/app_colors.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  final authRepository = AuthRepository();
  final chatRepository = ChatRepository();
  final subscriptionRepository = SubscriptionRepository();

  runApp(
    MyApp(
      authRepository: authRepository,
      chatRepository: chatRepository,
      subscriptionRepository: subscriptionRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ChatRepository chatRepository;
  final SubscriptionRepository subscriptionRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.chatRepository,
    required this.subscriptionRepository,
  });

  @override
  Widget build(BuildContext context) {
    print("[MyApp] Building MultiRepositoryProvider and MultiBlocProvider");
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: chatRepository),
        RepositoryProvider.value(value: subscriptionRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) {
              print("[MainBlocProviders] Creating AuthCubit");
              return AuthCubit(authRepository: context.read<AuthRepository>())
                ..checkAuthStatus();
            },
          ),
          BlocProvider<ChatListCubit>(
            create: (context) {
              print("[MainBlocProviders] Creating ChatListCubit");
              return ChatListCubit(
                chatRepository: context.read<ChatRepository>(),
              );
            },
          ),
          BlocProvider<SubscriptionCubit>(
            create: (context) {
              print("[MainBlocProviders] Creating SubscriptionCubit");
              return SubscriptionCubit(
                subscriptionRepository: context.read<SubscriptionRepository>(),
              );
            },
          ),
        ],
        child: MaterialApp(
          title: 'Muhjaaa',
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: AppColors.primaryRed,
            scaffoldBackgroundColor: AppColors.screenBackground,
            fontFamily: 'Cairo',
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.screenBackground,
              elevation: 0,
              iconTheme: IconThemeData(color: AppColors.darkGreyText),
              titleTextStyle: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.darkGreyText,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.darkGreyText,
              ),
              bodyMedium: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.darkGreyText,
              ),
              displayLarge: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.darkGreyText,
              ),
              headlineSmall: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.darkGreyText,
              ),
              titleLarge: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.darkGreyText,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: const TextStyle(
                color: AppColors.lightGrey,
                fontFamily: 'Cairo',
                fontSize: 16.0,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
                textStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 24.0,
                ),
              ),
            ),
          ),
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                // Per your original code, though this might be LoginScreen() or a typo for ChatListScreen()
                return const ChatListScreen();
              }
              if (state is Unauthenticated || state is AuthFailure) {
                // Per your original code
                return const LoginScreen();
              }
              return const Scaffold(
                backgroundColor: AppColors.screenBackground,
                body: Center(
                  child: CircularProgressIndicator(color: AppColors.primaryRed),
                ),
              );
            },
          ),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/chat_list': (context) => const ChatListScreen(),
            '/ai_mama_chat': (routeBuildContext) {
              print("--- Navigating to /ai_mama_chat route ---");
              return BlocProvider<ConversationCubit>(
                create: (cubitContext) {
                  print(
                    "[Route:/ai_mama_chat] Inside BlocProvider.create for ConversationCubit",
                  );
                  try {
                    print(
                      "[Route:/ai_mama_chat] Attempting to read ChatRepository...",
                    );
                    final chatRepo = cubitContext.read<ChatRepository>();
                    print(
                      "[Route:/ai_mama_chat] ChatRepository found: $chatRepo. Creating ConversationCubit.",
                    );
                    return ConversationCubit(
                      chatRepository: chatRepo,
                      conversationId: "ai_mama_chat",
                    )..fetchMessages();
                  } catch (e, s) {
                    print(
                      "[Route:/ai_mama_chat] ERROR reading ChatRepository or creating ConversationCubit: $e",
                    );
                    print(s);
                    // rethrow; // You might want to rethrow or handle this gracefully
                    // For now, let's try to return a dummy or throw to see the error if it happens here
                    throw Exception("Failed to create ConversationCubit: $e");
                  }
                },
                child: const AiMamaChatScreen(),
              );
            },
            '/subscription': (context) => const SubscriptionScreen(),
          },
        ),
      ),
    );
  }
}
