# UI Component Refactoring Examples

This guide shows how to refactor UI components to use the new Riverpod providers with AsyncValue and Freezed states.

## Table of Contents
1. [Auth UI Components](#auth-ui-components)
2. [SBT UI Components](#sbt-ui-components)
3. [Common Patterns](#common-patterns)
4. [Best Practices](#best-practices)

---

## Auth UI Components

### OLD: Login Screen with Manual State Management

```dart
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      await ref.read(authProvider.notifier).sendOtp(_phoneController.text);
      // Navigate to OTP screen
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: _phoneController),
          if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: _isLoading ? null : _sendOtp,
            child: _isLoading 
              ? CircularProgressIndicator()
              : Text('Send OTP'),
          ),
        ],
      ),
    );
  }
}
```

### NEW: Login Screen with Freezed State

```dart
class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    // Listen for state changes and navigate accordingly
    ref.listen<AuthState>(authProvider, (previous, next) {
      next.maybeWhen(
        otpSent: (phoneNumber) {
          // Navigate to OTP verification screen
          context.push('/otp-verification', extra: phoneNumber);
        },
        error: (message) {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: (value) => _phoneNumber = value,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              // Show error when in error state
              errorText: authState.maybeWhen(
                error: (message) => message,
                orElse: () => null,
              ),
            ),
          ),
          
          ElevatedButton(
            onPressed: authState is _Loading 
              ? null 
              : () => ref.read(authProvider.notifier).sendOtp(_phoneNumber),
            child: authState.maybeWhen(
              loading: () => CircularProgressIndicator(),
              orElse: () => Text('Send OTP'),
            ),
          ),
        ],
      ),
    );
  }
  
  String _phoneNumber = '';
}
```

### OTP Verification Screen

```dart
class OtpVerificationScreen extends ConsumerWidget {
  final String phoneNumber;
  
  const OtpVerificationScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    // Handle authentication success
    ref.listen<AuthState>(authProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (userData) {
          // Navigate to home
          context.go('/home');
        },
        partialLogin: (phone, response) {
          // Navigate to profile completion
          context.push('/complete-profile');
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Column(
        children: [
          Text('Enter OTP sent to $phoneNumber'),
          
          PinCodeTextField(
            length: 6,
            onCompleted: (otp) {
              ref.read(authProvider.notifier).verifyOtp(phoneNumber, otp);
            },
          ),
          
          if (authState is _Loading)
            CircularProgressIndicator(),
        ],
      ),
    );
  }
}
```

---

## SBT UI Components

### OLD: SBT Products Screen with Manual State

```dart
class SbtProductsScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SbtProductsScreen> createState() => _SbtProductsScreenState();
}

class _SbtProductsScreenState extends ConsumerState<SbtProductsScreen> {
  @override
  void initState() {
    super.initState();
    // Manual fetch on init
    Future.microtask(() => ref.read(sbtStateProvider.notifier).fetchSbtProducts());
  }

  @override
  Widget build(BuildContext context) {
    final sbtState = ref.watch(sbtStateProvider);
    
    if (sbtState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (sbtState.error != null) {
      return Center(child: Text('Error: ${sbtState.error}'));
    }
    
    if (sbtState.sbtProductData == null) {
      return Center(child: Text('No products'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(sbtStateProvider.notifier).fetchSbtProducts(),
      child: ListView.builder(
        itemCount: sbtState.sbtProductData!.data?.length ?? 0,
        itemBuilder: (context, index) {
          final product = sbtState.sbtProductData!.data![index];
          return ProductTile(product: product);
        },
      ),
    );
  }
}
```

### NEW: SBT Products Screen with Freezed State

```dart
class SbtProductsScreen extends ConsumerWidget {
  const SbtProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(sbtProductsProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('SBT Products')),
      body: productsState.when(
        initial: () => Center(child: Text('Initializing...')),
        
        loading: () => Center(child: CircularProgressIndicator()),
        
        error: (message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Error: $message'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(sbtProductsProvider.notifier).refresh(),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
        
        loaded: (products) {
          if (products.data == null || products.data!.isEmpty) {
            return Center(child: Text('No products available'));
          }
          
          return RefreshIndicator(
            onRefresh: () => ref.read(sbtProductsProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: products.data!.length,
              itemBuilder: (context, index) {
                final product = products.data![index];
                return ProductTile(product: product);
              },
            ),
          );
        },
      ),
    );
  }
}
```

### Product Detail Screen with Family Providers

```dart
class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  
  const ProductDetailScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch multiple family providers for this product
    final deliveryCentersState = ref.watch(deliveryCentersProvider(productId));
    final matchedOrdersState = ref.watch(matchedOrdersProvider(productId));
    final tradeListState = ref.watch(tradeListProvider(productId));
    
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Info Section
            ProductInfoCard(productId: productId),
            
            // Delivery Centers Section
            SectionHeader(title: 'Delivery Centers'),
            deliveryCentersState.when(
              initial: () => Text('Loading...'),
              loading: () => CircularProgressIndicator(),
              error: (message) => ErrorWidget(message: message),
              loaded: (centers) => DeliveryCentersList(centers: centers),
            ),
            
            // Matched Orders Section
            SectionHeader(title: 'Matched Orders'),
            matchedOrdersState.when(
              initial: () => Text('Loading...'),
              loading: () => CircularProgressIndicator(),
              error: (message) => ErrorWidget(message: message),
              loaded: (orders) => MatchedOrdersList(orders: orders),
            ),
            
            // Trade List Section
            SectionHeader(title: 'Trade History'),
            tradeListState.when(
              initial: () => Text('Loading...'),
              loading: () => CircularProgressIndicator(),
              error: (message) => ErrorWidget(message: message),
              loaded: (tradeList) => TradeHistoryList(tradeList: tradeList),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Trade Form with Actions

```dart
class TradeFormScreen extends ConsumerStatefulWidget {
  final String productId;
  
  const TradeFormScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  ConsumerState<TradeFormScreen> createState() => _TradeFormScreenState();
}

class _TradeFormScreenState extends ConsumerState<TradeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isSubmitting = false;
  
  String? _districtId;
  String? _commodity;
  String? _type;

  Future<void> _submitTrade() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSubmitting = true);
    
    try {
      final success = await ref.read(tradeActionsProvider).saveTrade(
        productId: widget.productId,
        districtId: _districtId!,
        commodity: _commodity!,
        qty: _qtyController.text,
        type: _type!,
        price: _priceController.text,
        userId: SharedPreferencesService.userId!,
      );
      
      if (success && mounted) {
        // Navigate back
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Trade')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'District'),
              value: _districtId,
              onChanged: (value) => setState(() => _districtId = value),
              validator: (value) => value == null ? 'Required' : null,
              items: [/* district items */],
            ),
            
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Commodity'),
              value: _commodity,
              onChanged: (value) => setState(() => _commodity = value),
              validator: (value) => value == null ? 'Required' : null,
              items: [/* commodity items */],
            ),
            
            TextFormField(
              controller: _qtyController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Type'),
              value: _type,
              onChanged: (value) => setState(() => _type = value),
              validator: (value) => value == null ? 'Required' : null,
              items: [
                DropdownMenuItem(value: 'buy', child: Text('Buy')),
                DropdownMenuItem(value: 'sell', child: Text('Sell')),
              ],
            ),
            
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            
            SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitTrade,
              child: _isSubmitting
                ? CircularProgressIndicator()
                : Text('Submit Trade'),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
```

---

## Common Patterns

### Pattern 1: Loading/Error/Data States with .when()

```dart
// Simple pattern for displaying data
asyncValueState.when(
  initial: () => Text('Ready'),
  loading: () => CircularProgressIndicator(),
  error: (message) => Text('Error: $message'),
  loaded: (data) => DataWidget(data: data),
)
```

### Pattern 2: Using ref.listen for Side Effects

```dart
// Listen for state changes and perform side effects (navigation, snackbars, etc.)
ref.listen<AuthState>(authProvider, (previous, next) {
  next.maybeWhen(
    authenticated: (_) => context.go('/home'),
    error: (message) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    ),
    orElse: () {},
  );
});
```

### Pattern 3: Conditional UI Based on State

```dart
// Show different UI based on current state
final isLoading = authState is _Loading;
final errorMessage = authState.maybeWhen(
  error: (message) => message,
  orElse: () => null,
);

ElevatedButton(
  onPressed: isLoading ? null : _handleSubmit,
  child: isLoading 
    ? CircularProgressIndicator()
    : Text('Submit'),
)
```

### Pattern 4: Using ref.read for Actions

```dart
// Use ref.read in callbacks/event handlers
ElevatedButton(
  onPressed: () {
    // CORRECT: Use ref.read in callbacks
    ref.read(authProvider.notifier).sendOtp(phoneNumber);
  },
  child: Text('Send OTP'),
)

// DON'T DO THIS: ref.watch in callbacks causes rebuilds
ElevatedButton(
  onPressed: () {
    // WRONG: Don't use ref.watch in callbacks
    ref.watch(authProvider.notifier).sendOtp(phoneNumber);
  },
  child: Text('Send OTP'),
)
```

### Pattern 5: Family Providers for Parameterized Data

```dart
// Access different data for different parameters
final orders1 = ref.watch(matchedOrdersProvider('product-1'));
final orders2 = ref.watch(matchedOrdersProvider('product-2'));

// Each creates an independent state
```

### Pattern 6: Multiple Listeners

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // Listen to multiple providers
  ref.listen<AuthState>(authProvider, (prev, next) {
    // Handle auth state changes
  });
  
  ref.listen<SbtProductsState>(sbtProductsProvider, (prev, next) {
    // Handle products state changes
  });
  
  // Build UI
  return Scaffold(...);
}
```

---

## Best Practices

### ✅ DO: Use ConsumerWidget Instead of ConsumerStatefulWidget

```dart
// GOOD: Stateless with hooks or ConsumerWidget
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    return /* widget tree */;
  }
}
```

```dart
// AVOID: StatefulWidget unless you need local state or lifecycle
class MyScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}
```

### ✅ DO: Use .when() for Freezed Unions

```dart
// GOOD: Exhaustive pattern matching
state.when(
  initial: () => InitialWidget(),
  loading: () => LoadingWidget(),
  error: (msg) => ErrorWidget(msg),
  loaded: (data) => DataWidget(data),
)
```

```dart
// AVOID: Manual type checking
if (state is _Loading) {
  return LoadingWidget();
} else if (state is _Error) {
  return ErrorWidget((state as _Error).message);
}
```

### ✅ DO: Separate Data Providers from Action Providers

```dart
// GOOD: Separate concerns
final productsProvider = NotifierProvider<...>(...);  // Data
final tradeActionsProvider = Provider<TradeActions>(...);  // Actions

// Use in UI
final products = ref.watch(productsProvider);
final actions = ref.read(tradeActionsProvider);
```

### ✅ DO: Use ref.listen for Side Effects

```dart
// GOOD: Side effects in listener
ref.listen<AuthState>(authProvider, (prev, next) {
  next.maybeWhen(
    authenticated: (_) => Navigator.push(...),
    orElse: () {},
  );
});
```

```dart
// AVOID: Side effects in build method
@override
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(authProvider);
  if (state is _Authenticated) {
    Navigator.push(...);  // DON'T DO THIS
  }
  return /* widget */;
}
```

### ✅ DO: Keep State Immutable

```dart
// GOOD: Freezed creates immutable classes
@freezed
class MyState with _$MyState {
  const factory MyState({required int value}) = _MyState;
}
```

```dart
// AVOID: Mutable state classes
class MyState {
  int value;  // Mutable field
  MyState(this.value);
}
```

### ✅ DO: Use Family Providers for Parameterized Data

```dart
// GOOD: Family provider for different parameters
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  return fetchUser(userId);
});

// Usage
final user1 = ref.watch(userProvider('user-1'));
final user2 = ref.watch(userProvider('user-2'));
```

### ✅ DO: Handle Loading and Error States

```dart
// GOOD: Handle all states
state.when(
  initial: () => Text('Ready'),
  loading: () => CircularProgressIndicator(),
  error: (msg) => ErrorRetryWidget(message: msg),
  loaded: (data) => DataList(data),
)
```

```dart
// AVOID: Ignoring error states
state.maybeWhen(
  loaded: (data) => DataList(data),
  orElse: () => SizedBox.shrink(),  // Don't ignore errors
)
```

### ✅ DO: Use keepAlive for Persistent Providers

```dart
// GOOD: Keep repository alive throughout app lifecycle
final repositoryProvider = Provider<Repository>((ref) {
  return RepositoryImpl();
}, keepAlive: true);
```

### ✅ DO: Dispose Resources Properly

```dart
// GOOD: Dispose controllers in StatefulWidget
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

// GOOD: Auto-dispose providers when not needed
final provider = Provider.autoDispose<MyService>((ref) {
  final service = MyService();
  ref.onDispose(() => service.dispose());
  return service;
});
```

---

## Migration Checklist

- [ ] Replace manual state management with Freezed states
- [ ] Use `.when()` instead of manual type checking
- [ ] Move side effects to `ref.listen()`
- [ ] Use `ref.read()` in callbacks/event handlers
- [ ] Use `ref.watch()` only in build methods
- [ ] Convert ConsumerStatefulWidget to ConsumerWidget where possible
- [ ] Add loading and error state handling
- [ ] Use family providers for parameterized data
- [ ] Separate data providers from action providers
- [ ] Add keepAlive to persistent providers
- [ ] Test all user flows after refactoring

---

## Additional Resources

- [Riverpod Documentation](https://riverpod.dev)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [RIVERPOD_REFACTORING_GUIDE.md](./RIVERPOD_REFACTORING_GUIDE.md)
