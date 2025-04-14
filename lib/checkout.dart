import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterprjgroup1/ordersuccesspage.dart';
import 'package:provider/provider.dart';
import 'package:flutterprjgroup1/cartprovider.dart';
import 'package:flutterprjgroup1/product.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  bool _formSubmitted = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String? _selectedProvince;

  final List<String> _canadianProvinces = [
    'Alberta',
    'British Columbia',
    'Manitoba',
    'New Brunswick',
    'Newfoundland and Labrador',
    'Northwest Territories',
    'Nova Scotia',
    'Nunavut',
    'Ontario',
    'Prince Edward Island',
    'Quebec',
    'Saskatchewan',
    'Yukon',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  bool _validateCanadianPostalCode(String value) {
    final regex = RegExp(r'^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$');
    return regex.hasMatch(value);
  }

  bool _validateCreditCardExpiry(String value) {
    final regex = RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$');
    if (!regex.hasMatch(value)) return false;

    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}');

    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    return (year > currentYear) ||
        (year == currentYear && month >= currentMonth);
  }

  void _showRemoveConfirmation(Product product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remove item?'),
            content: const Text(
              'Do you want to remove this item from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<CartProvider>(
                    context,
                    listen: false,
                  ).decreaseQuantity(product);
                  Navigator.pop(context);
                },
                child: const Text('Remove'),
              ),
            ],
          ),
    );
  }

  void _submitOrder() {
    setState(() {
      _formSubmitted = true;
    });

    if (_selectedProvince == null) {
      return;
    }

    bool hasEmptyFields = [
      _nameController,
      _emailController,
      _phoneController,
      _addressController,
      _postalCodeController,
      _cardNumberController,
      _expiryController,
      _cvvController,
    ].any((controller) => controller.text.isEmpty);

    if (hasEmptyFields ||
        _formKey.currentState == null ||
        !_formKey.currentState!.validate()) {
      return;
    }

    // placing order if validation passes.
    CartProvider cartProvider = Provider.of<CartProvider>(
      context,
      listen: false,
    );
    cartProvider.cartItems.clear();
    cartProvider.notifyListeners();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OrderSuccessPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    // if cart is empty show empty message to user.
    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(
          child: Text('Your Cart is Empty', style: TextStyle(fontSize: 18)),
        ),
      );
    }

    final subtotal = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
    final tax = subtotal * 0.13;
    final total = subtotal + tax;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    separatorBuilder:
                        (context, index) => const Divider(
                          height: 16,
                          thickness: 1,
                          color: Colors.black12,
                        ),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item.product.images.first,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '\$${item.product.price.toStringAsFixed(2)} × ${item.quantity}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                Text(
                                  '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (item.quantity == 1) {
                                    _showRemoveConfirmation(item.product);
                                  } else {
                                    cartProvider.decreaseQuantity(item.product);
                                  }
                                },
                              ),
                              Text(item.quantity.toString()),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed:
                                    () => cartProvider.increaseQuantity(
                                      item.product,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Subtotal', subtotal),
                  _buildSummaryRow('Tax (13%)', tax),
                  _buildSummaryRow('Total', total, isTotal: true),
                  const SizedBox(height: 24),
                  const Text(
                    'Shipping Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildCupertinoTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          placeholder: 'John Doe',
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter your name'
                                      : null,
                        ),
                        const SizedBox(height: 12),
                        _buildCupertinoTextField(
                          controller: _emailController,
                          label: 'Email',
                          placeholder: 'example@email.com',
                          keyboardType: TextInputType.emailAddress,
                          validator:
                              (value) =>
                                  value!.isEmpty || !value.contains('@')
                                      ? 'Please enter a valid email'
                                      : null,
                        ),
                        const SizedBox(height: 12),
                        _buildCupertinoTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          placeholder: '5199999999',
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator:
                              (value) =>
                                  value!.isEmpty || value.length < 10
                                      ? 'Please enter a valid phone number'
                                      : null,
                        ),
                        const SizedBox(height: 12),
                        _buildCupertinoTextField(
                          controller: _addressController,
                          label: 'Street Address',
                          placeholder: '299 Doon Valley Dr.',
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter your address'
                                      : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const SizedBox(height: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      'Province',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          CupertinoColors
                                              .extraLightBackgroundGray,
                                      border: Border.all(
                                        color:
                                            _selectedProvince == null
                                                ? CupertinoColors.systemRed
                                                : CupertinoColors
                                                    .lightBackgroundGray,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: DropdownButton<String>(
                                      value: _selectedProvince,
                                      hint: const Text('Select Province'),
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      items:
                                          _canadianProvinces
                                              .map(
                                                (province) => DropdownMenuItem(
                                                  value: province,
                                                  child: Text(province),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedProvince = value;
                                        });
                                      },
                                    ),
                                  ),
                                  if (_selectedProvince == null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Please select a province',
                                        style: TextStyle(
                                          color: CupertinoColors.systemRed,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildCupertinoTextField(
                          controller: _postalCodeController,
                          label: 'Postal Code',
                          placeholder: 'A1A 1A1',
                          maxLength: 7,
                          validator:
                              (value) =>
                                  value!.isEmpty ||
                                          !_validateCanadianPostalCode(value)
                                      ? 'Please enter a valid Canadian postal code'
                                      : null,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Payment Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildCupertinoTextField(
                          controller: _cardNumberController,
                          label: 'Card Number',
                          placeholder: '1234 5678 9012 3456',
                          keyboardType: TextInputType.number,
                          maxLength: 16,
                          validator:
                              (value) =>
                                  value!.isEmpty ||
                                          value.length != 19 ||
                                          !RegExp(r'^[0-9 ]+$').hasMatch(value)
                                      ? 'Please enter a valid 16-digit card number'
                                      : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildCupertinoTextField(
                                controller: _expiryController,
                                label: 'MM/YY',
                                placeholder: '12/25',
                                keyboardType: TextInputType.datetime,
                                maxLength: 5,
                                validator:
                                    (value) =>
                                        value!.isEmpty ||
                                                !_validateCreditCardExpiry(
                                                  value,
                                                )
                                            ? 'Please enter a valid expiry date'
                                            : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCupertinoTextField(
                                controller: _cvvController,
                                label: 'CVV',
                                placeholder: '123',
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                validator:
                                    (value) =>
                                        value!.isEmpty ||
                                                value.length != 3 ||
                                                !RegExp(
                                                  r'^[0-9]+$',
                                                ).hasMatch(value)
                                            ? 'Please enter a valid 3-digit CVV'
                                            : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
          _buildBottomBar(total),
        ],
      ),
    );
  }

  Widget _buildCupertinoTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    TextInputType? keyboardType,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          keyboardType: keyboardType,
          maxLength: maxLength,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: CupertinoColors.extraLightBackgroundGray,
            border: Border.all(
              color: _getBorderColor(controller, validator),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          style: const TextStyle(fontSize: 16),
          onChanged: (value) {
            if (validator != null) {
              setState(() {}); // this is to force refresh so that error shows up
            }
          },
        ),
        if (validator != null)
          Builder(
            builder: (context) {
              final error = validator(controller.text);
              if (error != null &&
                  (controller.text.isNotEmpty || _formSubmitted)) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    error,
                    style: TextStyle(
                      color: CupertinoColors.systemRed,
                      fontSize: 12,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  Color _getBorderColor(
    TextEditingController controller,
    String? Function(String?)? validator,
  ) {
    if (validator == null) return CupertinoColors.lightBackgroundGray;

    final validationError = validator(controller.text);
    final hasError = validationError != null;
    final shouldShowError = _formSubmitted || controller.text.isNotEmpty;

    return (hasError && shouldShowError)
        ? CupertinoColors.systemRed
        : CupertinoColors.lightBackgroundGray;
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          ElevatedButton(
            onPressed: _submitOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: const Size(0, 50),
            ),
            child: const Text(
              'Pay Now',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
