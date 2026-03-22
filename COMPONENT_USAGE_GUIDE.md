# Flutter UI Components - Code Examples & Usage Guide

## 🎯 Quick Reference

This guide shows how to use all custom components created for the assignment.

---

## 1️⃣ CustomButton Component

### Basic Usage
```dart
import 'package:mad_project/widgets/custom_button.dart';

CustomButton(
  label: 'Sign In',
  onPressed: () {
    // Handle sign in action
  },
)
```

### Advanced Customization
```dart
CustomButton(
  label: 'Login',
  onPressed: _handleLogin,
  backgroundColor: AppTheme.primaryColor,
  textColor: Colors.white,
  borderRadius: AppConstants.radiusLarge,
  height: 48.0,
  icon: Icons.login_rounded,
  isLoading: _isLoading, // Shows loading indicator
)
```

### With Loading State
```dart
bool _isLoading = false;

void _handleLogin() {
  setState(() => _isLoading = true);
  // Perform async operation
  Future.delayed(Duration(seconds: 2), () {
    setState(() => _isLoading = false);
  });
}

// In build method:
CustomButton(
  label: 'Sign In',
  onPressed: _isLoading ? null : _handleLogin,
  isLoading: _isLoading,
)
```

---

## 2️⃣ CustomOutlinedButton Component

### Basic Usage
```dart
CustomOutlinedButton(
  label: 'Create Account',
  onPressed: () {
    // Navigate to sign up
  },
)
```

### With Custom Colors
```dart
CustomOutlinedButton(
  label: 'Cancel',
  onPressed: () => Navigator.pop(context),
  borderColor: AppTheme.errorColor,
  textColor: AppTheme.errorColor,
  icon: Icons.cancel_outlined,
)
```

### Common Patterns
```dart
// Secondary action button
CustomOutlinedButton(
  label: 'Skip',
  onPressed: _skipAction,
)

// Danger action
CustomOutlinedButton(
  label: 'Delete',
  onPressed: _deleteAction,
  borderColor: AppTheme.errorColor,
  textColor: AppTheme.errorColor,
)

// Success action
CustomOutlinedButton(
  label: 'Approve',
  onPressed: _approveAction,
  borderColor: AppTheme.successColor,
  textColor: AppTheme.successColor,
)
```

---

## 3️⃣ CustomTextField Component

### Email Field
```dart
final _emailController = TextEditingController();

CustomTextField(
  label: 'Email Address',
  hint: 'Enter your email',
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  prefixIcon: Icons.email_outlined,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Enter a valid email';
    }
    return null;
  },
)
```

### Password Field
```dart
final _passwordController = TextEditingController();

CustomTextField(
  label: 'Password',
  hint: 'Enter your password',
  controller: _passwordController,
  obscureText: true,
  prefixIcon: Icons.lock_outline,
  suffixIcon: Icons.visibility_outlined,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  },
)
```

### Search Field
```dart
CustomTextField(
  label: 'Search',
  hint: 'Search content...',
  keyboardType: TextInputType.text,
  prefixIcon: Icons.search,
  borderColor: AppTheme.dividerColor,
  focusedBorderColor: AppTheme.primaryColor,
)
```

### Comment/Message Field
```dart
CustomTextField(
  label: 'Your Comment',
  hint: 'Write your thoughts here...',
  maxLines: 4,
  minLines: 2,
)
```

