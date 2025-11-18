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

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      Tween<Offset>(begin: _dragAlignment, end: _initialAlignment)..animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // Or a custom spring curve
    )),
    );

    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(mass: 1, stiffness: 20, damping: 1);

    final simulation = SpringSimulation(spring, 0, 1, unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 20), vsync: this);

 // ensure _animation is an Offset animation before any controller ticks
    // _animation = AlwaysStoppedAnimation<Offset>(_dragAlignment);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
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
    _controller.dispose();
    super.dispose();
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
                _controller.stop();
              },
              onPanUpdate: (details) {
                setState(() {
                  _dragAlignment += details.delta;
                  // Offset(
                  //   details.delta.dx / (size.width / 2),
                  //   details.delta.dy / (size.height / 2),
                  // );
                });
              },
              onPanEnd: (details) {
                _runAnimation(details.velocity.pixelsPerSecond, size);
              },
              child: Card(child: widget.child),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return AnimatedBuilder(
  //     animation: _animation,
  //     builder: (context, child) {
  //       return Transform.translate(
  //         offset: Offset(0, _animation.value * 200), // Animate vertical position
  //         child: Card(child: widget.child),
  //       );
  //     },
  //   );
  // }
}
