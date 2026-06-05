# Riverpod Refactoring Guide

## 🎯 Overview

This guide documents the refactoring of the Broker app to follow proper Riverpod 2.x patterns with best practices.

## 📋 Architecture Principles

### 1. **Provider Hierarchy**
```
Providers (Dependencies)
    ↓
Repository Providers
    ↓
State Providers (Notifiers)
    ↓
UI (ConsumerWidgets)
```

### 2. **State Management Patterns**

#### ✅ Use AsyncValue for API calls
```dart
// BAD - Custom loading/error states
class MyState {
  final bool isLoading;
  final String? error;
  final Data? data;
}

// GOOD - Use AsyncValue
final myProvider = FutureProvider<Data>((ref) async {
  return await repository.fetchData();
});

// Or with StateNotifier
final myProvider = AsyncNotifierProvider<MyNotifier, Data>(() => MyNotifier());
```

#### ✅ Use Freezed for immutable state
```dart
@freezed
class MyState with _$MyState {
  const factory MyState({
    required String id,
    @Default(false) bool isLoading,
    String? error,
  }) = _MyState;
}
```

### 3. **Provider Types**

| Provider Type | Use Case | Example |
|--------------|----------|---------|
| `Provider` | Readonly dependencies | DioClient, Repositories |
| `StateProvider` | Simple mutable state | Selected index, filters |
| `NotifierProvider` | Complex state logic | Feature state management |
| `AsyncNotifierProvider` | Async state logic | API data with loading/error |
| `FutureProvider` | One-time async fetch | Initial data load |
| `StreamProvider` | Real-time data | WebSocket, Firebase streams |

## 🏗️ New Architecture

### Directory Structure
```
lib/
├── core/
│   ├── providers/
│   │   ├── dio_provider.dart          # Dio client provider
│   │   ├── locale_provider.dart       # App locale provider
│   │   └── router_provider.dart       # GoRouter provider
│   └── utils/
├── domain/
│   ├── entities/
│   └── repositories/
├── data/
│   ├── models/                        # Freezed data models
│   ├── repositories/
│   └── datasources/
└── presentation/
    ├── features/
    │   ├── auth/
    │   │   ├── providers/
    │   │   │   └── auth_provider.dart
    │   │   └── pages/
    │   ├── home/
    │   │   ├── providers/
    │   │   │   ├── sbt_provider.dart
    │   │   │   ├── stack_provider.dart
    │   │   │   └── bids_provider.dart
    │   │   └── pages/
    │   └── profile/
    └── shared/
        └── providers/
```

## 🔄 Refactored Providers

### 1. Core Providers

#### `core/providers/dio_provider.dart`
```dart
@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final locale = ref.watch(localeProvider);
  final dio = Dio(BaseOptions(
    baseUrl: Constants.testApiBaseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  
  // Add interceptors
  dio.interceptors.addAll([...]);
  
  return dio;
}
```

#### `core/providers/locale_provider.dart`
```dart
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    _loadSavedLocale();
    return const Locale('hi');
  }

  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'en'
        ? const Locale('hi')
        : const Locale('en');
    state = newLocale;
    await _saveLocale(newLocale);
  }
}
```

### 2. Repository Providers

```dart
// Use keepAlive for repositories
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final locale = ref.watch(localeProvider);
  return AuthRepositoryImpl(locale);
}

@Riverpod(keepAlive: true)
SbtRepository sbtRepository(SbtRepositoryRef ref) {
  final locale = ref.watch(localeProvider);
  return SbtRepositoryImpl(locale);
}
```

### 3. Feature Providers with AsyncNotifier

#### Auth Provider
```dart
@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<AuthState> build() async {
    // Check if user is logged in
    if (SharedPreferencesService.isLoggedIn) {
      return const AuthState.authenticated();
    }
    return const AuthState.unauthenticated();
  }

  Future<void> sendOtp(String phoneNumber) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await ref.read(authRepositoryProvider).sendOtp(phoneNumber);
      if (response['status'] == 1) {
        return const AuthState.otpSent();
      }
      throw response['message'] ?? 'Failed to send OTP';
    });
  }

  Future<void> verifyOtp(String phone, String otp) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await ref.read(authRepositoryProvider).verifyOtp(phone, otp);
      if (response['status'] == 1) {
        await SharedPreferencesService.saveCompleteLoginData(response);
        return const AuthState.authenticated();
      }
      throw response['message'] ?? 'Invalid OTP';
    });
  }
}

// Using Freezed for state
@freezed
class AuthState with _$AuthState {
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.otpSent() = _OtpSent;
  const factory AuthState.authenticated() = _Authenticated;
}
```

#### SBT Provider
```dart
@riverpod
class SbtProducts extends _$SbtProducts {
  @override
  FutureOr<SbtProductResponse> build() async {
    return await ref.read(sbtRepositoryProvider).getSbtProducts();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(sbtRepositoryProvider).getSbtProducts(),
    );
  }
}

// For actions
@riverpod
class SbtActions extends _$SbtActions {
  @override
  void build() {}

  Future<void> saveTrade({
    required String productId,
    required String districtId,
    required String commodity,
    required String qty,
    required String type,
    required String price,
    required String userId,
  }) async {
    final response = await ref.read(sbtRepositoryProvider).saveTrade(
      productId,
      districtId,
      commodity,
      qty,
      type,
      price,
      userId,
    );
    
    if (response['status'] == 1) {
      // Refresh products after successful save
      ref.invalidate(sbtProductsProvider);
    }
  }
}
```

### 4. Family Providers for Dynamic Data

