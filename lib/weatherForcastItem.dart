import 'package:flutter/material.dart';

class Hourly_Forcast extends StatefulWidget {
  final String time;
  final dynamic icon;
  final String temp;
  const Hourly_Forcast({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  State<Hourly_Forcast> createState() => _Hourly_ForcastState();
}

class _Hourly_ForcastState extends State<Hourly_Forcast> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.3),
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              widget.time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (widget.icon is IconData)
              Icon(
                widget.icon,
                size: 32,
              )
            else
              widget.icon,
            const SizedBox(height: 8),
            Text(
              widget.temp,
            ),
          ],
        ),
      ),
    );

  }
}
