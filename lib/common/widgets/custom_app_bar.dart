import 'package:flutter/material.dart';
import 'package:tutor/common/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final bool showGradient;
  final double elevation;
  final Color? backgroundColor;
  final bool centerTitle;
  final TextStyle? titleStyle;
  final VoidCallback? onLeadingPressed;
  final IconData? leadingIcon;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.showGradient = true,
    this.elevation = 0,
    this.backgroundColor,
    this.centerTitle = false,
    this.titleStyle,
    this.onLeadingPressed,
    this.leadingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.of(context).canPop();
    final bool shouldShowLeading = automaticallyImplyLeading && (canPop || leading != null);

    return Container(
      decoration: showGradient
          ? const BoxDecoration(
              gradient:AppColors.primaryGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 3),
                  blurRadius: 8,
                )
              ]
            )
          : null,
      child: AppBar(
        title: Text(
          title,
          style: titleStyle ??
              const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                fontSize: 20,
              ),
        ),
        backgroundColor: showGradient ? Colors.transparent : (backgroundColor ?? AppColors.primary),
        elevation: elevation,
        centerTitle: centerTitle,
        automaticallyImplyLeading: shouldShowLeading,
        leading: _buildLeading(context, shouldShowLeading),
        actions: actions,
        iconTheme: const IconThemeData(color: AppColors.white),
        actionsIconTheme: const IconThemeData(color: AppColors.white),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, bool shouldShowLeading) {
    if (!shouldShowLeading) return null;
    
    if (leading != null) return leading;
    
    if (onLeadingPressed != null) {
      return IconButton(
        icon: Icon(leadingIcon ?? Icons.arrow_back),
        onPressed: onLeadingPressed,
        color: AppColors.white,
        tooltip: 'Quay lại',
      );
    }
    
    if (Navigator.of(context).canPop()) {
      return IconButton(
        icon: Icon(leadingIcon ?? Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
        color: AppColors.white,
        tooltip: 'Quay lại',
      );
    }
    
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}