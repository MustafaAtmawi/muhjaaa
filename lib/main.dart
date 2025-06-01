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
import 'package:muhjaaa/screens/my_appointments_screen.dart';
import 'package:muhjaaa/screens/signup_screen.dart';
import 'package:muhjaaa/screens/subscription_screen.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/utils/app_theme.dart';

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
    // Added const constructor
    super.key,
    required this.authRepository,
    required this.chatRepository,
    required this.subscriptionRepository,
  });

  @override
  Widget build(BuildContext context) {
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
              return AuthCubit(authRepository: context.read<AuthRepository>())
                ..checkAuthStatus();
            },
          ),
          BlocProvider<ChatListCubit>(
            create: (context) {
              return ChatListCubit(
                chatRepository: context.read<ChatRepository>(),
              );
            },
          ),
          BlocProvider<SubscriptionCubit>(
            create: (context) {
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
          theme: AppTheme.lightTheme,
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return const ChatListScreen();
              }
              if (state is Unauthenticated || state is AuthFailure) {
                return const SubscriptionScreen();
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
              return BlocProvider<ConversationCubit>(
                create: (cubitContext) {
                  try {
                    final chatRepo = cubitContext.read<ChatRepository>();
                    return ConversationCubit(
                      chatRepository: chatRepo,
                      conversationId: "ai_mama_chat",
                    )..fetchMessages();
                  } catch (e) {
                    throw Exception(
                      "Failed to create ConversationCubit for /ai_mama_chat: $e",
                    );
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