### Validation Form Example
```dart
class MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              if (!value.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          SizedBox(height: AppConstants.spacingMedium),
          CustomTextField(
            label: 'Password',
            controller: _passwordController,
            obscureText: true,
            prefixIcon: Icons.lock_outline,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              if (value.length < 6) return 'Min 6 characters';
              return null;
            },
          ),
          SizedBox(height: AppConstants.spacingLarge),
          CustomButton(
            label: 'Submit',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Process form
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

---

## 4️⃣ CustomCard Component

### Basic Card
```dart
CustomCard(
  child: Column(
    children: [
      Text('Card Title', style: AppTheme.headlineSmall),
      SizedBox(height: 8),
      Text('Card content goes here'),
    ],
  ),
)
```

### Tap Action Card
```dart
CustomCard(
  onTap: () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Card tapped!')),
    );
  },
  child: Text('Tap me!'),
)
```

### Custom Styled Card
```dart
CustomCard(
  padding: EdgeInsets.all(24),
  elevation: 4,
  backgroundColor: Colors.blue.shade50,
  borderRadius: 16,
  child: Column(
    children: [
      Icon(Icons.info, size: 40, color: Colors.blue),
      SizedBox(height: 16),
      Text('Information Card'),
    ],
  ),
)
```

### List of Cards
```dart
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (_, __) => SizedBox(height: 12),
  itemBuilder: (context, index) {
    return CustomCard(
      onTap: () => handleItemTap(items[index]),
      child: ListTile(
        leading: Icon(Icons.item),
        title: Text(items[index].name),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  },
)
```

---

## 5️⃣ FeatureCard Component

### Basic Feature Card
```dart
FeatureCard(
  title: 'Movies',
  description: 'Watch latest blockbuster movies',
  icon: Icons.movie,
  iconColor: AppTheme.primaryColor,
)
```

### Grid of Features
```dart
GridView.count(
  crossAxisCount: 2,
  children: [
    FeatureCard(
      title: 'Movies',
      description: 'Watch latest films',
      icon: Icons.movie,
      iconColor: Colors.blue,
      onTap: () => navigateToMovies(),
    ),
    FeatureCard(
      title: 'Series',
      description: 'Binge-watch shows',
      icon: Icons.tv,
      iconColor: Colors.purple,
      onTap: () => navigateToSeries(),
    ),
    FeatureCard(
      title: 'Documentaries',
      description: 'Learn & discover',
      icon: Icons.document_scanner,
      iconColor: Colors.green,
      onTap: () => navigateToDocs(),
    ),
    FeatureCard(
      title: 'Kids',
      description: 'Safe content',
      icon: Icons.child_care,
      iconColor: Colors.orange,
      onTap: () => navigateToKids(),
    ),
  ],
)
```

### Custom Feature Card Colors
```dart
FeatureCard(
  title: 'Premium',
  description: 'Upgrade for more content',
  icon: Icons.star,
  iconColor: Colors.amber,
  backgroundColor: Colors.amber.shade50,
  onTap: () => showPremiumDialog(),
)
```

---

## 📐 Layout Patterns

### Form Screen
```dart
class FormScreen extends StatefulWidget {
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <TextEditingController>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.spacingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Form fields
                CustomTextField(label: 'Field 1'),
                SizedBox(height: AppConstants.spacingMedium),
                CustomTextField(label: 'Field 2'),
                SizedBox(height: AppConstants.spacingLarge),
                // Submit button
                CustomButton(
                  label: 'Submit',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
```

### Dashboard Screen
```dart
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              color: Colors.blue.shade50,
              padding: EdgeInsets.all(AppConstants.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome!', style: AppTheme.headlineLarge),
                  Text('What would you like to do today?'),
                ],
              ),
            ),
            // Features grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                FeatureCard(...),
                FeatureCard(...),
              ],
            ),
            // Recent items
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return CustomCard(...);
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎨 Spacing & Alignment Patterns

### Vertical Spacing
```dart
Column(
  children: [
    Text('Item 1'),
    SizedBox(height: AppConstants.spacingSmall),      // 8px
    Text('Item 2'),
    SizedBox(height: AppConstants.spacingMedium),     // 16px
    Text('Item 3'),
    SizedBox(height: AppConstants.spacingLarge),      // 24px
    Text('Item 4'),
  ],
)
```

### Horizontal Spacing
```dart
Row(
  children: [
    Text('Item 1'),
    SizedBox(width: AppConstants.spacingMedium),
    Text('Item 2'),
    Spacer(),
    Text('Item 3'),
  ],
)
```

### Padding Pattern
```dart
Padding(
  padding: EdgeInsets.all(AppConstants.spacingMedium),  // All sides
  child: Text('Centered'),
)

// Asymmetric padding
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: AppConstants.spacingLarge,
    vertical: AppConstants.spacingMedium,
  ),
  child: Text('Padded text'),
)
```

---

## 🔄 Responsive Patterns