```dart
// For fetching data based on parameters
@riverpod
Future<TradeListModel> tradeList(TradeListRef ref, String productId) async {
  return await ref.read(bidsRepositoryProvider).getTradeList(productId);
}

@riverpod
Future<DeliveryCentersModel> deliveryCenters(
  DeliveryCentersRef ref,
  String productId,
) async {
  return await ref.read(sbtRepositoryProvider).getDeliveryCenters(productId);
}

// Usage in UI
final tradeList = ref.watch(tradeListProvider('product-123'));
```

## 📱 UI Integration

### ConsumerWidget vs Consumer

```dart
// BAD - StatefulWidget with ConsumerState
class MyPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

// GOOD - Use ConsumerWidget when possible
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(sbtProductsProvider);
    
    return products.when(
      data: (data) => ListView(...),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}

// GOOD - Use Consumer for partial rebuilds
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Only this Consumer rebuilds when state changes
        Consumer(
          builder: (context, ref, child) {
            final count = ref.watch(counterProvider);
            return Text('Count: $count');
          },
        ),
        // This doesn't rebuild
        ExpensiveWidget(),
      ],
    );
  }
}
```

### Reading vs Watching

```dart
// BAD - Watching when you should read
onPressed: () {
  final notifier = ref.watch(myProvider.notifier); // Rebuilds on every state change!
  notifier.increment();
}

// GOOD - Read for one-time access
onPressed: () {
  ref.read(myProvider.notifier).increment();
}

// GOOD - Watch for reactive updates
Widget build(BuildContext context, WidgetRef ref) {
  final count = ref.watch(myProvider); // Rebuilds when count changes
  return Text('$count');
}
```

### Handling AsyncValue

```dart
final asyncData = ref.watch(myAsyncProvider);

// Method 1: Using .when()
return asyncData.when(
  data: (data) => DataWidget(data),
  loading: () => LoadingWidget(),
  error: (err, stack) => ErrorWidget(err),
);

// Method 2: Pattern matching
return switch (asyncData) {
  AsyncData(:final value) => DataWidget(value),
  AsyncLoading() => LoadingWidget(),
  AsyncError(:final error) => ErrorWidget(error),
};

// Method 3: Manual checking
if (asyncData.isLoading) {
  return LoadingWidget();
}
if (asyncData.hasError) {
  return ErrorWidget(asyncData.error);
}
return DataWidget(asyncData.value!);
```

## 🔧 Code Generation

### Setup
1. Add dependencies to `pubspec.yaml`
2. Run code generation:
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch mode for development:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## ✅ Migration Checklist

### Phase 1: Core Setup
- [x] Add freezed and riverpod_generator dependencies
- [x] Create core providers (Dio, Locale, Router)
- [ ] Generate code with build_runner

### Phase 2: Repository Layer
- [ ] Refactor repository providers with @riverpod annotation
- [ ] Ensure repositories are keepAlive
- [ ] Add proper error handling

### Phase 3: State Layer
- [ ] Convert state classes to Freezed models
- [ ] Refactor Notifiers to AsyncNotifiers
- [ ] Use AsyncValue for loading/error/data states
- [ ] Replace manual state management with .when()

### Phase 4: UI Layer
- [ ] Convert ConsumerStatefulWidget to ConsumerWidget where possible
- [ ] Replace ref.watch() with ref.listen() for side effects
- [ ] Use ref.read() for one-time actions
- [ ] Handle AsyncValue properly in all screens

### Phase 5: Testing
- [ ] Update tests for new provider structure
- [ ] Add provider tests with ProviderContainer
- [ ] Test state transitions

## 🎨 Best Practices

### 1. Provider Scope
- Use `keepAlive: true` for repositories and services
- Let data providers auto-dispose when not needed
- Use `ref.keepAlive()` in build() for conditional keepAlive

### 2. Error Handling
```dart
// GOOD - Let AsyncValue handle errors
state = await AsyncValue.guard(() async {
  return await repository.fetchData();
});

// Show errors in UI
asyncData.when(
  error: (err, stack) {
    // Log error
    logger.error(err, stack);
    // Show user-friendly message
    return ErrorWidget(getUserMessage(err));
  },
  ...
);
```

### 3. State Updates
```dart
// BAD - Mutating state directly
state.list.add(item); // Won't trigger rebuild!

// GOOD - Create new state
state = state.copyWith(
  list: [...state.list, item],
);

// GOOD - With Freezed
state = state.copyWith(list: [...state.list, item]);
```

### 4. Provider Dependencies
```dart
// GOOD - Declare dependencies explicitly
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  MyState build() {
    // Dependencies are tracked automatically
    final auth = ref.watch(authProvider);
    final locale = ref.watch(localeProvider);
    
    return MyState(auth: auth, locale: locale);
  }
}
```

### 5. Listening to Changes
```dart
// For navigation or showing snackbars
ref.listen(authProvider, (previous, next) {
  if (next is AsyncData && next.value.isAuthenticated) {
    context.go('/home');
  }
});

// For side effects
ref.listen(cartProvider, (previous, next) {
  if (next.items.length > 10) {
    showDialog(...);
  }
});
```

## 📚 Resources

- [Riverpod Documentation](https://riverpod.dev)
- [Riverpod Architecture](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/)
- [AsyncNotifier Guide](https://riverpod.dev/docs/concepts/async_notifier)
- [Freezed Package](https://pub.dev/packages/freezed)
- [Code Generation](https://riverpod.dev/docs/concepts/about_code_generation)

## 🚀 Next Steps

1. Run `flutter pub get` to install new dependencies
2. Run `flutter pub run build_runner build --delete-conflicting-outputs`
3. Start migrating providers one feature at a time
4. Update UI to use new provider patterns
5. Test thoroughly after each migration step

---

**Note**: This is a gradual migration. The app will continue to work during the migration as we refactor one feature at a time.
