import 'package:flutter/material.dart';
import '../utils/url_helper.dart';
import 'custom_text_field.dart';

class UrlInputSection extends StatelessWidget {
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final bool isLoading;

  const UrlInputSection({
    super.key,
    required this.controller,
    required this.formKey,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: CustomTextField(
          controller: controller,
          hintText: 'e.g., google.com or https://example.com/page',
          labelText: 'URL to shorten',
          prefixIcon: Icons.link,
          keyboardType: TextInputType.url,
          validator: UrlHelper.validateUrl,
          enabled: !isLoading,
          onSubmitted: (_) => onSubmit(),
          action: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: onSubmit,
                  tooltip: 'Shorten URL',
                ),
        ),
      ),
    );
  }
}
