import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VisitForm extends StatefulWidget {
  const VisitForm({Key? key}) : super(key: key);

  @override
  State<VisitForm> createState() => _VisitFormState();
}

class _VisitFormState extends State<VisitForm> {
  final _formKey = GlobalKey<FormState>();
  String customerName = '';
  String purpose = '';
  String notes = '';
  bool isLoading = false;

  Future<void> addVisit() async {
    setState(() => isLoading = true);
    try {
      await Supabase.instance.client.from('visits').insert({
        'customer_name': customerName,
        'purpose': purpose,
        'notes': notes,
        'created_at': DateTime.now().toIso8601String(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visit added!')),
        );
        _formKey.currentState?.reset();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error:  ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Customer Name'),
            onSaved: (val) => customerName = val ?? '',
            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Purpose'),
            onSaved: (val) => purpose = val ?? '',
            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Notes'),
            onSaved: (val) => notes = val ?? '',
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      addVisit();
                    }
                  },
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Add Visit'),
          ),
        ],
      ),
    );
  }
}
