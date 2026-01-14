import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
enum DateMode { day, month, year }

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryState();
}

class _HistoryState extends State<HistoryPage> {
  final TextEditingController _roomNameController = TextEditingController();
  File? _imageFile;
  DateMode _mode = DateMode.day;
  DateTime _selectedDate = DateTime(2026, 1, 1);
  int _selectedMonth = 1;
  int _selectedYear = 2026;

  final int _startYear = 2015;
  final int _endYear = 2026;

  String selectedRoom = 'Select';
  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  Widget _segmentedButton() {
    return Container(
      height: 44,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF053886),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: DateMode.values.map((mode) {
          final isActive = mode == _mode;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _mode = mode;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _label(mode),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                    isActive ? const Color(0xFF053886) : Colors.white,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(DateMode mode) {
    switch (mode) {
      case DateMode.day:
        return 'Day';
      case DateMode.month:
        return 'Monthly';
      case DateMode.year:
        return 'Year';
    }
  }

  Widget _buildPicker() {
    switch (_mode) {
      case DateMode.day:
        return _dayPicker();
      case DateMode.month:
        return _monthPicker();
        // return Text('Monthly');
      case DateMode.year:
        // return _yearPicker();
        return Text('Year');
    }
  }

  Widget _dayPicker() {
    final firstDayOfMonth = DateTime(_selectedYear, _selectedMonth, 1);
    final daysInMonth =
    DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);

    final startOffset = firstDayOfMonth.weekday % 7;

    final totalItems = startOffset + daysInMonth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(
          title: '${_monthNames[_selectedMonth - 1]} $_selectedYear',
          onPrev: () {
            setState(() {
              if (_selectedMonth == 1) {
                _selectedMonth = 12;
                _selectedYear--;
              } else {
                _selectedMonth--;
              }
            });
          },
          onNext: () {
            setState(() {
              if (_selectedMonth == 12) {
                _selectedMonth = 1;
                _selectedYear++;
              } else {
                _selectedMonth++;
              }
            });
          },
        ),
        const SizedBox(height: 8),
        _weekdayHeader(),
        const SizedBox(height: 8),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalItems,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (_, index) {
            if (index < startOffset) {
              return const SizedBox(); // EMPTY CELL
            }

            final day = index - startOffset + 1;

            final isSelected =
                _selectedDate.year == _selectedYear &&
                    _selectedDate.month == _selectedMonth &&
                    _selectedDate.day == day;

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  _selectedDate = DateTime(
                    _selectedYear,
                    _selectedMonth,
                    day,
                  );
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF053886)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _monthPicker() {
    return Column(
      children: [
        _header(
          title: '$_selectedYear',
          onPrev: () {
            setState(() {
              _selectedYear--;
            });
          },
          onNext: () {
            setState(() {
              _selectedYear++;
            });
          },
        ),
        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (_, i) {
            final month = i + 1;
            final isSelected = month == _selectedMonth;

            return _pickerItem(
              label: _monthNames[i],
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _selectedMonth = month;
                  _mode = DateMode.day;
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _yearPicker() {
    final years =
    List.generate(_endYear - _startYear + 1,
            (i) => _startYear + i);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: years.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final year = years[i];
        final isSelected = year == _selectedYear;

        return _pickerItem(
          label: year.toString(),
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _selectedYear = year;
              _mode = DateMode.month;
            });
          },
        );
      },
    );
  }

  Widget _pickerItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
          isSelected ? const Color(0xFF053886) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF053886)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF053886),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _header({
    required String title,
    required VoidCallback onPrev,
    required VoidCallback onNext,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: onPrev,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: onNext,
        ),
      ],
    );
  }

  Widget _weekdayHeader() {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map(
            (d) => Expanded(
          child: Center(
            child: Text(
              d,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      )
          .toList(),
    );
  }

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Room",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: selectedRoom,
                isExpanded: true,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Select', child: Text('Select')),
                  DropdownMenuItem(value: 'Kitchen', child: Text('Kitchen')),
                  DropdownMenuItem(value: 'Bedroom', child: Text('Bedroom')),
                  DropdownMenuItem(value: 'Living Room', child: Text('Living Room')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRoom = value!;
                  });
                },
              ),

              const SizedBox(height: 12),
              const Text(
                "Select",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              _segmentedButton(),
              const SizedBox(height: 8),
              AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: _buildPicker()),

            ],
          ),
        ),
      ),
    );
  }


}
