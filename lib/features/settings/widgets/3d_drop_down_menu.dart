import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';

typedef OnItemSelected<T> = void Function(T value);

class Custom3DDropdown<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final OnItemSelected<T> onChanged;
  final double width;
  final double height;
  final String? hintText;

  const Custom3DDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.width = 100,
    this.height = 50,
    this.hintText,
  });

  @override
  State<Custom3DDropdown<T>> createState() => _Custom3DDropdownState<T>();
}

class _Custom3DDropdownState<T> extends State<Custom3DDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        width: widget.width,
        top: offset.dy + size.height + 5,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.4),
                    blurRadius: 12.r,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: widget.items.map((item) {
                  final bool isSelected = item.value == widget.value;
                  return GestureDetector(
                    onTap: () {
                      widget.onChanged(item.value as T);
                      _closeDropdown();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DefaultTextStyle.merge(
                        style: TextStyle(
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 16.sp,
                        ),
                        child: item.child,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _languageIcon(String? langCode) {
    switch (langCode) {
      case 'en':
        return Image.asset(
          'assets/icons/languages/english.png',
          width: 24.w,
          height: 24.h,
          fit: BoxFit.cover,
        );
      case 'ar':
        return Image.asset(
          'assets/icons/languages/arabic.png',
          width: 24.w,
          height: 24.h,
          fit: BoxFit.cover,
        );
      default:
        return Icon(
          Icons.language,
          color: Theme.of(context).iconTheme.color,
          size: 24.r,
        );
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedItem = widget.items.firstWhere(
      (element) => element.value == widget.value,
      orElse: () => widget.items.first,
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.5),
                blurRadius: 12.r,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6.r,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: selectedItem != null
                    ? _languageIcon(selectedItem.value as String?)
                    : Text(
                        widget.hintText ?? 'Select',
                        style: TextStyle(
                          color: theme.hintColor,
                          fontSize: 16.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              AnimatedRotation(
                turns: _isOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: theme.iconTheme.color,
                  size: 26.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
