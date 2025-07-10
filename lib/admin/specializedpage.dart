import 'package:flutter/material.dart';

class SpecializationAdminPage extends StatefulWidget {
  const SpecializationAdminPage({super.key});

  @override
  State<SpecializationAdminPage> createState() =>
      _SpecializationAdminPageState();
}

class _SpecializationAdminPageState extends State<SpecializationAdminPage> {
  List<Map<String, String>> specializations = [
    {"id": "1", "name": "Cardiologist"},
    {"id": "2", "name": "Dermatologist"},
  ];

  final TextEditingController _nameController = TextEditingController();
  String? editingId;

  void openSpecializationDialog({Map<String, String>? existing}) {
    if (existing != null) {
      editingId = existing["id"];
      _nameController.text = existing["name"]!;
    } else {
      editingId = null;
      _nameController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            editingId == null ? "Add Specialization" : "Edit Specialization"),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: "Specialization Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isEmpty) return;

              setState(() {
                if (editingId == null) {
                  // Create
                  specializations.add({
                    "id": DateTime.now().toString(),
                    "name": name,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Specialization added")),
                  );
                } else {
                  // Edit
                  final index =
                      specializations.indexWhere((e) => e["id"] == editingId);
                  if (index != -1) {
                    specializations[index]["name"] = name;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Specialization updated")),
                    );
                  }
                }
              });

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void deleteSpecialization(String id) {
    setState(() {
      specializations.removeWhere((s) => s["id"] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Specialization deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                const Icon(Icons.arrow_back_ios_new),
                const SizedBox(
                  width: 30,
                ),
                const Text(
                  'Manage Specialiation',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  width: 120,
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => openSpecializationDialog(),
                ),
              ],
            ),
            DataTable(
              columns: const [
                DataColumn(label: Text("Name")),
                DataColumn(
                    label: Row(
                  children: [
                    SizedBox(
                      width: 130,
                    ),
                    Text("Actions"),
                  ],
                )),
              ],
              rows: specializations.map((specialization) {
                return DataRow(
                  cells: [
                    DataCell(Text(specialization["name"]!)),
                    DataCell(Row(
                      children: [
                        const SizedBox(
                          width: 130,
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Color(0xFF1CA4AC)),
                          onPressed: () => openSpecializationDialog(
                              existing: specialization),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              deleteSpecialization(specialization["id"]!),
                        ),
                      ],
                    )),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
