import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generatePDF(Map<String, dynamic> data) async {
  final pdf = pw.Document();
  final DateFormat dateFormat = DateFormat('dd MMM yyyy');

  pdf.addPage(
    pw.MultiPage(
      build: (context) {
        return [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Medical History Report',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Patient Information',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildInfoRow('Name', data['patient']['name'] ?? '-'),
                _buildInfoRow('Blood Type', data['patient']['blood_type'] ?? '-'),
                _buildInfoRow('Height', '${data['patient']['height'] ?? '-'} cm'),
                _buildInfoRow('Weight', '${data['patient']['weight'] ?? '-'} kg'),
                _buildInfoRow('Allergies', data['patient']['allergies'] ?? 'None'),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Medical Records',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          ...data['records'].map<pw.Widget>((record) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 10),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Dr. ${record['doctor_name'] ?? '-'}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        dateFormat.format(DateTime.parse(record['created_at'])),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    record['specialization'] ?? '-',
                    style: const pw.TextStyle(
                      color: PdfColors.grey,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  _buildRecordSection('Symptoms', record['symptoms'] ?? '-'),
                  _buildRecordSection('Diagnosis', record['diagnosis'] ?? '-'),
                  _buildRecordSection('Treatment', record['treatment'] ?? '-'),
                  if (record['notes'] != null && record['notes'].toString().isNotEmpty)
                    _buildRecordSection('Notes', record['notes']),
                ],
              ),
            );
          }).toList(),
        ];
      },
    ),
  );

  return pdf.save();
}

pw.Widget _buildInfoRow(String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      children: [
        pw.SizedBox(
          width: 100,
          child: pw.Text(
            label,
            style: const pw.TextStyle(
              color: PdfColors.grey,
            ),
          ),
        ),
        pw.Text(': '),
        pw.Text(value),
      ],
    ),
  );
}

pw.Widget _buildRecordSection(String label, String content) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 5),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(
            color: PdfColors.grey,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(content),
      ],
    ),
  );
}