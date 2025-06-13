//#TEMPLATE reuseable_memo_field
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:reusekit/core/theme/theme_config.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class QMemoField2 extends StatefulWidget {
  const QMemoField2({
    required this.onChanged,
    this.label,
    super.key,
    this.value,
    this.validator,
    this.hint,
    this.helper,
    this.maxLength,
    this.maxLines,
  });
  final String? label;
  final String? value;
  final String? hint;
  final String? helper;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? maxLines;
  final Function(String) onChanged;

  @override
  State<QMemoField2> createState() => _QMemoField2State();
}

class _QMemoField2State extends State<QMemoField2> {
  FocusNode focusNode = FocusNode();
  GlobalKey key = GlobalKey();
  late QuillController quillController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Scrollable.ensureVisible(
              key.currentContext!,
              alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
            ),
          );
        });
      }
    });

    Document doc = Document();
    if (widget.value != null && widget.value != "") {
      final delta = HtmlToDelta().convert(widget.value!);
      doc = Document.fromDelta(delta);
    }

    quillController = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );

    quillController.changes.listen((_) {
      //convert to html
      final deltaJson = quillController.document.toDelta().toJson();
      final converter = QuillDeltaToHtmlConverter(
        List.castFrom(deltaJson),
        ConverterOptions.forEmail(),
      );

      final html = converter.convert();
      widget.onChanged(html);
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    quillController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => Scrollable.ensureVisible(
            key.currentContext!,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          ),
        );
      });
    }
    return FormField<String>(
      key: key,
      validator: (value) {
        if (widget.validator == null) return null;
        //convert to html
        final deltaJson = quillController.document.toDelta().toJson();
        final converter = QuillDeltaToHtmlConverter(
          List.castFrom(deltaJson),
          ConverterOptions.forEmail(),
        );

        var html = converter.convert();
        if (html == "<p><br/></p>") {
          html = "";
        }
        return widget.validator!(html);
      },
      builder: (FormFieldState<String> field) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            errorText: field.errorText,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            fillColor: Colors.transparent,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            helperText: widget.helper,
            hintText: widget.hint,
            contentPadding: const EdgeInsets.all(0.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(spMd),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120.0,
                      child: LayoutBuilder(
                          builder: (context, BoxConstraints constraints) {
                        return SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: constraints.biggest.width * 1.4,
                                child: Transform.scale(
                                  scale: 0.7,
                                  alignment: Alignment.centerLeft,
                                  child: QuillSimpleToolbar(
                                    controller: quillController,
                                    config: QuillSimpleToolbarConfig(
                                      toolbarSectionSpacing: 0.0,
                                      buttonOptions:
                                          QuillSimpleToolbarButtonOptions(
                                        base: QuillToolbarBaseButtonOptions(
                                          iconTheme: QuillIconTheme(
                                            iconButtonUnselectedData:
                                                IconButtonData(
                                              padding: const EdgeInsets.all(4),
                                            ),
                                            iconButtonSelectedData:
                                                IconButtonData(
                                              padding: const EdgeInsets.all(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                    Divider(
                      color: Colors.grey[300]!,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        child: QuillEditor(
                          controller: quillController,
                          focusNode: focusNode,
                          scrollController: ScrollController(),
                          config: QuillEditorConfig(
                            placeholder: widget.hint ?? 'Type something...',
                            padding: const EdgeInsets.all(8.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//#END
