import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beautyflow_crm/config/theme/app_colors.dart';
import 'package:beautyflow_crm/config/theme/app_text_styles.dart';
import 'package:beautyflow_crm/config/theme/app_spacing.dart';

/// Custom Text Field (Кастомное поле ввода)
/// Использование: все формы в приложении
class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.inputFormatters,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.inputLabel,
          ),
          AppSpacing.vGapSm,
        ],

        // Text Field
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          maxLines: obscureText ? 1 : maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          focusNode: focusNode,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onTap: onTap,
          onEditingComplete: onEditingComplete,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.inputPlaceholder,
            filled: true,
            fillColor: enabled ? AppColors.white : AppColors.cardBg,
            contentPadding: AppSpacing.inputPadding,

            // Prefix Icon
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppColors.textGray,
                    size: AppSpacing.iconSm,
                  )
                : null,

            // Suffix Icon
            suffixIcon: suffixIcon,

            // Counter (для maxLength)
            counterText: '',

            // Border styles
            border: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLg,
              borderSide: const BorderSide(
                color: AppColors.border,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLg,
              borderSide: const BorderSide(
                color: AppColors.border,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLg,
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLg,
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLg,
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLg,
              borderSide: const BorderSide(
                color: AppColors.disabled,
                width: 2,
              ),
            ),
          ),
        ),

        // Error Text
        if (errorText != null) ...[
          AppSpacing.vGapXs,
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                size: 16,
                color: AppColors.error,
              ),
              AppSpacing.hGapXs,
              Expanded(
                child: Text(
                  errorText!,
                  style: AppTextStyles.inputError,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Search Text Field (поле поиска)
class SearchTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SearchTextField({
    super.key,
    this.hint,
    this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hint: hint ?? 'Поиск...',
      controller: controller,
      prefixIcon: Icons.search,
      onChanged: onChanged,
      suffixIcon: controller?.text.isNotEmpty == true
          ? IconButton(
              icon: const Icon(
                Icons.clear,
                size: AppSpacing.iconSm,
                color: AppColors.textGray,
              ),
              onPressed: () {
                controller?.clear();
                if (onClear != null) onClear!();
              },
            )
          : null,
    );
  }
}
