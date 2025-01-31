import 'package:feedback/src/better_feedback.dart';
import 'package:feedback/src/l18n/translation.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/material.dart';

/// Prompt the user for feedback using `StringFeedback`.
Widget simpleFeedbackBuilder(
  BuildContext context,
  OnSubmit onSubmit,
  ScrollController? scrollController,
  String? textFieldPlaceHolder,
  int? minimumLength,
) =>
    StringFeedback(
        onSubmit: onSubmit,
        scrollController: scrollController,
        textFieldPlaceHolder: textFieldPlaceHolder,
        minimumLength: minimumLength);

/// A form that prompts the user for feedback with a single text field.
/// This is the default feedback widget used by [BetterFeedback].
class StringFeedback extends StatefulWidget {
  /// Create a [StringFeedback].
  /// This is the default feedback bottom sheet, which is presented to the user.
  const StringFeedback({
    super.key,
    required this.onSubmit,
    required this.scrollController,
    required this.textFieldPlaceHolder,
    required this.minimumLength,
  });

  /// Should be called when the user taps the submit button.
  final OnSubmit onSubmit;

  /// Text field hint
  final String? textFieldPlaceHolder;

  /// Minimum length to enable button
  final int? minimumLength;

  /// A scroll controller that expands the sheet when it's attached to a
  /// scrollable widget and that widget is scrolled.
  ///
  /// Non null if the sheet is draggable.
  /// See: [FeedbackThemeData.sheetIsDraggable].
  final ScrollController? scrollController;

  @override
  State<StringFeedback> createState() => _StringFeedbackState();
}

class _StringFeedbackState extends State<StringFeedback> {
  late TextEditingController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView(
                controller: widget.scrollController,
                // Pad the top by 20 to match the corner radius if drag enabled.
                padding: EdgeInsets.fromLTRB(
                    16, widget.scrollController != null ? 20 : 16, 16, 0),
                children: <Widget>[
                  Text(
                    FeedbackLocalizations.of(context).feedbackDescriptionText,
                    maxLines: 2,
                    style:
                        FeedbackTheme.of(context).bottomSheetDescriptionStyle,
                  ),
                  TextField(
                    style: FeedbackTheme.of(context).bottomSheetTextInputStyle,
                    key: const Key('text_input_field'),
                    maxLines: 2,
                    minLines: 2,
                    controller: controller,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        hintText: widget.textFieldPlaceHolder,
                        hintStyle: TextStyle(color: Colors.grey)),
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                ],
              ),
              if (widget.scrollController != null)
                const FeedbackSheetDragHandle(),
            ],
          ),
        ),
        TextButton(
          key: const Key('submit_feedback_button'),
          onPressed: _shouldEnableButton()
              ? () => widget.onSubmit(controller.text)
              : null,
          child: Text(
            FeedbackLocalizations.of(context).submitButtonText,
            style: TextStyle(
              color: _shouldEnableButton()
                  ? FeedbackTheme.of(context).activeFeedbackModeColor
                  : Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  bool _shouldEnableButton() =>
      controller.text.length >= (widget.minimumLength ?? 0);
}
