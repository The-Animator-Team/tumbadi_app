import 'package:flutter/material.dart';
import 'package:tumbadi_app/widget/FancyLoader.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Config.dart';

class Webviewpage extends StatefulWidget {
  final String webUrl;
  final String title;

  const Webviewpage({required this.title, required this.webUrl, super.key});

  @override
  State<Webviewpage> createState() => _WebviewpageState();
}

class _WebviewpageState extends State<Webviewpage> {
  static const Color _brandColor = Color.fromARGB(255, 173, 18, 7);
  static const Color _pageBackground = Color(0xFFFDE7EA);
  static const Color _surfaceColor = Color(0xFFFFFBF8);
  static const Color _textPrimary = Color(0xFF261F1B);
  static const Color _textSecondary = Color(0xFF7B6D66);

  late final WebViewController _webController;
  bool _isLoading = true;
  int _loadingProgress = 0;

  final String _englishWebUrl = Config.web_url;
  final String _gujaratiWebUrl = Config.web_lng_url;

  static const String _cleanupJavascript = '''
    (() => {
      const selectors = ['#header', '#topbar', '#page-cover', '.breadcrumbs'];
      for (const selector of selectors) {
        const elements = document.querySelectorAll(selector);
        for (const element of elements) {
          if (!element) {
            continue;
          }
          element.style.display = 'none';
          element.remove();
        }
      }
    })();
  ''';

  static const String _brandThemeJavascript = '''
    (() => {
      if (document.getElementById('app-brand-theme')) {
        return;
      }

      const style = document.createElement('style');
      style.id = 'app-brand-theme';
      style.textContent = `
        a:hover,
        .site-top a,
        #topbar .contact-info i,
        #topbar .contact-info a:hover,
        #topbar .social-links a:hover,
        .text-primary,
        .page-link,
        .section-title h2,
        .read-more-link:hover,
        .card-title:hover,
        .dropdown-item:focus,
        .dropdown-item:hover,
        .navbar .active,
        .navbar .active:focus,
        .navbar li:hover > a,
        .navbar .dropdown ul a:hover,
        .contact .info h4,
        .contact .info h4 a,
        .contact .info p,
        .contact .info p a,
        .contact .info span,
        .contact .info strong,
        .contact .info .email p,
        .contact .info .phone p,
        .contact .info .address p,
        .contact .info .hours p,
        .contact .info .hours strong,
        .faq .faq-list .icon-show,
        .faq .faq-list .icon-close {
          color: #ad1207 !important;
        }

        .btn-primary,
        .btn-secondary,
        .bg-primary,
        .bg-secondary,
        .btn-theme,
        .back-to-top,
        .back-to-top i,
        .back-to-top svg,
        .scroll-top,
        .scroll-top i,
        .scroll-top svg,
        #scroll-top,
        #scroll-top i,
        #scroll-top svg,
        .go-top,
        .go-top i,
        .go-top svg,
        .goTop,
        .goTop i,
        .goTop svg,
        .section-title h2::before,
        .section-title h2::after,
        .active > .page-link,
        .page-link.active,
        .accordion-button:not(.collapsed),
        .contact .info i,
        .services .icon-box,
        .testimonials .swiper-pagination .swiper-pagination-bullet-active,
        .navbar a[href*="donation"],
        a[href*="donation"][style*="#EE9C1F"],
        a[href*="donation"][style*="#ee9c1f"] {
          background: #ad1207 !important;
          border-color: #ad1207 !important;
          color: #ffffff !important;
        }

        .btn-primary:hover,
        .btn-primary:active,
        .btn-primary:focus,
        .btn-secondary:hover,
        .btn-theme:hover,
        .back-to-top:hover,
        .back-to-top:hover i,
        .back-to-top:hover svg,
        .scroll-top:hover,
        .scroll-top:hover i,
        .scroll-top:hover svg,
        #scroll-top:hover,
        #scroll-top:hover i,
        #scroll-top:hover svg,
        .go-top:hover,
        .go-top:hover i,
        .go-top:hover svg,
        .goTop:hover,
        .goTop:hover i,
        .goTop:hover svg,
        .services .icon-box:hover {
          background: #86140e !important;
          border-color: #86140e !important;
          color: #ffffff !important;
        }

        .btn-outline-theme {
          border-color: #ad1207 !important;
          color: #ad1207 !important;
        }

        .btn-outline-theme:hover,
        .btn-outline-theme:active {
          background: #fde7ea !important;
          border-color: #fde7ea !important;
          color: #ad1207 !important;
        }

        .fa-plus,
        .fa-plus-circle,
        .fa-plus-square,
        [class*="fa-plus"],
        .bi-plus,
        .bi-plus-circle,
        .bi-plus-lg,
        [class*="bi-plus"],
        .accordion-button::after,
        .faq .faq-list i {
          color: #ad1207 !important;
        }

        .back-to-top i,
        .back-to-top svg,
        .scroll-top i,
        .scroll-top svg,
        #scroll-top i,
        #scroll-top svg,
        .go-top i,
        .go-top svg,
        .goTop i,
        .goTop svg {
          color: #ffffff !important;
          fill: #ffffff !important;
          stroke: #ffffff !important;
        }

        .fixed-area-menu::-webkit-scrollbar-thumb,
        .testimonials .swiper-pagination .swiper-pagination-bullet,
        .tooltip-inner {
          background-color: #ad1207 !important;
          border-color: #ad1207 !important;
        }

        .section-bg,
        .breadcrumbs,
        .bottom-article,
        .widget-title,
        pre,
        .header-form-search .form-control,
        .post-gallery,
        .accordion-item:last-of-type .accordion-button.collapsed {
          background-color: #fde7ea !important;
        }

        .list-group-item,
        .card,
        .form-control,
        .accordion-item,
        .line-frame {
          border-color: #f2d8d6 !important;
        }

        .form-control:focus {
          border-color: #ad1207 !important;
          box-shadow: 0 0 0 0.22rem rgba(173, 18, 7, 0.12) !important;
        }

        .services .icon-box .icon i,
        .services .icon-box:hover .icon i {
          color: #ad1207 !important;
        }

        .staff .member,
        .contact .info i {
          background: #fde7ea !important;
        }

        .staff .member span::after {
          background: #ad1207 !important;
        }

        .gallery .gallery-item {
          border-color: #ffffff !important;
        }
      `;
      document.head.appendChild(style);
    })();
  ''';

