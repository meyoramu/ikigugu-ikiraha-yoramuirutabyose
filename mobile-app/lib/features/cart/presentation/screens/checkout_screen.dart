// features/cart/presentation/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;

  const CheckoutScreen({super.key, required this.totalAmount});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final plugin = PaystackPlugin();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: 'pk_test_your_key_here');
  }

  Future<void> _processPayment() async {
    setState(() => isLoading = true);
    
    try {
      final charge = Charge()
        ..amount = (widget.totalAmount * 100).toInt() // in kobo
        ..email = 'customer@email.com'
        ..card = PaymentCard(
          number: '4084084084084081',
          cvc: '408',
          expiryMonth: 12,
          expiryYear: 2025,
        );
      
      final response = await plugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
      );
      
      if (response.status) {
        // Payment successful
        Navigator.pushNamed(context, '/order-confirmation');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${response.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Order Summary'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal'),
                        Text('\$${widget.totalAmount.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery'),
                        const Text('\$0.00'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '\$${widget.totalAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Pay with Apple Pay/Google Pay'),
            ),
          ],
        ),
      ),
    );
  }
}