### Mobile-First Layout
```dart
@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isMobile = screenWidth < AppConstants.mobileBreakpoint;

  return Scaffold(
    body: GridView.count(
      crossAxisCount: isMobile ? 2 : 4,
      children: [...],
    ),
  );
}
```

### SafeArea
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(...),
      ),
    ),
  );
}
```

---

## 🚀 Performance Tips

### Dispose Controllers
```dart
@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  _animationController.dispose();
  super.dispose();
}
```

### Use const Constructors
```dart
// ✅ Good - Creates single instance
const SizedBox(height: 16)

// ❌ Bad - Creates new instance each build
SizedBox(height: 16)
```

### Optimize Lists
```dart
// ✅ Use ListView.builder for large lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => /* item */,
)

// ❌ Avoid ListView for large lists
ListView(
  children: items.map((e) => /* item */).toList(),
)
```

---

## 📱 Screen Size Breakpoints

```dart
// From constants.dart
double mobileBreakpoint = 600.0;      // < 600px
double tabletBreakpoint = 900.0;      // 600-900px
double desktopBreakpoint = 1200.0;    // > 1200px

// Usage
final isMobile = screenWidth < mobileBreakpoint;
final isTablet = screenWidth >= mobileBreakpoint && 
                 screenWidth < desktopBreakpoint;
final isDesktop = screenWidth >= desktopBreakpoint;
```

---

## ✨ Best Practices Summary

1. **Always dispose controllers & animations**
2. **Use constants for spacing & sizing**
3. **Leverage reusable components**
4. **Implement proper error handling**
5. **Add loading states to async operations**
6. **Use SingleChildScrollView for long screens**
7. **Implement form validation**
8. **Provide user feedback (snackbars, dialogs)**
9. **Test on multiple screen sizes**
10. **Keep widgets small & focused**

---

## 6️⃣ Loading — CircularProgressIndicator

### Basic Centered Loading
```dart
// Full-screen centered loader (e.g. while fetching data)
_isLoading
    ? const Center(child: CircularProgressIndicator())
    : _buildContent(),
```

### With Padding
```dart
// Centered loader with surrounding padding
const Padding(
  padding: EdgeInsets.all(AppConstants.spacingXLarge),
  child: Center(child: CircularProgressIndicator()),
)
```

### Custom Color
```dart
// Match loader color to app theme
CircularProgressIndicator(color: AppTheme.accentColor)
```

### Custom Stroke Width (Thin Loader)
```dart
// Thin spinner — useful inside small containers like thumbnails
CircularProgressIndicator(strokeWidth: 2)
```

### Inside a Button (CustomButton)
```dart
// The CustomButton widget already supports this:
CustomButton(
  label: 'Sign In',
  onPressed: _handleSignIn,
  isLoading: _isLoading, // Automatically shows spinner when true
)
```

### Image Loading Placeholder
```dart
Image.network(
  imageUrl,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child; // Image loaded
    return Container(
      color: AppTheme.primaryColor.withOpacity(0.1),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return Container(
      color: AppTheme.primaryColor.withOpacity(0.1),
      child: Center(
        child: Icon(Icons.broken_image, color: AppTheme.textTertiary),
      ),
    );
  },
)
```

### Full-Screen Loading Overlay (e.g. Sign Out)
```dart
body: _isLoggingOut
    ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.accentColor),
            const SizedBox(height: 16),
            Text(
              'Signing out...',
              style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      )
    : _buildMainContent(),
```

### setState Loading Pattern
```dart
bool _isLoading = true;

Future<void> _loadData() async {
  setState(() => _isLoading = true);

  final data = await _service.fetchData();

  if (mounted) {
    setState(() {
      _items = data;
      _isLoading = false;
    });
  }
}

