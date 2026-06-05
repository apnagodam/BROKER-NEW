import 'package:ag_broker/data/services/chatgpt_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:manual_speech_to_text/manual_speech_to_text.dart';

class AudioWidget extends ConsumerStatefulWidget {
  const AudioWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends ConsumerState<AudioWidget>
    with TickerProviderStateMixin {
  bool _isAnimating = false;
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final AnimationController _expandController;
  late final Animation<double> _expandAnimation;
  late final ManualSttController speechController;
  late final ChatGptService _chatGptService;
  String textRecognized = '';
  String chatGptResponse = '';
  bool _isLoadingResponse = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
    speechController = ManualSttController(context);
    _chatGptService = ChatGptService();
  }

  @override
  void dispose() {
    _controller.dispose();
    _expandController.dispose();
    // Don't forget to dispose when done
    speechController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isSmallScreen = width < 360;
    final isTablet = width > 600;

    // Responsive sizes
    final headerIconSize = isTablet ? 36.0 : (isSmallScreen ? 24.0 : 28.0);
    final headerFontSize = isTablet ? 28.0 : (isSmallScreen ? 20.0 : 24.0);
    final subtitleFontSize = isTablet ? 16.0 : (isSmallScreen ? 12.0 : 14.0);
    final horizontalPadding = isTablet ? 24.0 : (isSmallScreen ? 12.0 : 16.0);
    final fabSize = isTablet ? 80.0 : (isSmallScreen ? 60.0 : 70.0);
    final fabIconSize = isTablet ? 40.0 : (isSmallScreen ? 28.0 : 32.0);
    final micButtonSize = isTablet ? 280.0 : (isSmallScreen ? 200.0 : 240.0);
    final micInnerSize = isTablet ? 200.0 : (isSmallScreen ? 140.0 : 160.0);
    final micIconSize = isTablet ? 80.0 : (isSmallScreen ? 60.0 : 70.0);

    return Stack(
      children: [
        // Main content when expanded
        if (_isExpanded)
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _expandAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.green.shade50,
                        Colors.white,
                        Colors.green.shade50,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        // Header
                        Padding(
                          padding: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.agriculture,
                                    color: Colors.green.shade700,
                                    size: headerIconSize,
                                  ),
                                  SizedBox(width: isSmallScreen ? 6 : 8),
                                  Flexible(
                                    child: Text(
                                      'Farming Assistant',
                                      style: TextStyle(
                                        fontSize: headerFontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isSmallScreen ? 6 : 8),
                              Text(
                                'Ask about commodities, prices & farming practices',
                                style: TextStyle(
                                  fontSize: subtitleFontSize,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // Response Section
                        if (_isLoadingResponse)
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green.shade600,
                                    ),
                                  ),
                                  SizedBox(height: isSmallScreen ? 16 : 20),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding,
                                    ),
                                    child: Text(
                                      'Analyzing your query...',
                                      style: TextStyle(
                                        fontSize: isTablet
                                            ? 18
                                            : (isSmallScreen ? 14 : 16),
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (chatGptResponse.isNotEmpty)
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                              ),
                              child: Card(
                                elevation: isTablet ? 12 : 8,
                                shadowColor: Colors.green.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    isSmallScreen ? 12 : 16,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      isSmallScreen ? 12 : 16,
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white,
                                        Colors.green.shade50,
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      isTablet
                                          ? 24.0
                                          : (isSmallScreen ? 16.0 : 20.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(
                                                isSmallScreen ? 6.0 : 8.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.tips_and_updates,
                                                color: Colors.green.shade700,
                                                size: isTablet
                                                    ? 28
                                                    : (isSmallScreen ? 20 : 24),
                                              ),
                                            ),
                                            SizedBox(
                                              width: isSmallScreen ? 8 : 12,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Farming Insights',
                                                style: TextStyle(
                                                  fontSize: isTablet
                                                      ? 24
                                                      : (isSmallScreen
                                                            ? 16
                                                            : 20),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                size: isSmallScreen ? 18 : 20,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  chatGptResponse = '';
                                                });
                                              },
                                              color: Colors.grey.shade600,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: isSmallScreen ? 12 : 16,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(
                                            isSmallScreen ? 10.0 : 12.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.blue.shade200,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.mic,
                                                color: Colors.blue.shade700,
                                                size: isSmallScreen ? 14 : 16,
                                              ),
                                              SizedBox(
                                                width: isSmallScreen ? 6 : 8,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'You asked: "$textRecognized"',
                                                  style: TextStyle(
                                                    fontSize: isTablet
                                                        ? 16
                                                        : (isSmallScreen
                                                              ? 12
                                                              : 14),
                                                    color: Colors.blue.shade900,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: isSmallScreen ? 12 : 16,
                                        ),
                                        Text(
                                          chatGptResponse,
                                          style: TextStyle(
                                            fontSize: isTablet
                                                ? 18
                                                : (isSmallScreen ? 14 : 16),
                                            height: 1.6,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.record_voice_over,
                                      size: isTablet
                                          ? 100
                                          : (isSmallScreen ? 60 : 80),
                                      color: Colors.green.shade300,
                                    ),
                                    SizedBox(height: isSmallScreen ? 16 : 20),
                                    Text(
                                      'Ready to listen',
                                      style: TextStyle(
                                        fontSize: isTablet
                                            ? 24
                                            : (isSmallScreen ? 16 : 20),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    SizedBox(height: isSmallScreen ? 6 : 8),
                                    Text(
                                      'Tap the microphone below to ask\nabout farming commodities',
                                      style: TextStyle(
                                        fontSize: isTablet
                                            ? 16
                                            : (isSmallScreen ? 12 : 14),
                                        color: Colors.grey.shade600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // Voice Recognition Status
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 16 : 20,
                            vertical: isSmallScreen ? 10 : 12,
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          decoration: BoxDecoration(
                            color: _isAnimating
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 10 : 12,
                            ),
                            border: Border.all(
                              color: _isAnimating
                                  ? Colors.red.shade200
                                  : Colors.green.shade200,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isAnimating)
                                Container(
                                  width: isSmallScreen ? 6 : 8,
                                  height: isSmallScreen ? 6 : 8,
                                  margin: EdgeInsets.only(
                                    right: isSmallScreen ? 6 : 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  _isAnimating
                                      ? (textRecognized.isEmpty
                                            ? 'Listening...'
                                            : textRecognized)
                                      : 'Tap to start listening',
                                  style: TextStyle(
                                    fontSize: isTablet
                                        ? 18
                                        : (isSmallScreen ? 14 : 16),
                                    fontWeight: _isAnimating
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: _isAnimating
                                        ? Colors.red.shade900
                                        : Colors.green.shade900,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Microphone Button
                        Padding(
                          padding: EdgeInsets.all(
                            isTablet ? 24.0 : (isSmallScreen ? 16.0 : 20.0),
                          ),
                          child: _expandedMicWidget(
                            micButtonSize,
                            micInnerSize,
                            micIconSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

        // Floating Mic Button (collapsed state)
        if (!_isExpanded) _collapsedMicButton(fabSize, fabIconSize),
      ],
    );
  }

  Widget _collapsedMicButton(double size, double iconSize) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Positioned(
      right: isSmallScreen ? 16 : 20,
      bottom: isSmallScreen ? 16 : 20,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = true;
          });
          _expandController.forward();
        },
        child: Hero(
          tag: 'mic_button',
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green.shade400, Colors.green.shade700],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.4),
                  blurRadius: isSmallScreen ? 16 : 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(Icons.mic, color: Colors.white, size: iconSize),
          ),
        ),
      ),
    );
  }

  Widget _expandedMicWidget(
    double outerSize,
    double innerSize,
    double iconSize,
  ) {
    final lottieSize = outerSize * 0.83;
    return GestureDetector(
      onTap: () {
        if (!_isAnimating) {
          setState(() {
            _isAnimating = true;
            chatGptResponse = ''; // Clear previous response
          });
          speechController.startStt();
          _controller.repeat();
          // Set up listeners
          speechController.listen(
            onListeningStateChanged: (ManualSttState state) {},
            onListeningTextChanged: (String text) {
              textRecognized = text;
              setState(() {});
              print('Recognized text: $text');
            },
            onSoundLevelChanged: (double level) {},
          );
        } else {
          setState(() {
            _isAnimating = false;
          });
          _controller.stop();
          // Stop recognition
          speechController.stopStt();

          // Call ChatGPT API with the recognized text
          if (textRecognized.isNotEmpty) {
            _getChatGptResponse(textRecognized);
          }
        }
      },
      onLongPress: () {
        // Close expanded view
        _expandController.reverse().then((_) {
          setState(() {
            _isExpanded = false;
            if (_isAnimating) {
              _isAnimating = false;
              _controller.stop();
              speechController.stopStt();
            }
          });
        });
      },
      child: Hero(
        tag: 'mic_button',
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _isAnimating
                    ? Colors.red.withOpacity(0.3)
                    : Colors.green.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Container(
                width: outerSize,
                height: outerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isAnimating
                        ? Colors.red.shade200
                        : Colors.green.shade200,
                    width: 3,
                  ),
                ),
              ),
              // Lottie animation
              if (_isAnimating)
                Lottie.asset(
                  'assets/sounds/audio.json',
                  controller: _controller,
                  width: lottieSize,
                  height: lottieSize,
                  repeat: true,
                  onLoaded: (composition) {
                    _controller.duration = composition.duration;
                  },
                ),
              // Center icon
              Container(
                width: innerSize,
                height: innerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isAnimating
                        ? [Colors.red.shade400, Colors.red.shade700]
                        : [Colors.green.shade400, Colors.green.shade700],
                  ),
                ),
                child: Icon(
                  _isAnimating ? Icons.stop : Icons.mic,
                  size: iconSize,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getChatGptResponse(String query) async {
    setState(() {
      _isLoadingResponse = true;
      chatGptResponse = '';
    });

    try {
      final response = await _chatGptService.getFarmingCommodityInfo(query);
      setState(() {
        chatGptResponse = response;
        _isLoadingResponse = false;
      });
    } catch (e) {
      setState(() {
        chatGptResponse = 'Failed to get response: $e';
        _isLoadingResponse = false;
      });
    }
  }
}
