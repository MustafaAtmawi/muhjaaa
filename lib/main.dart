import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muhjaaa/cubits/auth/auth_cubit.dart';
import 'package:muhjaaa/cubits/chat/chat_list_cubit.dart';
import 'package:muhjaaa/cubits/chat/conversation_cubit.dart';
import 'package:muhjaaa/cubits/subscription/subscription_cubit.dart';
import 'package:muhjaaa/repositories/auth_repository.dart';
import 'package:muhjaaa/repositories/chat_repository.dart';
import 'package:muhjaaa/repositories/subscription_repository.dart';
import 'package:muhjaaa/screens/add_baby_screen.dart';
import 'package:muhjaaa/screens/ai_mama_chat_screen.dart';
import 'package:muhjaaa/screens/chat_list_screen.dart';
import 'package:muhjaaa/screens/doctor_list_screen.dart';
// import 'package:muhjaaa/screens/doctor_list_screen.dart'; // Not used in initial routes
import 'package:muhjaaa/screens/login_screen.dart';
import 'package:muhjaaa/screens/my_appointments_screen.dart';
import 'package:muhjaaa/screens/onboarding_welcome_screen.dart';
import 'package:muhjaaa/screens/signup_screen.dart';
// import 'package:muhjaaa/screens/my_appointments_screen.dart'; // Not used in initial routes
// import 'package:muhjaaa/screens/signup_screen.dart'; // Used in routes table
import 'package:muhjaaa/screens/store_screen.dart';
import 'package:muhjaaa/screens/subscription_screen.dart';
// import 'package:muhjaaa/screens/subscription_screen.dart'; // Used in routes table
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
              // Consider fetching initial data here or in ChatListScreen.initState
              // ..fetchChatListData();
            },
          ),
          BlocProvider<SubscriptionCubit>(
            create: (context) {
              return SubscriptionCubit(
                subscriptionRepository: context.read<SubscriptionRepository>(),
              );
              // Consider fetching initial data here or in SubscriptionScreen.initState
              // ..fetchSubscriptionPlans();
            },
          ),
          // Note: ConversationCubit is usually provided closer to where it's needed (e.g., when navigating to a conversation)
          //       because it's often specific to a single conversationId.
          //       The way it's provided in the '/ai_mama_chat' route is correct.
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
                // **** CORRECTED NAVIGATION LOGIC HERE ****
                return const ChatListScreen(); // Navigate to main screen (e.g., ChatListScreen)
              }
              if (state is Unauthenticated || state is AuthFailure) {
                return const MyAppointmentsScreen(); // This is likely the path taken, leading to StoreScreen
              }
              // AuthInitial or AuthLoading
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
            // '/signup': (context) => const SignupScreen(), // Already defined in the uploaded file
            '/chat_list': (context) => const ChatListScreen(),
            '/ai_mama_chat': (routeBuildContext) {
              // This BlocProvider for ConversationCubit is correctly scoped.
              return BlocProvider<ConversationCubit>(
                create: (cubitContext) {
                  try {
                    final chatRepo = cubitContext.read<ChatRepository>();
                    return ConversationCubit(
                      chatRepository: chatRepo,
                      conversationId: "ai_mama_chat",
                    )..fetchMessages();
                  } catch (e) {
                    // It's generally better to handle this error more gracefully
                    // than re-throwing an Exception that crashes the create method.
                    // For example, log it and return a Cubit that emits an error state.
                    // print("Failed to create ConversationCubit for /ai_mama_chat: $e");
                    // return ConversationCubit(chatRepository: cubitContext.read<ChatRepository>(), conversationId: "ai_mama_chat")..emitErrorState();
                    throw Exception(
                      "Failed to create ConversationCubit for /ai_mama_chat: $e",
                    );
                  }
                },
                child: const AiMamaChatScreen(),
              );
            },
            // '/subscription': (context) => const SubscriptionScreen(), // Already defined in the uploaded file
            // Add other routes from your uploaded main.dart if they were missed here.
            // From your main.dart, these were also present:
            '/signup': (context) =>
                const SignupScreen(), // Ensure this matches your actual file name
            '/subscription': (context) => const SubscriptionScreen(),
          },
        ),
      ),
    );
  }
}
