import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const GoApp());
}

class GoApp extends StatelessWidget {
  const GoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Board',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const BoardPage(),
    );
  }
}

class BoardState extends ChangeNotifier {
  BoardState({this.size = 19});

  final int size; // 9, 13, 19 supported (UI only for now)

  Offset? _hoverPoint; // in board coordinates (row, col) as double for precision
  Offset? _selectedPoint; // last tapped intersection (row, col)

  Offset? get hoverPoint => _hoverPoint;
  Offset? get selectedPoint => _selectedPoint;

  void setHover(Offset? p) {
    _hoverPoint = p;
    notifyListeners();
  }

  void select(Offset? p) {
    _selectedPoint = p;
    notifyListeners();
  }
}

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final BoardState state = BoardState(size: 19);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go (Weiqi) – 19x19'),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double size = math.min(constraints.maxWidth, constraints.maxHeight);
            // Keep a little margin on small screens
            final double boardExtent = size.clamp(260.0, 720.0);
            return MouseRegion(
              onHover: (event) {
                final renderBox = context.findRenderObject() as RenderBox?;
                if (renderBox == null) return;
                final local = renderBox.globalToLocal(event.position);
                final boardBox = _boardBoxKey.currentContext?.findRenderObject() as RenderBox?;
                if (boardBox == null) return;
                final boardOffset = boardBox.globalToLocal(event.position);
                final mapped = _mapToIntersection(boardOffset, boardExtent, state.size);
                state.setHover(mapped);
              },
              onExit: (_) => state.setHover(null),
              child: Center(
                child: SizedBox(
                  key: _boardBoxKey,
                  width: boardExtent,
                  height: boardExtent,
                  child: _BoardInteractionLayer(
                    boardExtent: boardExtent,
                    state: state,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  final GlobalKey _boardBoxKey = GlobalKey();

  static Offset? _mapToIntersection(Offset localPoint, double extent, int size) {
    if (extent <= 0 || size < 2) return null;
    final padding = extent * 0.06; // visual margin around grid
    final gridExtent = extent - 2 * padding;
    if (localPoint.dx < padding || localPoint.dy < padding ||
        localPoint.dx > extent - padding || localPoint.dy > extent - padding) {
      return null;
    }
    final step = gridExtent / (size - 1);
    final col = ((localPoint.dx - padding) / step).round().clamp(0, size - 1);
    final row = ((localPoint.dy - padding) / step).round().clamp(0, size - 1);
    return Offset(row.toDouble(), col.toDouble());
  }
}

class _BoardInteractionLayer extends StatefulWidget {
  const _BoardInteractionLayer({
    required this.boardExtent,
    required this.state,
  });

  final double boardExtent;
  final BoardState state;

  @override
  State<_BoardInteractionLayer> createState() => _BoardInteractionLayerState();
}

class _BoardInteractionLayerState extends State<_BoardInteractionLayer> {
  @override
  void initState() {
    super.initState();
    widget.state.addListener(_onState);
  }

  @override
  void didUpdateWidget(covariant _BoardInteractionLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      oldWidget.state.removeListener(_onState);
      widget.state.addListener(_onState);
    }
  }

  @override
  void dispose() {
    widget.state.removeListener(_onState);
    super.dispose();
  }

  void _onState() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        final mapped = _BoardPageState._mapToIntersection(
          details.localPosition,
          widget.boardExtent,
          widget.state.size,
        );
        widget.state.select(mapped);
      },
      child: CustomPaint(
        painter: BoardPainter(
          size: widget.state.size,
          hover: widget.state.hoverPoint,
          selected: widget.state.selectedPoint,
        ),
      ),
    );
  }
}

class BoardPainter extends CustomPainter {
  BoardPainter({
    required this.size,
    required this.hover,
    required this.selected,
  });

  final int size; // intersections per side
  final Offset? hover; // row, col
  final Offset? selected; // row, col

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final extent = math.min(canvasSize.width, canvasSize.height);
    final rect = Offset.zero & Size(extent, extent);

    final bgPaint = Paint()
      ..color = const Color(0xFFF0D9B5);
    canvas.drawRect(rect, bgPaint);

    final padding = extent * 0.06;
    final gridRect = Rect.fromLTWH(padding, padding, extent - 2 * padding, extent - 2 * padding);
    final gridPaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = extent * 0.003
      ..style = PaintingStyle.stroke;

    // Draw vertical and horizontal lines
    final step = gridRect.width / (size - 1);
    final linePaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = extent * 0.0022
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    for (int i = 0; i < size; i++) {
      final dx = gridRect.left + i * step;
      final dy = gridRect.top + i * step;
      canvas.drawLine(Offset(dx, gridRect.top), Offset(dx, gridRect.bottom), linePaint);
      canvas.drawLine(Offset(gridRect.left, dy), Offset(gridRect.right, dy), linePaint);
    }

    // Star points for 19x19 / 13x13 / 9x9
    final starPoints = _starPoints(size);
    final starPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    for (final pt in starPoints) {
      final dx = gridRect.left + pt.dx * step;
      final dy = gridRect.top + pt.dy * step;
      canvas.drawCircle(Offset(dx, dy), extent * 0.006, starPaint);
    }

    // Draw hover preview stone (translucent)
    if (hover != null) {
      final hx = gridRect.left + hover!.dy * step; // col
      final hy = gridRect.top + hover!.dx * step; // row
      final stonePaint = Paint()
        ..color = Colors.black.withOpacity(0.25)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      canvas.drawCircle(Offset(hx, hy), step * 0.46, stonePaint);
    }

    // Draw selected intersection highlight (ring)
    if (selected != null) {
      final sx = gridRect.left + selected!.dy * step; // col
      final sy = gridRect.top + selected!.dx * step; // row
      final ringPaint = Paint()
        ..color = Colors.redAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = extent * 0.006
        ..isAntiAlias = true;
      canvas.drawCircle(Offset(sx, sy), step * 0.48, ringPaint);
    }
  }

  List<Offset> _starPoints(int n) {
    if (n == 19) {
      // 1-indexed: 4, 10, 16 but we store 0-index so 3, 9, 15
      const pts = [3, 9, 15];
      return [
        for (final r in pts)
          for (final c in pts) Offset(r.toDouble(), c.toDouble()),
      ];
    } else if (n == 13) {
      const pts = [3, 6, 9];
      return [
        for (final r in pts)
          for (final c in pts) Offset(r.toDouble(), c.toDouble()),
      ];
    } else if (n == 9) {
      const pts = [2, 4, 6];
      return [
        for (final r in pts)
          for (final c in pts) Offset(r.toDouble(), c.toDouble()),
      ];
    }
    return const [];
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    return oldDelegate.size != size ||
        oldDelegate.hover != hover ||
        oldDelegate.selected != selected;
  }
}
