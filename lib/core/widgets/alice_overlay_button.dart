import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../network/network_service.dart';

class AliceOverlayButton extends StatefulWidget {
  const AliceOverlayButton({super.key});

  @override
  State<AliceOverlayButton> createState() => _AliceOverlayButtonState();
}

class _AliceOverlayButtonState extends State<AliceOverlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isHidden = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-0.75, 0)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
      if (_isHidden) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _openAlice() {
    try {
      NetworkService.instance.alice.showInspector();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return Positioned(
      left: 0,
      bottom: 0,
      child: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: GestureDetector(
            onTap: _isHidden ? _toggleVisibility : _openAlice,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 4,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              child: _isHidden
                  ? Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        color: Colors.blue.shade200,
                      ),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        const Expanded(
                          child: Center(
                            child: Icon(
                              Icons.network_check,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleVisibility,
                          child: Container(
                            width: 20,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
