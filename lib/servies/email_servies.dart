// lib/services/email_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const String _serviceId  = 'service_b1ndxy3';
  static const String _templateId = 'template_sw4vgsc';
  static const String _publicKey  = 'uniUhIkHs9KyFjydN';

  /// Login पछि welcome email
  static Future<bool> sendWelcomeEmail({
    required String toEmail,
    required String toName,
  }) async {
    return _send(
      toEmail: toEmail,
      toName:  toName,
      subject: 'Welcome back to ShopNepal!',
      content: 'Hi $toName,\n\nYou have successfully logged in to ShopNepal.\n\n'
               'Browse our latest products and enjoy shopping!\n\n'
               'Happy Shopping,\nShopNepal Team',
    );
  }

  /// Item buy गरेपछि order confirmation email
  static Future<bool> sendOrderConfirmationEmail({
    required String toEmail,
    required String toName,
    required String productName,
    required double productPrice,
  }) async {
    return _send(
      toEmail: toEmail,
      toName:  toName,
      subject: 'Order Confirmed: $productName',
      content: 'Hi $toName,\n\n'
               'Your order for "$productName" has been confirmed!\n\n'
               'Amount Paid: Rs. ${productPrice.toStringAsFixed(2)}\n'
               'Payment Method: Khalti\n\n'
               'Your item will be delivered soon.\n\n'
               'Thank you for shopping with ShopNepal!\n\nShopNepal Team',
    );
  }

  static Future<bool> _send({
    required String toEmail,
    required String toName,
    required String subject,
    required String content,
  }) async {
    try {
      print('[EmailService] Sending email to $toEmail...');
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost',
        },
        body: jsonEncode({
          'service_id':  _serviceId,
          'template_id': _templateId,
          'user_id':     _publicKey,
          'template_params': {
            'to_email':  toEmail,
            'from_name': toName,
            'reply_to':  toEmail,
            'subject':   subject,
            'content':   content,
          },
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Email service timeout'),
      );

      if (response.statusCode == 200) {
        print('[EmailService] Email sent successfully');
        return true;
      } else {
        print('[EmailService] Failed with status code: ${response.statusCode}');
        print('[EmailService] Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('[EmailService] Error: $e');
      return false;
    }
  }
}