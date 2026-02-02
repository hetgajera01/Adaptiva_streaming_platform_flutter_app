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

