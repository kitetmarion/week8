// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../services/auth_service.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_text_field.dart';
// import 'main_screen.dart';

// class ProfileSetupScreen extends StatefulWidget {
//   @override
//   _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
// }

// class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _ageController = TextEditingController();
//   final _weightController = TextEditingController();
//   final _heightController = TextEditingController();
  
//   bool _isLoading = false;
//   String _errorMessage = '';

//   @override
//   void dispose() {
//     _ageController.dispose();
//     _weightController.dispose();
//     _heightController.dispose();
//     super.dispose();
//   }

//   double _calculateBMI(double weight, double height) {
//     // Convert height from cm to meters and calculate BMI
//     double heightInMeters = height / 100;
//     return weight / (heightInMeters * heightInMeters);
//   }

//   String _getBMICategory(double bmi) {
//     if (bmi < 18.5) return 'Underweight';
//     if (bmi < 25) return 'Normal weight';
//     if (bmi < 30) return 'Overweight';
//     return 'Obese';
//   }

//   Future<void> _submitProfile() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });

//     try {
//       final age = int.parse(_ageController.text);
//       final weight = double.parse(_weightController.text);
//       final height = double.parse(_heightController.text);
      
//       // Calculate BMI
//       final bmi = _calculateBMI(weight, height);
//       final bmiCategory = _getBMICategory(bmi);

//       // Prepare profile data
//       final profileData = {
//         'age': age,
//         'weight': weight,
//         'height': height,
//         'bmi': double.parse(bmi.toStringAsFixed(2)),
//         'bmiCategory': bmiCategory,
//         'profileCompleted': true,
//         'profileCompletedAt': DateTime.now().toIso8601String(),
//       };

//       // Save to Firestore
//       bool success = await AuthService.updateUserProfile(profileData);

//       if (success) {
//         // Navigate to main screen
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => MainScreen()),
//         );
//       } else {
//         setState(() {
//           _errorMessage = 'Failed to save profile. Please try again.';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Invalid input. Please check your entries.';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('Complete Your Profile'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 20),
                
//                 // Welcome message
//                 Text(
//                   'Let\'s set up your profile',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
                
//                 SizedBox(height: 8),
                
//                 Text(
//                   'We need some basic information to personalize your fitness journey',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[600],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
                
//                 SizedBox(height: 40),

//                 // Age field
//                 CustomTextField(
//                   controller: _ageController,
//                   label: 'Age',
//                   hint: 'Enter your age',
//                   prefixIcon: Icons.cake,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(3),
//                   ],
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your age';
//                     }
//                     final age = int.tryParse(value);
//                     if (age == null || age < 13 || age > 120) {
//                       return 'Please enter a valid age (13-120)';
//                     }
//                     return null;
//                   },
//                 ),
                
//                 SizedBox(height: 20),

//                 // Weight field
//                 CustomTextField(
//                   controller: _weightController,
//                   label: 'Weight (kg)',
//                   hint: 'Enter your weight in kg',
//                   prefixIcon: Icons.monitor_weight,
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
//                   ],
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your weight';
//                     }
//                     final weight = double.tryParse(value);
//                     if (weight == null || weight < 20 || weight > 500) {
//                       return 'Please enter a valid weight (20-500 kg)';
//                     }
//                     return null;
//                   },
//                 ),
                
//                 SizedBox(height: 20),

//                 // Height field
//                 CustomTextField(
//                   controller: _heightController,
//                   label: 'Height (cm)',
//                   hint: 'Enter your height in cm',
//                   prefixIcon: Icons.height,
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
//                   ],
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your height';
//                     }
//                     final height = double.tryParse(value);
//                     if (height == null || height < 100 || height > 250) {
//                       return 'Please enter a valid height (100-250 cm)';
//                     }
//                     return null;
//                   },
//                 ),
                
//                 SizedBox(height: 30),

//                 // Error message
//                 if (_errorMessage.isNotEmpty)
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     margin: EdgeInsets.only(bottom: 20),
//                     decoration: BoxDecoration(
//                       color: Colors.red[50],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.red[200]!),
//                     ),
//                     child: Text(
//                       _errorMessage,
//                       style: TextStyle(color: Colors.red[700]),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),

//                 // Continue button
//                 CustomButton(
//                   text: _isLoading ? 'Saving...' : 'Continue',
//                   onPressed: _isLoading ? null : _submitProfile,
//                   isLoading: _isLoading,
//                 ),
                
//                 SizedBox(height: 20),

//                 // BMI info card
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[50],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.blue[200]!),
//                   ),
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.info_outline,
//                         color: Colors.blue[600],
//                         size: 24,
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'BMI Calculation',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue[800],
//                           fontSize: 16,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'We\'ll calculate your Body Mass Index (BMI) to help personalize your fitness recommendations.',
//                         style: TextStyle(
//                           color: Colors.blue[700],
//                           fontSize: 14,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  double _calculateBMI(double weight, double height) {
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final age = int.parse(_ageController.text);
      final weight = double.parse(_weightController.text);
      final height = double.parse(_heightController.text);

      final bmi = _calculateBMI(weight, height);
      final bmiCategory = _getBMICategory(bmi);

      final profileData = {
        'age': age,
        'weight': weight,
        'height': height,
        'bmi': double.parse(bmi.toStringAsFixed(2)),
        'bmiCategory': bmiCategory,
        'profileCompleted': true,
        'profileCompletedAt': Timestamp.now(), // ✅ Firestore-compatible timestamp
      };

      bool success = await AuthService.updateUserProfile(profileData);

      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to save profile. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid input. Please check your entries.';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Let\'s set up your profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'We need some basic information to personalize your fitness journey',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _ageController,
                  label: 'Age',
                  hint: 'Enter your age',
                  prefixIcon: Icons.cake,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 13 || age > 120) {
                      return 'Please enter a valid age (13-120)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _weightController,
                  label: 'Weight (kg)',
                  hint: 'Enter your weight in kg',
                  prefixIcon: Icons.monitor_weight,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight < 20 || weight > 500) {
                      return 'Please enter a valid weight (20-500 kg)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _heightController,
                  label: 'Height (cm)',
                  hint: 'Enter your height in cm',
                  prefixIcon: Icons.height,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    final height = double.tryParse(value);
                    if (height == null || height < 100 || height > 250) {
                      return 'Please enter a valid height (100-250 cm)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                if (_errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                CustomButton(
                  text: _isLoading ? 'Saving...' : 'Continue',
                  onPressed: _isLoading ? null : _submitProfile,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[600],
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'BMI Calculation',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'We\'ll calculate your Body Mass Index (BMI) to help personalize your fitness recommendations.',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