// In build:
@override
Widget build(BuildContext context) {
  if (_isLoading) {
    return const Center(child: CircularProgressIndicator());
  }
  return ListView.builder(...);
}
```

---

## 7️⃣ Navigation Implementation

### Simple Push Navigation
```dart
// Navigate to a new screen (pushes onto the stack)
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const CategoriesScreen(),
  ),
);
```

### Navigation with Parameters
```dart
// Pass data to the destination screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => VideoPlayerScreen(
      video: video,
      userId: user.id,
    ),
  ),
);
```

### Navigate & Refresh on Return
```dart
// Wait for the pushed screen to pop, then reload data
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AdminUploadScreen(
      authService: _authService,
    ),
  ),
).then((_) => _loadVideos()); // Refresh list after returning
```

### Replace Entire Stack (pushAndRemoveUntil)
```dart
// After sign-in: push Home and remove all previous routes
Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(
    builder: (context) => HomeScreen(onSignOut: _handleSignOut),
  ),
  (route) => false, // Remove ALL previous routes
);
```

### Sign-Out Navigation (Clear & Go to Sign In)
```dart
void _handleSignOut() {
  widget.authService.signOut().then((_) {
    setState(() => _isSignedIn = false);
    _navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => SignInScreen(
          authService: widget.authService,
          onSignInSuccess: _handleSignIn,
          onNavigateToSignUp: _navigateToSignUp,
        ),
      ),
      (route) => false,
    );
  });
}
```

### GlobalKey NavigatorState (Root-Level Nav Control)
```dart
class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey, // Attach key to MaterialApp
      home: _isSignedIn ? HomeScreen(...) : SignInScreen(...),
    );
  }

  void _navigateToSignUp() {
    // Navigate from anywhere using the global key
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => SignUpScreen(...),
      ),
    );
  }
}
```

### BottomNavigationBar with Switch-Case Routing
```dart
BottomNavigationBar(
  currentIndex: _selectedIndex,
  type: BottomNavigationBarType.fixed,
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ],
  onTap: (index) {
    setState(() => _selectedIndex = index);
    _handleBottomNavigation(index);
  },
)

void _handleBottomNavigation(int index) {
  switch (index) {
    case 0:
      break; // Already on Home
    case 1:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CategoriesScreen()),
      );
      break;
    case 2:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsScreen(onSignOut: widget.onSignOut),
        ),
      );
      break;
    case 3:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(onSignOut: widget.onSignOut),
        ),
      );
      break;
  }
}
```

### Conditional Auth-Based Home Screen
```dart
// In MaterialApp — show different screens based on auth state
home: _isSignedIn
    ? HomeScreen(onSignOut: _handleSignOut)
    : SignInScreen(
        authService: widget.authService,
        onSignInSuccess: _handleSignIn,
        onNavigateToSignUp: _navigateToSignUp,
      ),
```

---

## 8️⃣ State Management Logic

### setState for Local UI State
```dart
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Video> _allVideos = [];
  bool _isLoading = true;

  Future<void> _loadVideos() async {
    setState(() => _isLoading = true);

    final videos = await _databaseService.getVideos();

    if (mounted) {
      setState(() {
        _allVideos = videos;
        _isLoading = false;
      });
    }
  }
}
```

### Callback-Based State Lifting (Parent ↔ Child)
```dart
// Parent (MyApp) defines callbacks
class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  void _handleSignIn() {
    setState(() => _isSignedIn = true);
  }

  void _handleSignOut() {
    widget.authService.signOut().then((_) {
      setState(() => _isSignedIn = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _isSignedIn
          ? HomeScreen(onSignOut: _handleSignOut)      // Pass callback ↓
          : SignInScreen(
              onSignInSuccess: _handleSignIn,           // Pass callback ↓
              onNavigateToSignUp: _navigateToSignUp,
            ),
    );
  }
}

// Child (HomeScreen) receives and calls the callback
class HomeScreen extends StatefulWidget {
  final VoidCallback onSignOut; // Callback from parent
  const HomeScreen({super.key, required this.onSignOut});
}

// Usage in child:
widget.onSignOut(); // Triggers parent state change
```

### Singleton Service Pattern (AuthService)
```dart
class AuthService {
  // Private singleton instance
  static final AuthService _instance = AuthService._internal();

  // Factory constructor returns the same instance
  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  User? _currentUser;

  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  User? get currentUser => _currentUser;
}

// Usage — always gets the same instance:
final authService = AuthService();
if (authService.isAdmin) { /* show admin UI */ }
```

### Loading State Pattern
```dart
bool _isLoading = false;

void _handleSignIn() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);

    try {
      await widget.authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) {
        setState(() => _isLoading = false);
        // Navigate on success
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      _showErrorSnackBar(e.message);
    }
  }
}

