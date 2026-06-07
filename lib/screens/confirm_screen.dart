// lib/screens/confirm_screen.dart
//
// Shows product details + Khalti QR code for payment.
// After tapping "Confirm Purchase", sends order confirmation email.

import 'package:e_commerce/servies/auth_servies.dart';
import 'package:e_commerce/servies/email_servies.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
//mport '../services/email_service.dart';
//import '../services/auth_service.dart';

class ConfirmScreen extends StatefulWidget {
  final ProductCart product;

  const ConfirmScreen({super.key, required this.product});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  bool _showQR     = false;
  bool _isOrdering = false;

  // ─────────────────────────────────────────────────────────────
  //  Khalti QR
  //  Replace the URL below with your actual Khalti merchant QR.
  //  You can generate one from: https://merchant.khalti.com
  // ─────────────────────────────────────────────────────────────
  static const String _khaltiQrUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/800px-QR_code_for_mobile_English_Wikipedia.svg.png';
  //  ↑ Replace this with YOUR Khalti merchant QR image URL or use a local asset

  Future<void> _confirmPurchase() async {
    setState(() => _isOrdering = true);

    try {
      final user  = FirebaseAuth.instance.currentUser;
      final email = user?.email ?? '';
      final name  = await AuthService.getCurrentUserName();

      if (email.isNotEmpty) {
        await EmailService.sendOrderConfirmationEmail(
          toEmail:      email,
          toName:       name,
          productName:  widget.product.name,
          productPrice: widget.product.price,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
              '✅ ${widget.product.name} order confirmed! Check your email 📧'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isOrdering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Order'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Product Image ──────────────────────────────
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Product Info ───────────────────────────────
            Text(
              product.name,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              'Rs. ${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 26,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // ── Khalti QR Section ─────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.network(
                        'https://web.khalti.com/static/img/logo1.png',
                        height: 28,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Pay with Khalti',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => setState(() => _showQR = !_showQR),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: _showQR
                          ? Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    _khaltiQrUrl,
                                    height: 200,
                                    width: 200,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.qr_code,
                                        size: 200,
                                        color: Colors.purple),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Scan & pay Rs. ${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Open Khalti app → Scan QR',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            )
                          : ElevatedButton.icon(
                              onPressed: () =>
                                  setState(() => _showQR = true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                                minimumSize:
                                    const Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.qr_code),
                              label: const Text('Show Khalti QR Code'),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ── Confirm Button ────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isOrdering ? null : _confirmPurchase,
                child: _isOrdering
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Confirm Purchase',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),

            const SizedBox(height: 12),
            const Center(
              child: Text(
                '📧 Order confirmation will be sent to your email',
                style: TextStyle(color: Colors.grey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}