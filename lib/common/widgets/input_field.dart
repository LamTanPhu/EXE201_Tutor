import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutor/common/theme/app_colors.dart';

class InputFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final bool enabled;
  final bool isCurrency;
  final String? prefixText;
  final String? suffixText;
  final List<TextInputFormatter>? inputFormatters;

  const InputFieldWidget({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.enabled = true,
    this.isCurrency = false,
    this.prefixText,
    this.suffixText,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  bool _isFocused = false;
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    
    // Nếu là currency field, thêm formatter và listener
    if (widget.isCurrency) {
      widget.controller.addListener(_formatCurrency);
    }
  }

  @override
  void dispose() {
    if (widget.isCurrency) {
      widget.controller.removeListener(_formatCurrency);
    }
    super.dispose();
  }

  void _formatCurrency() {
    if (!widget.isCurrency) return;
    
    String text = widget.controller.text;
    if (text.isEmpty) return;

    // Loại bỏ tất cả ký tự không phải số
    String cleanText = text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanText.isEmpty) {
      widget.controller.clear();
      return;
    }

    // Định dạng số với dấu phẩy phân cách hàng nghìn
    String formatted = _formatNumber(int.parse(cleanText));
    
    // Cập nhật controller mà không trigger listener
    widget.controller.removeListener(_formatCurrency);
    widget.controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    widget.controller.addListener(_formatCurrency);
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }

  int? _parseCurrency(String text) {
    if (text.isEmpty) return null;
    String cleanText = text.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleanText);
  }

  List<TextInputFormatter> _getInputFormatters() {
    List<TextInputFormatter> formatters = widget.inputFormatters ?? [];
    
    if (widget.isCurrency) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[\d,]')));
    }
    
    return formatters;
  }

  String? _validateCurrency(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập ${widget.label.toLowerCase()}';
    }

    final amount = _parseCurrency(value);
    if (amount == null) {
      return 'Giá trị không hợp lệ';
    }

    if (amount < 1000) {
      return 'Giá trị tối thiểu là 1,000 VNĐ';
    }

    if (amount % 1000 != 0) {
      return 'Giá trị phải là bội số của 1,000 VNĐ';
    }

    if (amount > 1000000000) { // 1 tỷ VNĐ
      return 'Giá trị không được vượt quá 1,000,000,000 VNĐ';
    }

    return null;
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixWidget != null) {
      return widget.suffixWidget;
    }

    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: _isFocused ? AppColors.primary : AppColors.subText,
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      );
    }

    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: _isFocused ? AppColors.primary : AppColors.subText,
        ),
        onPressed: widget.onSuffixIconPressed,
      );
    }

    if (widget.isCurrency) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: const Text(
          'VNĐ',
          style: TextStyle(
            color: AppColors.subText,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label với indicator bắt buộc
          Row(
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              if (widget.validator != null)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (widget.isCurrency) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Bội số 1,000',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.info,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          // Input Field
          Focus(
            onFocusChange: (focused) {
              setState(() {
                _isFocused = focused;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: AppColors.secondary.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: TextFormField(
                controller: widget.controller,
                keyboardType: widget.isCurrency 
                    ? TextInputType.number 
                    : widget.keyboardType,
                maxLines: widget.maxLines,
                validator: widget.isCurrency 
                    ? _validateCurrency 
                    : widget.validator,
                obscureText: _isObscured,
                enabled: widget.enabled,
                inputFormatters: _getInputFormatters(),
                style: TextStyle(
                  color: widget.enabled ? AppColors.text : AppColors.disabled,
                  fontSize: 16,
                  fontWeight: widget.isCurrency ? FontWeight.w600 : FontWeight.normal,
                ),
                decoration: InputDecoration(
                  hintText: widget.hint ?? 
                      (widget.isCurrency 
                          ? 'Nhập số tiền (VD: 50,000)' 
                          : 'Nhập ${widget.label.toLowerCase()}...'),
                  hintStyle: const TextStyle(color: AppColors.subText),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: _isFocused
                              ? AppColors.primary
                              : AppColors.subText,
                        )
                      : null,
                  prefixText: widget.prefixText,
                  prefixStyle: const TextStyle(
                    color: AppColors.subText,
                    fontWeight: FontWeight.w500,
                  ),
                  suffixIcon: _buildSuffixIcon(),
                  suffixText: widget.suffixText,
                  suffixStyle: const TextStyle(
                    color: AppColors.subText,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: widget.enabled 
                      ? AppColors.surface 
                      : AppColors.surface.withOpacity(0.5),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: AppColors.divider.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.error, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.error, width: 2),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: AppColors.disabled.withOpacity(0.3)),
                  ),
                ),
              ),
            ),
          ),

          // Helper text cho currency
          if (widget.isCurrency && _isFocused) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.info.withOpacity(0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  'Giá trị phải là bội số của 1,000 VNĐ (VD: 10,000, 50,000)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.info.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Extension để lấy giá trị số từ currency field
extension CurrencyHelper on InputFieldWidget {
  int? getCurrencyValue() {
    if (!isCurrency) return null;
    String text = controller.text;
    if (text.isEmpty) return null;
    String cleanText = text.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleanText);
  }
}

// Utility class cho các validation thường dùng
class InputValidators {
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    
    final phoneRegex = RegExp(r'^[0-9]{10,11}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^\d]'), ''))) {
      return 'Số điện thoại không hợp lệ';
    }
    
    return null;
  }

  static String? minLength(String? value, int minLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    
    if (value.trim().length < minLength) {
      return '$fieldName phải có ít nhất $minLength ký tự';
    }
    
    return null;
  }

  static String? maxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.trim().length > maxLength) {
      return '$fieldName không được vượt quá $maxLength ký tự';
    }
    
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URL là optional
    }
    
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme) {
      return 'URL không hợp lệ';
    }
    
    return null;
  }
}