// In build — disable button while loading:
CustomButton(
  label: 'Sign In',
  onPressed: _handleSignIn,
  isLoading: _isLoading,
)
```

### Settings State with SharedPreferences
```dart
class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedVideoQuality = 'Auto';
  bool _notificationsEnabled = true;
  bool _autoPlayEnabled = true;
  bool _downloadOnWifiOnly = true;

  // Load on init
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedVideoQuality = prefs.getString('video_quality') ?? 'Auto';
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _autoPlayEnabled = prefs.getBool('autoplay_enabled') ?? true;
      _downloadOnWifiOnly = prefs.getBool('download_wifi_only') ?? true;
    });
  }

  // Save on change
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('video_quality', _selectedVideoQuality);
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('autoplay_enabled', _autoPlayEnabled);
    await prefs.setBool('download_wifi_only', _downloadOnWifiOnly);
  }

  // Toggle example:
  _buildSwitchTile(
    title: 'Auto-Play',
    value: _autoPlayEnabled,
    onChanged: (value) {
      setState(() => _autoPlayEnabled = value);
      _saveSettings(); // Persist immediately
    },
  )
}
```

---

## 9️⃣ Session Persistence Code

### Session Storage Keys
```dart
// In AuthService — SharedPreferences keys
static const String _userKey = 'current_user';
static const String _isLoggedInKey = 'is_logged_in';
static const String _sessionTokenKey = 'session_token';
```

### Initialize Auth & Restore Session on App Start
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authService = AuthService();
  await authService.initialize(); // Restores session from SharedPreferences

  runApp(MyApp(authService: authService));
}
```

### AuthService.initialize()
```dart
Future<void> initialize() async {
  _prefs = await SharedPreferences.getInstance();
  _firestore = FirebaseFirestore.instance;
  _auth = firebase_auth.FirebaseAuth.instance;
  await _restoreSession();
}
```

### Restore Session from SharedPreferences
```dart
Future<void> _restoreSession() async {
  try {
    final isLoggedIn = _prefs.getBool(_isLoggedInKey) ?? false;
    final userJson = _prefs.getString(_userKey);

    if (isLoggedIn && userJson != null) {
      _currentUser = User.fromJson(
        jsonDecode(userJson) as Map<String, dynamic>,
      );
    }
  } catch (e) {
    print('Error restoring session: $e');
    _currentUser = null;
  }
}
```

### Save Session After Sign-In / Register
```dart
Future<void> _saveUserSession(User user) async {
  try {
    _currentUser = user;
    await _prefs.setBool(_isLoggedInKey, true);
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    await _prefs.setString(
      _sessionTokenKey,
      'session_${user.id}_${DateTime.now().millisecondsSinceEpoch}',
    );
  } catch (e) {
    throw AuthException('Failed to save session: $e');
  }
}
```

### Clear Session on Sign-Out
```dart
Future<void> signOut() async {
  try {
    await _auth.signOut();          // Firebase sign-out
    _currentUser = null;            // Clear in-memory user
    await _prefs.remove(_isLoggedInKey);
    await _prefs.remove(_userKey);
    await _prefs.remove(_sessionTokenKey);
  } catch (e) {
    throw AuthException('Failed to sign out: $e');
  }
}
```

### User Model Serialization (for SharedPreferences)
```dart
class User {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final String role;

  bool get isAdmin => role == 'admin';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'role': role,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      role: json['role'] as String? ?? 'user',
    );
  }
}
```

### Check Session Validity
```dart
Future<bool> isSessionValid() async {
  try {
    final sessionToken = _prefs.getString(_sessionTokenKey);
    return sessionToken != null && _currentUser != null;
  } catch (e) {
    return false;
  }
}
```

### Check Login Status on App Launch
```dart
class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    setState(() {
      _isSignedIn = widget.authService.isLoggedIn;
    });
  }
}
```

---

## 🔟 Model Classes

### User Model (`services/auth_service.dart`)
```dart
class User {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final String role; // "user" | "admin"

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.role = 'user',
  });

  /// Whether this user has admin privileges
  bool get isAdmin => role == 'admin';

  /// Convert User to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'role': role,
    };
  }

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      role: json['role'] as String? ?? 'user',
    );
  }
}
```

