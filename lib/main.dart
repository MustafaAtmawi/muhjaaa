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
import 'package:muhjaaa/screens/conversation_screen.dart';
import 'package:muhjaaa/screens/login_screen.dart';
import 'package:muhjaaa/screens/signup_screen.dart';
import 'package:muhjaaa/screens/subscription_screen.dart';
import 'package:muhjaaa/utils/app_colors.dart';

// A simple navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // You can initialize things like Firebase, Sentry, etc. here if needed
  // WidgetsFlutterBinding.ensureInitialized(); // If you need to call native code before runApp

  // Instantiate repositories
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
    // MultiRepositoryProvider makes repositories available to all Blocs/Cubits
    // that might need them.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: chatRepository),
        RepositoryProvider.value(value: subscriptionRepository),
      ],
      // MultiBlocProvider provides Cubits to the widget tree.
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) =>
                AuthCubit(authRepository: context.read<AuthRepository>())
                  ..checkAuthStatus(), // Check auth status when app starts
          ),
          BlocProvider<ChatListCubit>(
            create: (context) =>
                ChatListCubit(chatRepository: context.read<ChatRepository>()),
            // ..fetchChatListData(), // Optionally fetch data immediately or on screen init
          ),
          BlocProvider<SubscriptionCubit>(
            create: (context) => SubscriptionCubit(
              subscriptionRepository: context.read<SubscriptionRepository>(),
            ),
            // ..fetchSubscriptionPlans(), // Optionally fetch data immediately
          ),
          // ConversationCubit is typically provided closer to the ConversationScreen
          // or created dynamically with arguments (like conversationId) if needed
          // For a global AI Mama chat, you could provide it here:
          // BlocProvider<ConversationCubit>(
          //   create: (context) => ConversationCubit(
          //     chatRepository: context.read<ChatRepository>(),
          //     conversationId: "ai_mama_chat", // Specific ID for AI Mama chat
          //   )..fetchMessages(),
          // ),
        ],
        child: MaterialApp(
          title: 'Muhjaaa',
          navigatorKey: navigatorKey, // For potential global navigation
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
          // The home screen will now be determined by the AuthState
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                // If authenticated, navigate to a main app screen
                // For now, let's go to ChatListScreen as an example
                return const ChatListScreen();
              }
              // If Unauthenticated, AuthInitial, AuthLoading, or AuthFailure, show LoginScreen
              // You might want to show a splash screen for AuthInitial/AuthLoading
              return const LoginScreen(); // Default to LoginScreen
            },
          ),
          // Define routes for navigation
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/chat_list': (context) => const ChatListScreen(),
            '/ai_mama_chat': (context) => BlocProvider(
              // Provide ConversationCubit specifically for this route
              create: (blocContext) => ConversationCubit(
                chatRepository: blocContext.read<ChatRepository>(),
                conversationId: "ai_mama_chat", // Specific ID
              )..fetchMessages(), // Fetch messages when screen is opened
              child: const AiMamaChatScreen(),
            ),
            '/subscription': (context) => const SubscriptionScreen(),
            // Example route for a doctor conversation, requires conversationId
            // You would navigate to this with arguments
            // '/conversation': (context) {
            //   final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            //   final conversationId = args['conversationId'] as String;
            //   final doctorName = args['doctorName'] as String; // Or pass full doctor model
            //   return BlocProvider(
            //     create: (blocContext) => ConversationCubit(
            //       chatRepository: blocContext.read<ChatRepository>(),
            //       conversationId: conversationId,
            //     )..fetchMessages(),
            //     child: ConversationScreen(doctorName: doctorName, conversationId: conversationId),
            //   );
            // },
          },
        ),
      ),
    );
  }
}
