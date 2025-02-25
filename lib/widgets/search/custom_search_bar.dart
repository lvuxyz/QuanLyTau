import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool isLoading;
  final Function(String)? onChanged;
  final VoidCallback? onClear;

  const CustomSearchBar({
    Key? key,
    required this.controller,
    this.focusNode,
    this.isLoading = false,
    this.onChanged,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.black,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFF333333),
          hintText: 'Tìm kiếm...',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: isLoading
              ? SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
          )
              : Icon(Icons.search, color: Colors.grey),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: Colors.grey),
            onPressed: onClear,
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}