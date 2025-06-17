import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HemsireNoteSheet extends StatefulWidget {
  final void Function(String noteText, DateTime dateTime)? onNoteSaved;

  const HemsireNoteSheet({super.key, this.onNoteSaved});

  @override
  State<HemsireNoteSheet> createState() => _HemsireNoteSheetState();
}

class _HemsireNoteSheetState extends State<HemsireNoteSheet> {
  DateTime selectedDateTime = DateTime.now();
  final TextEditingController _noteController = TextEditingController();

  final primaryBlue = const Color(0xFF3F72AF);
  final background = Colors.white;
  final actionGreen = const Color(0xFF4CAF50);
  final softRed = Colors.red.shade400;
  final textColor = Colors.grey.shade800;

  Future<void> _selectDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveNote() {
    final noteText = _noteController.text;
    if (noteText.isNotEmpty) {
      widget.onNoteSaved?.call(noteText, selectedDateTime);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not kaydedildi!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen bir açıklama giriniz.")),
      );
    }
  }

  @override
    Widget build(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height*.7, // Sheet yüksekliği sabitlendi
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: softRed, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Icon(Icons.note_alt_outlined, size: 48, color: primaryBlue),
                const SizedBox(height: 8),
                Text(
                  'Hemşire Notu',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => _selectDateTime(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 20, color: primaryBlue),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('dd.MM.yyyy HH:mm').format(selectedDateTime),
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.top,
                      controller: _noteController,
                      maxLines: null,
                      expands: true,
                      style: TextStyle(color: textColor, fontSize: 13),
                      decoration: InputDecoration(
                        label: Text("Açıklama"),
                        labelStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryBlue),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // %30'luk buton alanı
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check, color: Colors.white, size: 18),
                    label: Text(
                      'Ekle',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: actionGreen,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: _saveNote,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

  }

