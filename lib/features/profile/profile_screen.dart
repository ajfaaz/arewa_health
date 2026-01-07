import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_screen.dart';
import 'profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _name = TextEditingController();
  final _age = TextEditingController();

  bool diabetic = false;
  String language = 'en';
  bool loading = false;
  bool _notificationsEnabled = true;
  
  // Initial values for change detection
  String? _initialName;
  String? _initialAge;
  bool? _initialDiabetic;
  String? _initialLanguage;

  final ProfileService _service = ProfileService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('profiles').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _name.text = data['name'] ?? '';
        _age.text = (data['age'] ?? '').toString();
        diabetic = data['diabetic'] ?? false;
        language = data['language'] ?? 'en';
        
        _initialName = _name.text;
        _initialAge = _age.text;
        _initialDiabetic = diabetic;
        _initialLanguage = language;
      }
    }

    setState(() {
      _notificationsEnabled = prefs.getBool('daily_notifications') ?? true;
    });
  }

  bool get _isChanged {
    return _name.text != (_initialName ?? '') ||
           _age.text != (_initialAge ?? '') ||
           diabetic != (_initialDiabetic ?? false) ||
           language != (_initialLanguage ?? 'en');
  }

  Future<void> _saveProfile() async {
    // 1. Validation
    if (_name.text.trim().isEmpty || _age.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      // 2. Data Persistence
      await _service.saveProfile({
        "name": _name.text.trim(),
        "age": int.tryParse(_age.text) ?? 0,
        "diabetic": diabetic,
        "language": language,
        "createdAt": FieldValue.serverTimestamp(), // More reliable than local time
      });

      if (!mounted) return;

      // 3. Navigation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      setState(() => loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $e")),
      );
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Setup"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Tell us about yourself to personalize your health tracking.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _name,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _age,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: "Age",
                prefixIcon: Icon(Icons.cake),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text("Are you diabetic?"),
              subtitle: const Text("This helps us adjust health insights."),
              value: diabetic,
              onChanged: (v) => setState(() => diabetic = v),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: language,
              items: const [
                DropdownMenuItem(value: 'en', child: Text("English")),
                DropdownMenuItem(value: 'ha', child: Text("Hausa")),
              ],
              onChanged: (v) => setState(() => language = v!),
              decoration: const InputDecoration(
                labelText: "Preferred Language",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text("Daily Health Notifications"),
              value: _notificationsEnabled,
              onChanged: (val) async {
                setState(() => _notificationsEnabled = val);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('daily_notifications', val);
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: (loading || !_isChanged) ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Save Profile", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}