---

### Video Model (`models/video.dart`)
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String thumbnailUrl;
  final String videoUrl;
  final int duration; // in seconds
  final String createdAt;
  final bool featured;
  final bool isActive;
  final int viewCount;
  final List<String> tags;
  final String? addedBy; // Admin UID who uploaded the video

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.createdAt,
    this.featured = false,
    this.isActive = true,
    this.viewCount = 0,
    this.tags = const [],
    this.addedBy,
  });

  /// Create Video from Firestore document data (handles Timestamp or String)
  factory Video.fromJson(Map<String, dynamic> json) {
    // createdAt can be a Firestore Timestamp or an ISO string
    String createdAtStr;
    final raw = json['createdAt'];
    if (raw is Timestamp) {
      createdAtStr = raw.toDate().toIso8601String();
    } else {
      createdAtStr = (raw as String?) ?? '';
    }

    // tags can be List<dynamic> from Firestore
    final rawTags = json['tags'];
    final List<String> tagsList = rawTags != null
        ? List<String>.from(rawTags as List)
        : [];

    return Video(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      categoryId: json['categoryId'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      videoUrl: json['videoUrl'] as String,
      duration: (json['duration'] as num).toInt(),
      createdAt: createdAtStr,
      featured: json['featured'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      tags: tagsList,
      addedBy: json['addedBy'] as String?,
    );
  }

  /// Convert Video to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'duration': duration,
      'createdAt': createdAt,
      'featured': featured,
      'isActive': isActive,
      'viewCount': viewCount,
      'tags': tags,
      if (addedBy != null) 'addedBy': addedBy,
    };
  }

  /// Get formatted duration (e.g., "1h 30m")
  String getFormattedDuration() {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
```

---

### Category Model (`models/category.dart`)
```dart
class Category {
  final String id;
  final String name;
  final String icon;
  final String color1;
  final String color2;
  final int order;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color1,
    required this.color2,
    required this.order,
  });

  /// Create Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color1: json['color1'] as String,
      color2: json['color2'] as String,
      order: json['order'] as int,
    );
  }

  /// Convert Category to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color1': color1,
      'color2': color2,
      'order': order,
    };
  }
}
```

---

### WatchHistory Model (`models/watch_history.dart`)
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class WatchHistory {
  final String videoId;
  final String watchedAt;
  final double progress; // 0–100

  WatchHistory({
    required this.videoId,
    required this.watchedAt,
    this.progress = 0.0,
  });

  /// Create WatchHistory from Firestore document data (handles Timestamp or String)
  factory WatchHistory.fromJson(Map<String, dynamic> json) {
    String watchedAtStr;
    final raw = json['watchedAt'];
    if (raw is Timestamp) {
      watchedAtStr = raw.toDate().toIso8601String();
    } else {
      watchedAtStr = (raw as String?) ?? '';
    }

    return WatchHistory(
      videoId: json['videoId'] as String,
      watchedAt: watchedAtStr,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert WatchHistory to JSON
  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'watchedAt': watchedAt,
      'progress': progress,
    };
  }
}
```

---

### Post Model (`models/post.dart`)
Generic example for REST API data (e.g. JSONPlaceholder).

```dart
class Post {
  final int id;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.title,
    required this.body,
  });

  /// Factory constructor for JSON mapping
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
```

---

## 11 API Data Model Patterns

### Flutter Model Pattern (Dart)
Use this pattern for mapping API responses to strongly-typed objects in Flutter.

```dart
class Post {
  final int id;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.title,
    required this.body,
  });

  /// Factory constructor to create a Post from a JSON map
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  /// Helper to convert Post back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
```

---

### Android Model Pattern (Java/Kotlin)

#### Kotlin (Recommended)
```kotlin
data class Post(
    val id: Int,
    val title: String,
    val body: String
)
```

#### Java (Standard)
```java
public class Post {
    private int id;
    private String title;
    private String body;

    public Post(int id, String title, String body) {
        this.id = id;
        this.title = title;
        this.body = body;
    }

    // Getters and Setters
    public int getId() { return id; }
    public String getTitle() { return title; }
    public String getBody() { return body; }
}
```

---

