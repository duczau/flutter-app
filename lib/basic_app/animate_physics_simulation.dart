import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

// void main() {
//   runApp(const MaterialApp(home: PhysicsCardDragDemo()));
// }

// class PhysicsCardDragDemo extends StatelessWidget {
//   const PhysicsCardDragDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: const DraggableCard(child: FlutterLogo(size: 128)),
//     );
//   }
// }

/// A draggable card that moves back to [Alignment.center] when it's
/// released.
class DraggableCard extends StatefulWidget {
  const DraggableCard({
    required this.child,
    required this.startLeft,
    required this.startTop,
    super.key,
  });

  final Widget child;

  /// Optional start position in pixels relative to the parent's top-left.
  /// If not provided, defaults to the center of the available area.
  final double startLeft;
  final double startTop;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// The alignment of the card as it is dragged or being animated.
  Offset _dragAlignment = Offset.zero;
  late Animation<Offset> _animation;
  late Offset _initialAlignment;
  bool _initialComputed = false;
  
  Offset _velocity = Offset.zero;
  double gravity = 980;
  double friction = 0.7;
  double baseTime = 0.016;
  double cardWidth = 100;   // ✅ Thêm card dimensions
  double cardHeight = 100;
  bool _isDragging = false;
  bool _isAnimating = false;

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      Tween<Offset>(begin: _dragAlignment, end: _initialAlignment)
    );


    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(mass: 3, stiffness: 150, damping: 2);

    final simulation = SpringSimulation(spring, 0, 1, unitVelocity);

    _controller.animateWith(simulation);
  }

  void _onAnimationTick() {
    if (!_isDragging && _isAnimating) {
      if (!mounted) return;
      setState(() {
        final size = MediaQuery.of(context).size;
        
        // Apply gravity
        _velocity = Offset(
          _velocity.dx,
          _velocity.dy + gravity * baseTime,
        );
        
        // Update position
        _dragAlignment = Offset(
          _dragAlignment.dx + _velocity.dx * baseTime,
          _dragAlignment.dy + _velocity.dy * baseTime,
        );
        
        // ✅ Bounce off bottom
        if (_dragAlignment.dy + cardHeight >= size.height) {
          _dragAlignment = Offset(_dragAlignment.dx, size.height - cardHeight);
          _velocity = Offset(_velocity.dx, -_velocity.dy * friction);
          
          print('Bottom bounce - velocity: ${_velocity.dy}');
          
          if (_velocity.dy.abs() < 10) {
            _velocity = Offset(_velocity.dx, 0);
          }
        }
        
        // ✅ Bounce off top
        if (_dragAlignment.dy <= 0) {
          _dragAlignment = Offset(_dragAlignment.dx, 0);
          _velocity = Offset(_velocity.dx, -_velocity.dy * friction);
        }
        
        // ✅ Bounce off right
        if (_dragAlignment.dx + cardWidth >= size.width) {
          _dragAlignment = Offset(size.width - cardWidth, _dragAlignment.dy);
          _velocity = Offset(-_velocity.dx * friction, _velocity.dy);
          
          if (_velocity.dx.abs() < 10) {
            _velocity = Offset(0, _velocity.dy);
          }
        }
        
        // ✅ Bounce off left
        if (_dragAlignment.dx <= 0) {
          _dragAlignment = Offset(0, _dragAlignment.dy);
          _velocity = Offset(-_velocity.dx * friction, _velocity.dy);
        }
        
        // ✅ Stop if at rest
        final isAtBottom = (_dragAlignment.dy + cardHeight >= size.height - 1);
        final isAtRest = (_velocity.dx.abs() < 1 && _velocity.dy.abs() < 1);
        
        if (isAtRest && isAtBottom) {
          _velocity = Offset.zero;
          _isAnimating = false;
          _controller.stop();
          print('Animation stopped - at rest');
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..addListener(_onAnimationTick);

    // ensure _animation is an Offset animation before any controller ticks
    // _animation = AlwaysStoppedAnimation<Offset>(_dragAlignment);

    // _controller.addListener(() {
    //   setState(() {
    //     _dragAlignment = _animation.value;
    //   });
    //   // ✅ Kiểm tra nếu animation hoàn thành (về vị trí ban đầu)
    //   if (_controller.isCompleted) {
    //     // Reset controller để có thể chạy animation lại lần tiếp theo
    //     _controller.reset();
    //   }
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialComputed) {
      final size = MediaQuery.of(context).size;
      final left = widget.startLeft;
      final top = widget.startTop;
      final alignX = (2 * left / size.width) - 1; // convert px -> [-1,1]
      final alignY = (2 * top / size.height) - 1;
      _initialAlignment = Offset(left, top);
      _dragAlignment = _initialAlignment;
      _initialComputed = true;
    }
  }

  @override
  void didUpdateWidget(covariant DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu parent thay đổi startLeft/startTop thì cập nhật lại vị trí mặc định
    if (widget.startLeft != oldWidget.startLeft ||
        widget.startTop != oldWidget.startTop) {
      // Dừng animation nếu đang chạy trước khi thay đổi vị trí
      _controller.stop();
      final size = MediaQuery.of(context).size;
      final left = widget.startLeft;
      final top = widget.startTop;
      final alignX = (2 * left / size.width) - 1;
      final alignY = (2 * top / size.height) - 1;
      setState(() {
        _initialAlignment = Offset(left, top);
        _dragAlignment = _initialAlignment;
        _initialComputed = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onAnimationTick); // ✅ Remove listener
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation(Offset pixelsPerSecond) {
    print('Starting animation - initial velocity: $pixelsPerSecond');
    
    _velocity = Offset(
      pixelsPerSecond.dx / 60,
      pixelsPerSecond.dy / 60,
    );
    _isAnimating = true;
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
            left: _dragAlignment.dx,
            top: _dragAlignment.dy,
            child: GestureDetector(
              onPanDown: (details) {
                  _isDragging = true;
                  _isAnimating = false;
                  _velocity = Offset.zero;
                _controller.stop();
              },
              onPanUpdate: (details) {
                setState(() {
                  _dragAlignment += details.delta;
                  // Clamp to bounds
                  _dragAlignment = Offset(
                    _dragAlignment.dx.clamp(0, size.width - cardWidth),
                    _dragAlignment.dy.clamp(0, size.height - cardHeight),
                  );
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _isDragging = false;
                });
                _startAnimation(details.velocity.pixelsPerSecond);
                // _runAnimation(details.velocity.pixelsPerSecond, size);
              },
              child: Card(child: widget.child),
            ),
          ),
        ],
      ),
    );
  }
}