  static const String _footerThemeJavascript = '''
    (() => {
      if (document.getElementById('app-footer-theme')) {
        return;
      }

      const style = document.createElement('style');
      style.id = 'app-footer-theme';
      style.textContent = `
        footer .copyright,
        footer .copyright *,
        footer .credits,
        footer .credits *,
        footer a,
        footer span,
        footer p,
        footer small,
        #footer .copyright,
        #footer .copyright *,
        #footer .credits,
        #footer .credits *,
        #footer a,
        #footer span,
        #footer p,
        #footer small,
        footer .text-warning,
        #footer .text-warning,
        footer [style*="#EE9C1F"],
        footer [style*="#ee9c1f"],
        footer [style*="yellow"],
        #footer [style*="#EE9C1F"],
        #footer [style*="#ee9c1f"],
        #footer [style*="yellow"] {
          color: #ad1207 !important;
        }
      `;
      document.head.appendChild(style);
    })();
  ''';

  static const String _donationThemeJavascript = '''
    (() => {
      if (document.getElementById('app-donation-theme')) {
        return;
      }

      const style = document.createElement('style');
      style.id = 'app-donation-theme';
      style.textContent = `
        #content .row {
          align-items: center;
        }

        #content form {
          background: #fff7f5;
          border: 1px solid #f5d7d4;
          border-radius: 24px;
          padding: 20px 18px;
          box-shadow: 0 18px 36px rgba(173, 18, 7, 0.08);
        }

        #content .form-group {
          margin-bottom: 14px;
        }

        #content .form-group label {
          font-weight: 700;
          color: #6f2a23;
          margin-bottom: 6px;
        }

        #content .form-control {
          border-radius: 16px;
          border-color: #f1d3d0 !important;
          min-height: 48px;
        }

        #content textarea.form-control {
          min-height: 110px;
        }

        #content .form-control:focus {
          border-color: #ad1207 !important;
          box-shadow: 0 0 0 0.22rem rgba(173, 18, 7, 0.12) !important;
        }

        #content .btn.btn-primary {
          width: 100%;
          border-radius: 18px;
          padding: 12px 18px;
          font-weight: 700;
          letter-spacing: 0.2px;
          margin-top: 10px;
        }

        #content img {
          filter: drop-shadow(0 16px 30px rgba(173, 18, 7, 0.10));
        }
      `;
      document.head.appendChild(style);
    })();
  ''';

  _SectionStyle get _sectionStyle => _resolveSectionStyle();

