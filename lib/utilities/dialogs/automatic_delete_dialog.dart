import 'package:flutter/material.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showAutomaticDeleteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: context.loc.delete,
    content: "To prevent missunderstandings old displays will be deleted automatically after two weeks. If you haven't found anyone until then please remeber to reset the deletion timer.",
    optionsBuilder: () => {
      context.loc.ok: null,
    },
  );
}
