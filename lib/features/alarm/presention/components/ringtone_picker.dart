import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// Utils
import '../../../../utils/ringtone_array.dart';
import '../../../../utils/format.dart';

class RingtoneSheet extends StatefulWidget {
  final String selectedRingtone;
  final void Function(String) onRingtoneChanged;

  const RingtoneSheet({
    super.key,
    required this.selectedRingtone,
    required this.onRingtoneChanged,
  });

  @override
  _RingtoneSheetState createState() => _RingtoneSheetState();
}

class _RingtoneSheetState extends State<RingtoneSheet> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPreview(String ringtone) async {
    await _audioPlayer.play(AssetSource("ringtones/$ringtone.mp3"));
  }

  void _selectRingtone(String ringtone) {
    widget.onRingtoneChanged(ringtone);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Ringtone',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(color: Theme.of(context).colorScheme.onSecondary),
          const SizedBox(height: 20),
          for (String ringtone in RingtoneArray.ringtones)
            ListTile(
              leading: IconButton(
                onPressed: () => _selectRingtone(ringtone),
                icon: Icon(
                  widget.selectedRingtone == ringtone
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: widget.selectedRingtone == ringtone
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                onPressed: () => _playPreview(ringtone),
              ),
              title: GestureDetector(
                onTap: () => _selectRingtone(ringtone),
                child: Text(Format.formatPlanLabel(ringtone)),
              ),
            ),
        ],
      ),
    );
  }
}

class RingtonePicker extends StatelessWidget {
  final String selectedRingtone;
  final void Function(String) onRingtoneChanged;

  const RingtonePicker({
    super.key,
    required this.selectedRingtone,
    required this.onRingtoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => RingtoneSheet(
            selectedRingtone: selectedRingtone,
            onRingtoneChanged: onRingtoneChanged,
          ),
          backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
        );
      },
      child: Text(
        Format.formatPlanLabel(selectedRingtone),
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