  @override
  void initState() {
    super.initState();
    _webController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  _isLoading = true;
                  _loadingProgress = 10;
                });
              },
              onProgress: (progress) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  _loadingProgress = progress;
                });
              },
              onPageFinished: (_) async {
                await _cleanupWebsiteChrome();
                await _applyPageSpecificTheme();
                if (!mounted) {
                  return;
                }
                setState(() {
                  _isLoading = false;
                  _loadingProgress = 100;
                });
              },
            ),
          );

    _loadWebViewPage(widget.webUrl, 'English');
  }

  _SectionStyle _resolveSectionStyle() {
    final String key = widget.title.toLowerCase().trim();

    if (key.contains('gallery')) {
      return const _SectionStyle(
        icon: Icons.photo_library_rounded,
        subtitle:
            'Photos, moments, and community memories presented in a cleaner frame.',
        chipLabel: 'Community Gallery',
        highlight: '',
      );
    }

    if (key.contains('b2b')) {
      return const _SectionStyle(
        icon: Icons.storefront_rounded,
        subtitle:
            'Business listings and opportunities with a more polished branded layout.',
        chipLabel: 'Business Connect',
        highlight: '',
      );
    }

    if (key.contains('event')) {
      return const _SectionStyle(
        icon: Icons.event_available_rounded,
        subtitle:
            'Latest programs, updates, and community activities in one place.',
        chipLabel: 'Latest Events',
        highlight: '',
      );
    }

    if (key.contains('mataji')) {
      return const _SectionStyle(
        icon: Icons.self_improvement_rounded,
        subtitle:
            'Spiritual information and updates shown inside a calmer app-themed shell.',
        chipLabel: 'Spiritual Section',
        highlight: '',
      );
    }

    if (key.contains('donation')) {
      return const _SectionStyle(
        icon: Icons.volunteer_activism_rounded,
        subtitle:
            'Support community initiatives and seva projects inside a cleaner, more polished donation view.',
        chipLabel: 'Support & Seva',
        highlight: 'Every contribution helps the community move forward.',
      );
    }

    return const _SectionStyle(
      icon: Icons.public_rounded,
      subtitle: 'Community content wrapped in a cleaner app experience.',
      chipLabel: 'Community Section',
      highlight: '',
    );
  }

  Future<void> _cleanupWebsiteChrome() async {
    try {
      await _webController.runJavaScript(_cleanupJavascript);
    } catch (error, stackTrace) {
      debugPrint('WebView cleanup failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _applyPageSpecificTheme() async {
    final String key = widget.title.toLowerCase().trim();

    try {
      await _webController.runJavaScript(_footerThemeJavascript);
    } catch (error, stackTrace) {
      debugPrint('Footer theme injection failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    try {
      await _webController.runJavaScript(_brandThemeJavascript);
    } catch (error, stackTrace) {
      debugPrint('Brand theme injection failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    if (!key.contains('donation')) {
      return;
    }

    try {
      await _webController.runJavaScript(_donationThemeJavascript);
    } catch (error, stackTrace) {
      debugPrint('Donation theme injection failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _loadWebViewPage(String pageName, String language) async {
    final String baseUrl = language == "gu" ? _gujaratiWebUrl : _englishWebUrl;
    final Uri webUri =
        pageName.startsWith('http')
            ? Uri.parse(pageName)
            : Uri.parse('$baseUrl$pageName');

    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadingProgress = 10;
      });
    }

    await _webController.loadRequest(webUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: _pageBackground,
        foregroundColor: _textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
              child: _buildHeaderCard(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x18000000),
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: WebViewWidget(controller: _webController),
                        ),
                      ),
                      if (_isLoading)
                        Positioned.fill(
                          child: ColoredBox(
                            color: _surfaceColor,
                            child: Center(
                              child: FancyLoader(
                                label:
                                    'Preparing ${widget.title.toLowerCase()}',
                                subtitle:
                                    _loadingProgress > 0
                                        ? 'Loading content... $_loadingProgress%'
                                        : 'Loading section content and applying the app layout.',
                                icon: _sectionStyle.icon,
                                backgroundTint: const Color(0xFFFBE9E7),
                                showCard: true,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _brandColor.withOpacity(0.96),
            const Color(0xFFC64339),
            const Color(0xFFE9997F),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _sectionStyle.chipLabel,
                    style: const TextStyle(
                      fontSize: 11.8,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _sectionStyle.subtitle,
                  style: TextStyle(
                    fontSize: 13.4,
                    height: 1.45,
                    color: Colors.white.withOpacity(0.88),
                  ),
                ),
                if (_sectionStyle.highlight.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withOpacity(0.12)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.favorite_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _sectionStyle.highlight,
                            style: const TextStyle(
                              fontSize: 12.6,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.14)),
            ),
            child: Icon(_sectionStyle.icon, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
}

class _SectionStyle {
  final IconData icon;
  final String subtitle;
  final String chipLabel;
  final String highlight;

  const _SectionStyle({
    required this.icon,
    required this.subtitle,
    required this.chipLabel,
    required this.highlight,
  });
}
