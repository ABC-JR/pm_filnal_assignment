import 'package:first_video/features/home/data/model/spam_response.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AiAnalysisCard extends StatefulWidget {
  final SpamResponse res;

  const AiAnalysisCard({super.key, required this.res});

  @override
  State<AiAnalysisCard> createState() => _AiAnalysisCardState();
}

class _AiAnalysisCardState extends State<AiAnalysisCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.res.confidence.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AiAnalysisCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.res.confidence != widget.res.confidence) {
      _animation =
          Tween<double>(
            begin: 0,
            end: widget.res.confidence.toDouble(),
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          );

      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final res = widget.res;

    /// 🔥 SAFE LOGIC
    final confidence = res.confidence;
    final reasons = res.reasons;

    String emoji;
    String tone;
    String interpretation;
    String advice;
    Color color;

    if (confidence <= 30) {
      emoji = "✅";
      tone = "Low Risk";
      color = Colors.green;
      interpretation = "This message appears safe.";
      advice = "No action needed.";
    } else if (confidence <= 70) {
      emoji = "⚠️";
      tone = "Moderate Risk";
      color = Colors.orange;
      interpretation = "Some suspicious patterns detected.";
      advice = "Be careful.";
    } else {
      emoji = "❌";
      tone = "High Risk";
      color = Colors.red;
      interpretation = "Highly likely spam.";
      advice = "Do not interact.";
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 HEADER
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 8),
              Text(
                tone,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 📊 ANIMATED GAUGE
          SizedBox(
            height: 160,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SizedBox(
                  height: 180, // 👈 только для gauge
                  child: SfRadialGauge(
                    axes: [
                      RadialAxis(
                        minimum: 0,
                        maximum: 100,
                        ranges: [
                          GaugeRange(
                            startValue: 0,
                            endValue: 30,
                            color: Colors.green,
                          ),
                          GaugeRange(
                            startValue: 30,
                            endValue: 70,
                            color: Colors.orange,
                          ),
                          GaugeRange(
                            startValue: 70,
                            endValue: 100,
                            color: Colors.red,
                          ),
                        ],
                        pointers: [
                          NeedlePointer(
                            value: _animation.value,
                            enableAnimation: false, // важно!
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          /// Verdict + Confidence
          Text(
            'Verdict: ${res.verdict}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Confidence: $confidence% | Score: ${res.score}/10",
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 12),

          /// Interpretation
          Text(interpretation, style: const TextStyle(fontSize: 16)),

          const SizedBox(height: 10),

          /// Reasons
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: reasons
                .map(
                  (e) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• "),
                      Expanded(child: Text(e)),
                    ],
                  ),
                )
                .toList(),
          ),


          const SizedBox(height: 12),
            Text(
                                      "\nUsers are strongly advised to exercise caution when interacting with this message. \nAvoid clicking unknown links, sharing sensitive information, or engaging with suspicious content.",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                          const SizedBox(height: 12),

          /// Recommendation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "$advice\n\n${res.summary}",
                    style: TextStyle(color: color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
