import 'dart:async';
import 'package:flutter/material.dart';
import 'package:politia/core/services/connectivity_service.dart';

/// Global wrapper widget that overlays a Facebook desktop-style floating dark pill toast
/// whenever the user loses network connectivity.
class NetworkStatusBannerWrapper extends StatelessWidget {
  final Widget child;

  const NetworkStatusBannerWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ConnectivityService.instance,
      builder: (context, _) {
        final isOffline = !ConnectivityService.instance.isOnline;

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            // Root Application Tree
            child,

            // Floating Facebook Offline Toast
            FacebookOfflineToast(
              isOffline: isOffline,
              onRefresh: () async {
                await ConnectivityService.instance.checkConnectivity();
              },
            ),
          ],
        );
      },
    );
  }
}

/// Pixel-perfect Facebook desktop floating pill toast for offline status notification.
class FacebookOfflineToast extends StatefulWidget {
  final bool isOffline;
  final VoidCallback onRefresh;
  final VoidCallback? onDismiss;

  const FacebookOfflineToast({
    super.key,
    required this.isOffline,
    required this.onRefresh,
    this.onDismiss,
  });

  @override
  State<FacebookOfflineToast> createState() => _FacebookOfflineToastState();
}

class _FacebookOfflineToastState extends State<FacebookOfflineToast>
    with SingleTickerProviderStateMixin {
  bool _isDismissed = false;
  bool _isRefreshing = false;
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ));

    if (widget.isOffline) {
      _animController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant FacebookOfflineToast oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isOffline && widget.isOffline) {
      // Re-show when connection drops again
      setState(() => _isDismissed = false);
      _animController.forward();
    } else if (oldWidget.isOffline && !widget.isOffline) {
      // Hide when connection returns
      _animController.reverse();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    widget.onRefresh();
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  void _handleDismiss() {
    _animController.reverse().then((_) {
      if (mounted) {
        setState(() => _isDismissed = true);
        widget.onDismiss?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOffline && _animController.isDismissed) {
      return const SizedBox.shrink();
    }

    if (_isDismissed) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF242526), // Dark Facebook Charcoal Toast
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Offline Icon
                      const Icon(
                        Icons.wifi_off_rounded,
                        color: Color(0xFF8A8D91),
                        size: 19,
                      ),
                      const SizedBox(width: 10),

                      // Offline Message
                      const Text(
                        "You are currently offline.",
                        style: TextStyle(
                          color: Color(0xFFE4E6EB),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Refresh Action Button
                      InkWell(
                        onTap: _handleRefresh,
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          child: _isRefreshing
                              ? const SizedBox(
                                  width: 13,
                                  height: 13,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.6,
                                    color: Color(0xFF4599FF),
                                  ),
                                )
                              : const Text(
                                  "Refresh",
                                  style: TextStyle(
                                    color: Color(0xFF4599FF),
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Close Dismiss Button
                      InkWell(
                        onTap: _handleDismiss,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(4.5),
                          decoration: const BoxDecoration(
                            color: Color(0xFF3A3B3C),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFF8A8D91),
                            size: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
